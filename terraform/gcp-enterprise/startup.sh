#!/bin/bash
# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Script de demarrage pour VM NemoClaw Entreprise (GPU).
# Execute une seule fois au premier boot via GCP metadata_startup_script.
#
# Strategie :
#   Etapes 1-7 : Socle securite + Docker + NVIDIA Container Toolkit
#   Etape 8    : Installation NemoClaw via le script officiel NVIDIA
#                (gere Node.js, OpenShell, NemoClaw, onboarding)
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

echo "=== [1/8] Mise a jour systeme ==="
apt-get update && apt-get upgrade -y

echo "=== [2/8] Installation Docker ==="
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

echo "=== [3/8] Installation NVIDIA Container Toolkit ==="
if ! command -v nvidia-ctk &>/dev/null; then
  curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
  curl -fsSL https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
    | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
    > /etc/apt/sources.list.d/nvidia-container-toolkit.list
  apt-get update
  apt-get install -y nvidia-container-toolkit
  nvidia-ctk runtime configure --runtime=docker
  systemctl restart docker
fi

echo "=== [4/8] Installation Tailscale ==="
if ! command -v tailscale &>/dev/null; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi

if [ -n "$TAILSCALE_AUTH_KEY" ]; then
  tailscale up --authkey="$TAILSCALE_AUTH_KEY" --accept-routes
  echo "Tailscale connecte"
fi

echo "=== [5/8] Creation utilisateur admin ==="
if ! id "$ADMIN_USER" &>/dev/null; then
  useradd -m -s /bin/bash -G sudo "$ADMIN_USER"
  echo "$ADMIN_USER ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$ADMIN_USER"
  chmod 440 "/etc/sudoers.d/$ADMIN_USER"
fi

# GCP injecte la cle SSH via metadata
if [ -d "/home/$ADMIN_USER/.ssh" ]; then
  chmod 700 "/home/$ADMIN_USER/.ssh"
  chmod 600 "/home/$ADMIN_USER/.ssh/authorized_keys" 2>/dev/null || true
  chown -R "$ADMIN_USER:$ADMIN_USER" "/home/$ADMIN_USER/.ssh"
fi

# Ajouter l'admin au groupe docker
usermod -aG docker "$ADMIN_USER" 2>/dev/null || true

echo "=== [6/8] Durcissement SSH ==="
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

echo "=== [7/8] Installation fail2ban + mises a jour automatiques ==="
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

echo "=== [8/8] Installation NemoClaw (script officiel NVIDIA) ==="
# Telecharger le script d'installation NemoClaw
curl -fsSL https://www.nvidia.com/nemoclaw.sh -o /tmp/nemoclaw-install.sh
chmod +x /tmp/nemoclaw-install.sh

# Executer en tant que l'utilisateur admin avec un environnement propre
# Le script gere : Node.js (nvm), NemoClaw CLI (GitHub), OpenShell CLI
# L'onboarding echouera en non-interactive sans cle API — c'est attendu.
# L'admin lancera `nemoclaw onboard` manuellement via SSH.
su - "$ADMIN_USER" -c "bash /tmp/nemoclaw-install.sh --non-interactive" 2>&1 || {
  echo ""
  echo "============================================="
  echo "  WARN: Onboarding NemoClaw a echoue (cle API manquante)"
  echo "  NemoClaw CLI est installe. Lancer l'onboarding manuellement :"
  echo "    nemoclaw onboard"
  echo "============================================="
}

# Marquer le script comme execute
touch "$MARKER"

TAILSCALE_IP=$(tailscale ip -4 2>/dev/null || echo "non configure")

echo ""
echo "============================================="
echo "  NemoClaw Enterprise VM - Prete"
echo "============================================="
echo "  Tailscale : $TAILSCALE_IP"
echo "  SSH port  : $SSH_PORT"
echo "  Admin     : $ADMIN_USER"
echo "  GPU       : $(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null || echo 'non detecte')"
echo ""
echo "  Connexion :"
echo "    ssh -p $SSH_PORT $ADMIN_USER@$TAILSCALE_IP"
echo "    nemoclaw onboard"
echo "============================================="
