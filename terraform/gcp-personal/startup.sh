#!/bin/bash
# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Script de demarrage pour VM NemoClaw Personnel (CPU).
# Execute une seule fois au premier boot via GCP metadata_startup_script.
#
# Strategie :
#   Etapes 1-6 : Socle securite (Tailscale, SSH, fail2ban, mises a jour)
#   Etape 7    : Installation NemoClaw via le script officiel NVIDIA
#                (gere Node.js, Docker, OpenShell, NemoClaw, onboarding)
#
# Le script install.sh de NemoClaw est execute en tant que l'utilisateur admin
# avec HOME correctement defini, en mode --non-interactive.

set -euo pipefail

MARKER="/var/lib/nemoclaw-startup-done"
if [ -f "$MARKER" ]; then
  echo "NemoClaw startup deja execute, skip."
  exit 0
fi

export DEBIAN_FRONTEND=noninteractive

# --- Recuperer les metadata GCP ---
metadata() {
  curl -sf -H "Metadata-Flavor: Google" \
    "http://metadata.google.internal/computeMetadata/v1/instance/attributes/$1" 2>/dev/null || echo "$2"
}

ADMIN_USER=$(metadata "admin-user" "nemoclaw-admin")
SSH_PORT=$(metadata "ssh-port" "2222")
TAILSCALE_AUTH_KEY=$(metadata "tailscale-auth-key" "")

echo "=== [1/7] Mise a jour systeme ==="
apt-get update && apt-get upgrade -y

echo "=== [2/7] Installation Tailscale ==="
if ! command -v tailscale &>/dev/null; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi

if [ -n "$TAILSCALE_AUTH_KEY" ]; then
  tailscale up --authkey="$TAILSCALE_AUTH_KEY" --accept-routes
  echo "Tailscale connecte"
fi

echo "=== [3/7] Creation utilisateur admin ==="
if ! id "$ADMIN_USER" &>/dev/null; then
  useradd -m -s /bin/bash -G sudo "$ADMIN_USER"
  echo "$ADMIN_USER ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$ADMIN_USER"
  chmod 440 "/etc/sudoers.d/$ADMIN_USER"
fi

# GCP injecte la cle SSH dans /home/$ADMIN_USER/.ssh/authorized_keys via metadata
# On s'assure que les permissions sont correctes
if [ -d "/home/$ADMIN_USER/.ssh" ]; then
  chmod 700 "/home/$ADMIN_USER/.ssh"
  chmod 600 "/home/$ADMIN_USER/.ssh/authorized_keys" 2>/dev/null || true
  chown -R "$ADMIN_USER:$ADMIN_USER" "/home/$ADMIN_USER/.ssh"
fi

echo "=== [4/7] Durcissement SSH ==="
cat > /etc/ssh/sshd_config.d/nemoclaw-hardening.conf <<SSHEOF
Port $SSH_PORT
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
AuthenticationMethods publickey
KbdInteractiveAuthentication no
X11Forwarding no
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
SSHEOF

systemctl restart sshd

echo "=== [5/7] Installation fail2ban ==="
if ! command -v fail2ban-client &>/dev/null; then
  apt-get install -y fail2ban

  cat > /etc/fail2ban/jail.d/nemoclaw.conf <<F2BEOF
[sshd]
enabled  = true
port     = $SSH_PORT
filter   = sshd
logpath  = /var/log/auth.log
maxretry = 3
bantime  = 3600
findtime = 600
F2BEOF

  systemctl enable fail2ban
  systemctl restart fail2ban
fi

echo "=== [6/7] Mises a jour automatiques ==="
apt-get install -y unattended-upgrades apt-listchanges
cat > /etc/apt/apt.conf.d/50unattended-upgrades <<UUEOF
Unattended-Upgrade::Allowed-Origins {
    "\${distro_id}:\${distro_codename}";
    "\${distro_id}:\${distro_codename}-security";
};
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";
UUEOF

cat > /etc/apt/apt.conf.d/20auto-upgrades <<AUEOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
AUEOF

echo "=== [7/7] Installation NemoClaw (script officiel NVIDIA) ==="
# Le script install.sh de NemoClaw gere :
#   - Node.js (via nvm si absent)
#   - Docker (prerequis verifie par le preflight)
#   - NemoClaw CLI (clone GitHub + build + link)
#   - OpenShell CLI (installe automatiquement)
#   - Onboarding (--non-interactive skip les prompts)
#
# On l'execute en tant que l'utilisateur admin pour que :
#   - HOME est correctement defini (~/$ADMIN_USER)
#   - nvm s'installe dans le bon home
#   - nemoclaw s'installe dans le bon PATH
#   - Les credentials et l'etat sont dans le bon home

# Installer Docker en amont (prerequis de NemoClaw)
if ! command -v docker &>/dev/null; then
  apt-get install -y ca-certificates curl gnupg
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  chmod a+r /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" \
    > /etc/apt/sources.list.d/docker.list
  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  systemctl enable docker
  systemctl start docker
fi

# Ajouter l'admin au groupe docker
usermod -aG docker "$ADMIN_USER" 2>/dev/null || true

# Telecharger le script d'installation NemoClaw
curl -fsSL https://www.nvidia.com/nemoclaw.sh -o /tmp/nemoclaw-install.sh
chmod +x /tmp/nemoclaw-install.sh

# Executer en tant que l'utilisateur admin avec un environnement propre
su - "$ADMIN_USER" -c "bash /tmp/nemoclaw-install.sh --non-interactive" 2>&1 || {
  echo ""
  echo "============================================="
  echo "  WARN: Installation NemoClaw automatique echouee"
  echo "  Lancer manuellement apres connexion SSH :"
  echo "    curl -fsSL https://www.nvidia.com/nemoclaw.sh | bash"
  echo "============================================="
}

# Marquer le script comme execute
touch "$MARKER"

TAILSCALE_IP=$(tailscale ip -4 2>/dev/null || echo "non configure")

echo ""
echo "============================================="
echo "  NemoClaw Personal VM - Prete"
echo "============================================="
echo "  Tailscale : $TAILSCALE_IP"
echo "  SSH port  : $SSH_PORT"
echo "  Admin     : $ADMIN_USER"
echo ""
echo "  Connexion :"
echo "    ssh -p $SSH_PORT $ADMIN_USER@$TAILSCALE_IP"
echo "============================================="
