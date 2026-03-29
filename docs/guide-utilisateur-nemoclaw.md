# Guide Utilisateur NemoClaw

> **Version** : 0.1.0 (alpha) — Mars 2026
> **Langue** : Francais — Les termes techniques restent dans leur forme originale.

---

## Sommaire

- [1. Definition de NemoClaw](#1-definition-de-nemoclaw)
  - [1.1 Ce que NemoClaw est (et ce qu'il n'est pas)](#11-ce-que-nemoclaw-est-et-ce-quil-nest-pas)
  - [1.2 Dependances externes](#12-dependances-externes)
  - [1.3 Double role du plugin](#13-double-role-du-plugin)
- [2. Architecture](#2-architecture)
  - [2.1 Vue d'ensemble des trois composants](#21-vue-densemble-des-trois-composants)
  - [2.2 Diagramme d'architecture globale](#22-diagramme-darchitecture-globale)
  - [2.3 Les 4 couches de securite](#23-les-4-couches-de-securite)
  - [2.4 Diagramme des couches de securite](#24-diagramme-des-couches-de-securite)
  - [2.5 Routage d'inference](#25-routage-dinference)
  - [2.6 Cycle de vie du deploiement](#26-cycle-de-vie-du-deploiement)
- [3. Installation pas-a-pas](#3-installation-pas-a-pas)
  - [3.1 Pre-requis materiels et logiciels](#31-pre-requis-materiels-et-logiciels)
  - [3.2 Installation de Node.js](#32-installation-de-nodejs)
  - [3.3 Installation de NemoClaw CLI](#33-installation-de-nemoclaw-cli)
  - [3.4 Installation d'OpenShell CLI](#34-installation-dopenshell-cli)
- [4. Procedure d'onboarding](#4-procedure-donboarding)
  - [4.1 Etape 1 : Verifications prealables](#41-etape-1--verifications-prealables)
  - [4.2 Etape 2 : Configuration de l'inference](#42-etape-2--configuration-de-linference)
  - [4.3 Etape 3 : Demarrage du Gateway OpenShell](#43-etape-3--demarrage-du-gateway-openshell)
  - [4.4 Etape 4 : Creation du Sandbox](#44-etape-4--creation-du-sandbox)
  - [4.5 Etape 5 : Configuration de la route d'inference](#45-etape-5--configuration-de-la-route-dinference)
  - [4.6 Etape 6 : Configuration d'OpenClaw dans le sandbox](#46-etape-6--configuration-dopenclaw-dans-le-sandbox)
  - [4.7 Etape 7 : Application des presets de politiques](#47-etape-7--application-des-presets-de-politiques)
  - [4.8 Mode non-interactif](#48-mode-non-interactif)
- [5. Provisionnement GCP avec Terraform](#5-provisionnement-gcp-avec-terraform)
  - [5.1 Presentation des deux profils](#51-presentation-des-deux-profils)
  - [5.2 Profil Entreprise](#52-profil-entreprise)
  - [5.3 Profil Personnel](#53-profil-personnel)
  - [5.4 Complementarite VPC + Tailscale](#54-complementarite-vpc--tailscale)
  - [5.5 Utilisation](#55-utilisation)
  - [5.6 Remarque : onboarding automatise](#56-remarque--onboarding-automatise)
- [6. Durcissement de securite](#6-durcissement-de-securite)
  - [6.1 Mot de passe root robuste](#61-mot-de-passe-root-robuste)
  - [6.2 Cle SSH ED25519](#62-cle-ssh-ed25519)
  - [6.3 Configuration SSH avancee](#63-configuration-ssh-avancee)
  - [6.4 Acces sans root](#64-acces-sans-root)
  - [6.5 fail2ban](#65-fail2ban)
  - [6.6 Mises a jour automatiques](#66-mises-a-jour-automatiques)
  - [6.7 Firewall strict](#67-firewall-strict)
  - [6.8 Tailscale : installation et mode invisible](#68-tailscale--installation-et-mode-invisible)
  - [6.9 Options entreprise avancees](#69-options-entreprise-avancees)
- [7. Publics cibles et parcours](#7-publics-cibles-et-parcours)
  - [7.1 DevOps / SRE](#71-devops--sre)
  - [7.2 Developpeurs](#72-developpeurs)
- [8. Administration operationnelle](#8-administration-operationnelle)
  - [8.1 Problematique : scripts absents de la VM](#81-problematique--scripts-absents-de-la-vm)
  - [8.2 Script de backup/restore du workspace](#82-script-de-backuprestore-du-workspace)
  - [8.3 Installation du script sur la VM](#83-installation-du-script-sur-la-vm)
  - [8.4 Utilisation](#84-utilisation)
  - [8.5 Backup automatique avec cron](#85-backup-automatique-avec-cron)
  - [8.6 Fichiers du workspace OpenClaw](#86-fichiers-du-workspace-openclaw)
  - [8.7 Persistence et cycle de vie](#87-persistence-et-cycle-de-vie)
- [9. Audits et Observabilite](#9-audits-et-observabilite)
  - [9.1 Vue d'ensemble](#91-vue-densemble)
  - [9.2 Verification de sante du sandbox](#92-verification-de-sante-du-sandbox)
  - [9.3 Logs du sandbox](#93-logs-du-sandbox)
  - [9.4 TUI : monitoring reseau temps reel](#94-tui--monitoring-reseau-temps-reel)
  - [9.5 Test d'inference](#95-test-dinference)
  - [9.6 Collecte de diagnostics](#96-collecte-de-diagnostics)
  - [9.7 Commande slash /nemoclaw status](#97-commande-slash-nemoclaw-status)
  - [9.8 Lacunes a combler](#98-lacunes-a-combler)
- [10. Retour d'experience : deploiement reel](#10-retour-dexperience--deploiement-reel)
  - [10.1 Contexte du deploiement](#101-contexte-du-deploiement)
  - [10.2 Ecueils rencontres et solutions](#102-ecueils-rencontres-et-solutions)
  - [10.3 Procedure validee de bout en bout](#103-procedure-validee-de-bout-en-bout)
  - [10.4 Lecons apprises](#104-lecons-apprises)
- [11. Axes de reflexion et evolutions](#11-axes-de-reflexion-et-evolutions)
  - [11.1 Onboarding entierement automatise](#111-onboarding-entierement-automatise)
  - [11.2 Industrialisation via service web](#112-industrialisation-via-service-web)
  - [11.3 Autres evolutions envisagees](#113-autres-evolutions-envisagees)
- [Annexes](#annexes)
  - [A. Glossaire](#a-glossaire)
  - [B. Liens utiles](#b-liens-utiles)
  - [C. Depannage courant](#c-depannage-courant)

---

## 1. Definition de NemoClaw

### 1.1 Ce que NemoClaw est (et ce qu'il n'est pas)

NemoClaw **n'est pas un client** d'OpenClaw. C'est un **harnais de deploiement securise** (_secure deployment harness_) qui :

- **Enveloppe** un agent OpenClaw dans un sandbox OpenShell isole
- **Interpose 4 couches de controle** entre l'agent et le monde exterieur : reseau, systeme de fichiers, processus, inference
- **Fournit un cycle de vie declaratif** via des blueprints versiones, immutables et verifies par digest
- **Orchestre** la creation, la configuration, le suivi et le rollback de sandboxes

Sans NemoClaw, OpenClaw s'execute directement sur la machine hote avec un acces libre au reseau, au systeme de fichiers et aux APIs d'inference. NemoClaw ajoute les garde-fous qui rendent l'execution autonome d'agents plus sure.

> **Alpha** : NemoClaw est disponible en preview depuis mars 2026. Les APIs, schemas de configuration et comportements runtime sont susceptibles de changer entre les versions. Ne pas utiliser en production.

### 1.2 Dependances externes

NemoClaw fait le pont entre deux projets distincts :

| Projet | Role | Version |
|--------|------|---------|
| **OpenClaw** | L'agent autonome ("always-on assistant") | 2026.3.11 |
| **OpenShell** | Le runtime sandbox (conteneur isole + gateway) | >= 0.1.0 |

NemoClaw n'est ni OpenClaw ni OpenShell — c'est la **couche d'orchestration** qui les relie de maniere securisee.

### 1.3 Double role du plugin

Une fois le sandbox cree, NemoClaw joue un double role **a l'interieur** du sandbox :

1. **Commande slash `/nemoclaw`** — Accessible depuis l'interface chat de l'agent, elle permet d'executer `status`, `eject` et `onboard help` directement depuis la conversation.

2. **Provider d'inference** — Enregistre sous l'identifiant `inference` (aliases : `inference-local`, `nemoclaw`), il expose les modeles NVIDIA Nemotron au runtime OpenClaw. L'agent appelle `inference.local`, et le plugin route la requete vers l'endpoint reel configure cote hote.

---

## 2. Architecture

### 2.1 Vue d'ensemble des trois composants

Le depot est organise en trois modules :

**`bin/`** — Point d'entree CLI (CommonJS, Node.js)

Le script `bin/nemoclaw.js` est execute sur la **machine hote**. Il expose les commandes globales :

| Commande | Description |
|----------|-------------|
| `nemoclaw onboard` | Assistant interactif de configuration |
| `nemoclaw list` | Lister les sandboxes existants |
| `nemoclaw <nom> connect` | Ouvrir un shell dans le sandbox |
| `nemoclaw <nom> status` | Verifier la sante du sandbox |
| `nemoclaw <nom> logs [--follow]` | Consulter les logs |
| `nemoclaw <nom> destroy` | Supprimer le sandbox |
| `nemoclaw <nom> policy-add` | Ajouter un preset de politique |
| `nemoclaw <nom> policy-list` | Lister les presets |
| `nemoclaw start` | Demarrer les services auxiliaires (Telegram, tunnel) |
| `nemoclaw stop` | Arreter les services |
| `nemoclaw status` | Etat des sandboxes + services |
| `nemoclaw debug` | Collecter les diagnostics |
| `nemoclaw uninstall` | Desinstaller NemoClaw |

Les modules dans `bin/lib/` gerent les concerns transversaux : `credentials.js` (cles API), `inference-config.js` (selection modele/fournisseur), `policies.js` (regles reseau), `platform.js` (detection Linux/macOS/WSL), `preflight.js` (verifications prealables), `registry.js` (suivi des sandboxes).

**`nemoclaw/`** — Plugin TypeScript (ES2022, bundler module resolution)

S'enregistre via l'API OpenClaw Plugin SDK a l'interieur du sandbox. Modules cles :

| Module | Responsabilite |
|--------|---------------|
| `src/blueprint/runner.ts` | Orchestre le cycle de vie (plan/apply/status/rollback). Emet `PROGRESS:<0-100>:<label>` et `RUN_ID:<id>` sur stdout. |
| `src/blueprint/state.ts` | Persistance de l'etat dans `~/.nemoclaw/state/nemoclaw.json` |
| `src/blueprint/ssrf.ts` | Validation SSRF des endpoints (bloque les IP privees, schema http/https uniquement) |
| `src/blueprint/snapshot.ts` | Snapshots de migration (capture/restauration de la config hote) |
| `src/commands/slash.ts` | Gestionnaire de la commande `/nemoclaw` |
| `src/onboard/config.ts` | Configuration des providers (build, openai, anthropic, gemini, ncp, nim-local, vllm, ollama, custom) |

**`nemoclaw-blueprint/`** — Blueprint Python avec configuration YAML

Le fichier `blueprint.yaml` definit de maniere declarative :
- L'image sandbox (`ghcr.io/nvidia/openshell-community/sandboxes/openclaw:latest`)
- 4 profils d'inference : `default` (NVIDIA Endpoints), `ncp` (NVIDIA Cloud Partner), `nim-local` (NIM local), `vllm` (vLLM local)
- Les ajouts de politique reseau

Le repertoire `policies/` contient la politique de base (`openclaw-sandbox.yaml`) et 9 presets d'integration (npm, pypi, docker, slack, telegram, discord, huggingface, jira, outlook).

### 2.2 Diagramme d'architecture globale

```mermaid
flowchart TB
    subgraph Hote["Machine Hote"]
        USER["Utilisateur"]
        CLI["bin/nemoclaw.js<br/>CLI (CommonJS)"]
        ONBOARD["bin/lib/onboard.js<br/>Assistant interactif"]
        PLUGIN["nemoclaw/<br/>Plugin TypeScript"]
        RUNNER["blueprint/runner.ts<br/>plan | apply | status | rollback"]
        STATE["~/.nemoclaw/state/<br/>nemoclaw.json"]
        BLUEPRINT["nemoclaw-blueprint/<br/>blueprint.yaml + policies/"]
        OPENSHELL["OpenShell CLI<br/>sandbox | gateway | provider | policy"]
        CREDS["~/.nemoclaw/credentials.json<br/>(chmod 600)"]

        USER --> CLI
        CLI --> ONBOARD
        ONBOARD --> PLUGIN
        PLUGIN --> RUNNER
        RUNNER --> BLUEPRINT
        RUNNER --> OPENSHELL
        RUNNER --> STATE
        ONBOARD --> CREDS
    end

    subgraph Sandbox["OpenShell Sandbox (conteneur Docker)"]
        AGENT["OpenClaw Agent"]
        SLASH["/nemoclaw<br/>commande slash"]
        PROVIDER["Provider inference<br/>(inference.local)"]
        GATEWAY["Gateway OpenClaw<br/>(utilisateur: gateway)"]
        POLICY["Politique reseau<br/>(deny-by-default)"]
        FS["Isolation filesystem<br/>(Landlock + DAC)"]

        AGENT --> SLASH
        AGENT --> PROVIDER
        GATEWAY --- POLICY
        GATEWAY --- FS
    end

    OPENSHELL -->|"cree et configure"| Sandbox
    PROVIDER -->|"route via gateway"| OPENSHELL
    PLUGIN -->|"s'enregistre dans"| AGENT
```

### 2.3 Les 4 couches de securite

#### Couche 1 : Reseau (Network Policies)

**Principe** : _deny-by-default_. Toute connexion sortante est bloquee sauf celles explicitement autorisees.

Chaque regle de la politique reseau definit :
- **Hote + port** : ex. `api.anthropic.com:443`
- **Protocole** : `rest` avec terminaison TLS (`tls: terminate`)
- **Methodes HTTP** : ex. `GET`, `POST`, ou `*`
- **Chemins** : ex. `/bot*/**`
- **Binaires autorises** : ex. `/usr/local/bin/claude` uniquement

Lorsque l'agent tente d'acceder a un endpoint non liste, OpenShell **bloque la requete** et la remonte dans le TUI (Terminal UI) pour approbation par l'operateur. Les approbations sont valides pour la session en cours mais ne sont pas persistees dans la politique de base.

**Endpoints de la politique par defaut** :

| Groupe | Endpoints | Binaires |
|--------|-----------|----------|
| Claude Code | `api.anthropic.com`, `statsig.anthropic.com`, `sentry.io` | `/usr/local/bin/claude` |
| NVIDIA | `integrate.api.nvidia.com`, `inference-api.nvidia.com` | `claude`, `openclaw` |
| GitHub | `github.com`, `api.github.com` | `gh`, `git` |
| OpenClaw | `clawhub.com`, `openclaw.ai`, `docs.openclaw.ai` | `openclaw` |
| npm | `registry.npmjs.org` | `openclaw`, `npm` |
| Telegram | `api.telegram.org` (paths `/bot*/**` uniquement) | `node` |
| Discord | `discord.com`, `gateway.discord.gg`, `cdn.discordapp.com` | `node` |

#### Couche 2 : Systeme de fichiers (Landlock + DAC)

L'architecture de fichiers du sandbox utilise une **separation config immutable / etat mutable** :

```
/sandbox/
  .openclaw/                  ← LECTURE SEULE (root:root, chmod 755)
    openclaw.json             ← Config immutable (chmod 444, hash SHA256 verifie au boot)
    agents -> .openclaw-data/agents      ← Symlinks vers le repertoire mutable
    extensions -> .openclaw-data/extensions
    workspace -> .openclaw-data/workspace
    skills -> .openclaw-data/skills
    hooks -> .openclaw-data/hooks
    ...
  .openclaw-data/             ← LECTURE-ECRITURE (sandbox:sandbox)
    agents/                   ← Etat mutable des agents
    extensions/
    workspace/
    ...
```

**Zones de fichiers** :

| Zone | Acces | Contenu |
|------|-------|---------|
| `/sandbox`, `/tmp` | Lecture-ecriture | Espace de travail de l'agent |
| `/sandbox/.openclaw` | Lecture seule | Config gateway, tokens, CORS |
| `/sandbox/.openclaw-data` | Lecture-ecriture | Etat agent/plugins via symlinks |
| `/usr`, `/lib`, `/proc`, `/etc` | Lecture seule | Systeme |

La protection est en double couche :
1. **DAC** (Discretionary Access Control) : `openclaw.json` est chown `root:root`, chmod `444`
2. **Landlock** : le repertoire `.openclaw` est marque `read_only` dans la politique, avec `compatibility: best_effort`

#### Couche 3 : Processus (separation de privileges)

Le Dockerfile cree deux utilisateurs distincts :

| Utilisateur | Role | Pourquoi |
|-------------|------|----------|
| `gateway` | Execute le gateway OpenClaw | L'agent (sandbox) ne peut ni le tuer, ni le redemarrer avec une config modifiee |
| `sandbox` | Execute l'agent OpenClaw | Droits reduits, UID separe |

Le script d'entree (`nemoclaw-start.sh`) :
1. Demarre en `root` pour initialisation
2. Lance le gateway en tant que `gateway` via **gosu** v1.19 (binaire verifie par SHA256)
3. Drop les privileges a `sandbox` pour l'agent
4. Verifie l'integrite de `openclaw.json` via un hash SHA256 calcule au build

#### Couche 4 : Inference (routage isole)

Les requetes d'inference de l'agent ne quittent **jamais** le sandbox directement :

1. L'agent appelle `https://inference.local/v1` (endpoint virtuel)
2. Le gateway OpenShell intercepte la requete
3. Le gateway injecte les credentials API (stockees cote hote uniquement)
4. La requete est acheminee vers le provider reel (NVIDIA, OpenAI, etc.)

Les credentials API ne sont **jamais** exposees a l'interieur du sandbox. La validation SSRF (`ssrf.ts`) bloque les tentatives de routage vers des adresses privees :
- IPv4 : `127.0.0.0/8`, `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`, `169.254.0.0/16`
- IPv6 : `::1/128`, `fd00::/8`, adresses IPv4-mapped
- Schemas : seuls `http://` et `https://` sont autorises

### 2.4 Diagramme des couches de securite

```mermaid
flowchart LR
    AGENT["Agent OpenClaw<br/>(utilisateur: sandbox)"]

    subgraph Couche1["Couche 1 : Reseau"]
        NET["Politique deny-by-default<br/>Regles par hote/port/binaire<br/>Approbation operateur TUI"]
    end

    subgraph Couche2["Couche 2 : Filesystem"]
        FS["Landlock + DAC<br/>.openclaw = lecture seule<br/>.openclaw-data = ecriture"]
    end

    subgraph Couche3["Couche 3 : Processus"]
        PROC["Utilisateur sandbox (UID isole)<br/>Gateway = utilisateur gateway<br/>gosu v1.19 + hash SHA256"]
    end

    subgraph Couche4["Couche 4 : Inference"]
        INF["SSRF validation<br/>Credentials cote hote<br/>inference.local routing"]
    end

    AGENT --> Couche1
    AGENT --> Couche2
    AGENT --> Couche3
    AGENT --> Couche4

    Couche1 -->|"autorise"| INTERNET["Internet<br/>(endpoints listes)"]
    Couche4 -->|"route"| PROVIDER["Provider LLM<br/>(NVIDIA, OpenAI...)"]
```

### 2.5 Routage d'inference

```mermaid
sequenceDiagram
    participant Agent as Agent OpenClaw<br/>(sandbox)
    participant Local as inference.local
    participant GW as Gateway OpenShell<br/>(hote)
    participant API as Provider LLM<br/>(ex: NVIDIA Endpoints)

    Agent->>Local: POST /v1/chat/completions<br/>{"model": "nvidia/nemotron-3-super-120b-a12b"}
    Local->>GW: Requete interceptee
    Note over GW: Injection des credentials<br/>(NVIDIA_API_KEY depuis l'env hote)
    GW->>API: POST /v1/chat/completions<br/>Authorization: Bearer nvapi-xxx
    API-->>GW: Reponse du modele
    GW-->>Local: Reponse relayee
    Local-->>Agent: Reponse
```

### 2.6 Cycle de vie du deploiement

Le Blueprint Runner (`runner.ts`) gere 4 actions orchestrees via le protocole stdout :

```mermaid
stateDiagram-v2
    [*] --> plan : nemoclaw onboard
    plan --> apply : Validation OK

    state plan {
        [*] --> ValidateBlueprint : PROGRESS:10:Validating blueprint
        ValidateBlueprint --> CheckPrereqs : PROGRESS:20:Checking prerequisites
        CheckPrereqs --> GeneratePlan : PROGRESS:100:Plan complete
    }

    state apply {
        [*] --> CreateSandbox : PROGRESS:20:Creating OpenClaw sandbox
        CreateSandbox --> ConfigInference : PROGRESS:50:Configuring inference provider
        ConfigInference --> SetRoute : PROGRESS:70:Setting inference route
        SetRoute --> SaveState : PROGRESS:85:Saving run state
        SaveState --> Done : PROGRESS:100:Apply complete
    }

    apply --> status : Verification
    apply --> rollback : En cas de probleme
    rollback --> [*] : Sandbox supprime
    status --> [*] : Etat affiche
```

Chaque action emet un identifiant unique `RUN_ID:nc-YYYYMMDD-HHMMSS-xxxxxxxx` pour la tracabilite. L'etat est persiste dans `~/.nemoclaw/state/runs/<RUN_ID>/plan.json`.

---

## 3. Installation pas-a-pas

### 3.1 Pre-requis materiels et logiciels

**Materiel** :

| Ressource | Minimum | Recommande |
|-----------|---------|------------|
| CPU | 4 vCPU | 4+ vCPU |
| RAM | 8 GB | 16 GB |
| Disque | 20 GB libre | 40 GB libre |

**Logiciels** :

| Pre-requis | Version minimale | Notes |
|-----------|-----------------|-------|
| **Linux** | Ubuntu 22.04 LTS ou equivalent (Debian 12) | Voir recommandation OS ci-dessous |
| **Node.js** | 20+ | npm >= 10 inclus, recommande 22 |
| **Container runtime** | Docker, Colima ou equivalent | En cours d'execution |
| **OpenShell** | Installe | Installe automatiquement par NemoClaw si absent |
| **Ports libres** | 8080, 18789 | Gateway et dashboard respectivement |

**Systeme d'exploitation recommande** : **Debian 12 (Bookworm)**

| Metrique | Debian 12 | Ubuntu Server 24.04 |
|----------|-----------|---------------------|
| RAM au repos | ~150-200 MB | ~300-450 MB |
| Processus au boot | ~80 | ~120-150 |
| Espace disque minimal | ~1.5 GB | ~3.5 GB |
| Services pre-installes | Strict minimum | snap, cloud-init, multipathd... |

Debian 12 est egalement la base de l'image Docker de NemoClaw (`node:22-slim` est base sur Bookworm), ce qui garantit une coherence maximale.

**Pre-requis optionnels** :

| Outil | Quand |
|-------|-------|
| GPU NVIDIA | Inference locale (Ollama, vLLM, NIM) |
| Ollama >= 0.18.0 | Inference locale sans GPU dediee |
| hadolint | Developpement (lint du Dockerfile) |
| uv | Developpement (deps Python du blueprint) |

### 3.2 Installation de Node.js

Via **nvm** (recommande) :

```bash
# Installer nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
source ~/.bashrc

# Installer Node.js 22
nvm install 22
nvm use 22

# Verifier
node --version   # v22.x.x
npm --version    # 10.x.x
```

Via les **depots NodeSource** (alternative sur serveur) :

```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo bash -
sudo apt-get install -y nodejs
```

### 3.3 Installation de NemoClaw

**Methode recommandee** (script officiel) :

```bash
curl -fsSL https://www.nvidia.com/nemoclaw.sh | bash
```

Ce script gere automatiquement :
1. Verification/installation de Node.js (via nvm si necessaire)
2. Installation de NemoClaw CLI depuis les sources GitHub
3. Installation d'OpenShell CLI si absent
4. Lancement de l'onboarding interactif

**Mode non-interactif** (pour l'automatisation) :

```bash
curl -fsSL https://www.nvidia.com/nemoclaw.sh | bash -s -- --non-interactive
```

Variables d'environnement disponibles : `NVIDIA_API_KEY`, `NEMOCLAW_PROVIDER`, `NEMOCLAW_MODEL`, `NEMOCLAW_SANDBOX_NAME` (voir section 4.8).

**Depuis les sources** (developpement) :

```bash
git clone https://github.com/NVIDIA/NemoClaw.git
cd NemoClaw
npm install
cd nemoclaw && npm install && npm run build && cd ..
npm link
```

---

## 4. Procedure d'onboarding

L'onboarding est un assistant interactif en 7 etapes qui configure NemoClaw de zero jusqu'a un sandbox fonctionnel.

```bash
nemoclaw onboard
```

### 4.1 Etape 1 : Verifications prealables

Le preflight verifie automatiquement :

- **Docker** : Le daemon est-il en cours d'execution ?
- **Runtime** : Docker Desktop, Colima ou Docker Engine ? (Podman sur macOS est rejete)
- **Ports** : 8080 (gateway) et 18789 (dashboard) sont-ils disponibles ?
- **GPU** : Detection via `nvidia-smi` (NVIDIA) ou `sysctl` (Apple Silicon)
- **Gateway obsolete** : Nettoyage des sessions precedentes si necessaire
- **OpenShell** : Installe ou propose l'installation

En cas d'echec, l'assistant affiche un message explicatif et s'arrete.

### 4.2 Etape 2 : Configuration de l'inference

L'assistant propose un choix de fournisseurs d'inference :

**Fournisseurs distants (cloud)** :

| Fournisseur | Endpoint | Variable d'environnement |
|------------|----------|-------------------------|
| NVIDIA Endpoints (defaut) | `https://integrate.api.nvidia.com/v1` | `NVIDIA_API_KEY` |
| OpenAI | `https://api.openai.com/v1` | `OPENAI_API_KEY` |
| Anthropic | `https://api.anthropic.com` | `ANTHROPIC_API_KEY` |
| Google Gemini | `https://generativelanguage.googleapis.com/v1beta/openai/` | `GEMINI_API_KEY` |
| OpenAI-compatible (custom) | URL personnalisee | `COMPATIBLE_API_KEY` |
| Anthropic-compatible (custom) | URL personnalisee | `COMPATIBLE_ANTHROPIC_API_KEY` |

**Fournisseurs locaux** (affiches si detectes) :

| Fournisseur | Endpoint (dans le sandbox) | Condition |
|------------|---------------------------|-----------|
| Ollama | `http://host.openshell.internal:11434/v1` | Ollama installe et en cours |
| vLLM | `http://host.openshell.internal:8000/v1` | vLLM en cours sur port 8000 |
| NVIDIA NIM | Via gateway local | GPU capable + mode experimental |

**Selection du modele** :

Pour les fournisseurs cloud, l'assistant propose une liste de modeles curees :
- `nvidia/nemotron-3-super-120b-a12b` (defaut)
- `nvidia/llama-3.1-nemotron-ultra-253b-v1`
- `nvidia/llama-3.3-nemotron-super-49b-v1.5`
- `nvidia/nemotron-3-nano-30b-a3b`
- Ou saisie manuelle d'un identifiant de modele

Pour Ollama, la liste des modeles installes localement est proposee. Le modele par defaut est `nemotron-3-nano:30b`.

**Validation des credentials** : L'assistant effectue un appel de test (`/v1/chat/completions` ou `/v1/messages` selon le provider) avec un timeout de 20s.

### 4.3 Etape 3 : Demarrage du Gateway OpenShell

L'assistant :
1. Detruit tout gateway obsolete nomme `nemoclaw`
2. Demarre un nouveau gateway : `openshell gateway start --name nemoclaw`
3. Patche CoreDNS si le runtime est Colima
4. Verifie la sante du gateway (statut "Connected", max 5 tentatives)

### 4.4 Etape 4 : Creation du Sandbox

1. **Choix du nom** : L'assistant propose un nom (RFC 1123 : minuscules, alphanumerique + tirets, 1-63 caracteres)
2. **Gestion des conflits** : Si un sandbox du meme nom existe, l'assistant demande s'il faut le recree
3. **Build Docker multi-stage** :
   - Stage 1 (builder) : Compile le plugin TypeScript
   - Stage 2 (runtime) : Image finale avec OpenClaw, plugin, blueprint, politiques
4. **Arguments de build securises** : Le modele, le provider, l'URL d'inference et un token d'authentification unique sont injectes en tant que `ARG` Docker (jamais interpoles dans du code Python — prevention de l'injection C-2)
5. **Verification d'integrite** : Un hash SHA256 de `openclaw.json` est calcule au build et verifie a chaque demarrage
6. **Enregistrement** : Le sandbox est enregistre dans `~/.nemoclaw/sandboxes.json`
7. **Port forwarding** : Le port 18789 est automatiquement forward vers le sandbox

### 4.5 Etape 5 : Configuration de la route d'inference

L'assistant configure le routage d'inference dans OpenShell :

```
openshell provider create --name <provider-name> --type <type> --credential <env-var>
openshell inference set --provider <provider-name> --model <model>
```

A l'interieur du sandbox, toutes les requetes d'inference transitent par `https://inference.local/v1`. Les credentials restent cote hote.

### 4.6 Etape 6 : Configuration d'OpenClaw dans le sandbox

L'assistant :
1. Genere un script de synchronisation de configuration
2. Se connecte au sandbox et injecte la configuration
3. Installe le plugin NemoClaw dans OpenClaw : `openclaw plugins install /opt/nemoclaw`

### 4.7 Etape 7 : Application des presets de politiques

L'assistant detecte automatiquement les presets pertinents :
- **Toujours suggeres** : `pypi`, `npm`
- **Si un token bot est present** : `telegram`, `slack`, `discord`

**9 presets disponibles** :

| Preset | Endpoints autorises | Binaires |
|--------|-------------------|----------|
| `npm` | `registry.npmjs.org`, `registry.yarnpkg.com` | npm, npx, node, yarn |
| `pypi` | `pypi.org`, `files.pythonhosted.org` | python3, pip, .venv/bin/python |
| `docker` | `registry-1.docker.io`, `auth.docker.io`, `nvcr.io` | docker |
| `slack` | `slack.com`, `api.slack.com`, `hooks.slack.com` | node |
| `telegram` | `api.telegram.org` | node |
| `discord` | `discord.com`, `gateway.discord.gg`, `cdn.discordapp.com` | node |
| `huggingface` | `huggingface.co`, `cdn-lfs.huggingface.co`, `api-inference.huggingface.co` | python3, node |
| `jira` | `*.atlassian.net`, `auth.atlassian.com`, `api.atlassian.com` | node |
| `outlook` | `graph.microsoft.com`, `login.microsoftonline.com`, `outlook.office365.com` | node |

### 4.8 Mode non-interactif

Pour l'automatisation, l'onboarding supporte un mode non-interactif :

```bash
nemoclaw onboard --non-interactive
```

**Variables d'environnement** :

| Variable | Description | Defaut |
|----------|-------------|--------|
| `NEMOCLAW_PROVIDER` | `build`, `openai`, `anthropic`, `gemini`, `ollama`, `custom`, `nim-local`, `vllm` | `build` |
| `NEMOCLAW_MODEL` | Identifiant du modele | `nvidia/nemotron-3-super-120b-a12b` |
| `NEMOCLAW_ENDPOINT_URL` | URL pour les endpoints custom | — |
| `NVIDIA_API_KEY` | Cle API NVIDIA | — |
| `OPENAI_API_KEY` | Cle API OpenAI | — |
| `ANTHROPIC_API_KEY` | Cle API Anthropic | — |
| `GEMINI_API_KEY` | Cle API Google Gemini | — |
| `NEMOCLAW_SANDBOX_NAME` | Nom du sandbox | `openclaw` |
| `NEMOCLAW_RECREATE_SANDBOX` | `1` pour recree un sandbox existant | `0` |
| `NEMOCLAW_POLICY_MODE` | `suggested`, `custom`, `skip` | `suggested` |
| `NEMOCLAW_POLICY_PRESETS` | Liste separee par virgules (si mode=custom) | — |

---

## 5. Provisionnement GCP avec Terraform

### 5.1 Presentation des deux profils

| Critere | Entreprise | Personnel |
|---------|-----------|-----------|
| **Machine** | `a2-highgpu-1g` (GPU) | `e2-standard-4` (CPU) |
| **GPU** | NVIDIA Tesla A100 | Aucun |
| **Inference** | vLLM local (souverainete des donnees) | Distante (NVIDIA, OpenAI, Anthropic, Gemini...) |
| **Disque** | 200 GB SSD | 50 GB balanced |
| **Backend Terraform** | Remote (GCS bucket) | Local |
| **OS** | Debian 12 | Debian 12 |
| **IP publique** | Non | Non |
| **Acces** | Tailscale uniquement | Tailscale uniquement |
| **Securite** | Identique | Identique |

Les deux profils partagent la **meme architecture de securite** : VPC dedie, firewall strict, Tailscale en mode invisible, SSH durci, fail2ban, mises a jour automatiques.

### 5.2 Profil Entreprise

**Fichiers** : `terraform/gcp-enterprise/`

```
terraform/gcp-enterprise/
  main.tf          # VPC + subnet + firewall + VM GPU
  variables.tf     # Variables (projet, region, GPU, Tailscale, SSH)
  outputs.tf       # IP interne, commande SSH
  backend.tf       # Backend GCS
  startup.sh       # Script d'initialisation (10 etapes)
```

**Infrastructure creee** :
- VPC `nemoclaw-vpc` avec subnet prive `10.0.1.0/24`
- Firewall : deny-all + allow UDP 41641 (Tailscale) + allow SSH depuis CIDR Tailscale (`100.64.0.0/10`)
- VM avec GPU NVIDIA, Debian 12, **sans IP publique**

**Backend GCS** : L'etat Terraform est stocke dans un bucket GCS pour le travail en equipe :

```bash
# Creer le bucket d'abord
gcloud storage buckets create gs://VOTRE-BUCKET-GCS \
  --location=us-central1 \
  --uniform-bucket-level-access

# Initialiser Terraform avec le backend
terraform init \
  -backend-config="bucket=VOTRE-BUCKET-GCS" \
  -backend-config="prefix=nemoclaw/enterprise"
```

### 5.3 Profil Personnel

**Fichiers** : `terraform/gcp-personal/`

```
terraform/gcp-personal/
  main.tf          # VPC + subnet + firewall + VM CPU
  variables.tf     # Variables
  outputs.tf       # Outputs
  startup.sh       # Script d'initialisation (9 etapes, sans NVIDIA Toolkit)
```

Meme architecture reseau que le profil entreprise, mais sans GPU et avec un backend Terraform local.

### 5.4 Complementarite VPC + Tailscale

VPC et Tailscale sont **complementaires**, pas redondants :

| Couche | Role |
|--------|------|
| **VPC GCP** | Isolation reseau au niveau cloud. Pas d'IP publique, pas de port SSH expose sur Internet. |
| **Tailscale** | Tunnel WireGuard chiffre pour acceder a la VM. Mode `--shields-up` : la machine refuse toute connexion entrante sauf via Tailscale. |

L'acces se fait exclusivement via l'IP Tailscale de la machine (ex: `100.x.y.z`), jamais via une IP publique.

### 5.5 Utilisation

**Pre-requis** :
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5
- [gcloud CLI](https://cloud.google.com/sdk/docs/install) authentifie
- Un compte [Tailscale](https://tailscale.com) avec une cle d'authentification ephemere

**Deploiement** :

```bash
# 1. Se placer dans le repertoire du profil
cd terraform/gcp-enterprise   # ou terraform/gcp-personal

# 2. Creer un fichier de variables
cat > terraform.tfvars <<EOF
project_id         = "mon-projet-gcp"
region             = "europe-west1"
zone               = "europe-west1-b"
tailscale_auth_key = "tskey-auth-xxxxxxxxxxxx"
ssh_public_key     = "ssh-ed25519 AAAA... user@machine"
admin_user         = "nemoclaw-admin"
EOF

# 3. Initialiser et deployer
terraform init          # Pour le profil entreprise, ajouter -backend-config (voir 5.2)
terraform plan          # Verifier les ressources a creer
terraform apply         # Confirmer avec 'yes'

# 4. Se connecter via Tailscale
ssh -p 2222 nemoclaw-admin@<tailscale-ip>

# 5. Lancer l'onboarding
nemoclaw onboard
```

**Voir les logs de demarrage** (si besoin de debug) :

```bash
gcloud compute instances get-serial-port-output nemoclaw-enterprise --zone=europe-west1-b
```

**Destruction** :

```bash
terraform destroy       # Confirmer avec 'yes'
```

### 5.6 Remarque : onboarding automatise

Le deploiement actuel est **semi-automatise** : Terraform provisionne la VM et installe toutes les dependances, puis l'utilisateur se connecte en SSH pour lancer `nemoclaw onboard` interactivement.

Un deploiement **entierement automatise** (Terraform passe les variables d'inference et execute l'onboarding via le startup script) est envisage comme amelioration future. Cela necessite de passer les secrets (cles API) de maniere securisee via les metadata GCP ou un Secret Manager.

---

## 6. Durcissement de securite

Cette section couvre le durcissement de la machine cible (VM GCP ou serveur physique). La plupart de ces etapes sont **automatisees par le startup script** Terraform (sections 5.2/5.3), mais sont documentees ici pour une installation manuelle ou pour comprendre ce que le script fait.

### 6.1 Mot de passe root robuste

Lors de la creation initiale du serveur, definir un mot de passe root extremement robuste :

```bash
# Generer un mot de passe de 32 caracteres
openssl rand -base64 32

# Definir le mot de passe root
sudo passwd root
```

> **Note** : Ce mot de passe ne sera utilise qu'en dernier recours (console de secours). L'acces quotidien se fait exclusivement par cle SSH.

### 6.2 Cle SSH ED25519

Generer une paire de cles sur la **machine locale** (pas le serveur) :

```bash
# Generer la cle
ssh-keygen -t ed25519 -C "nemoclaw-admin@mon-domaine" -f ~/.ssh/nemoclaw_ed25519

# Afficher la cle publique (a copier dans terraform.tfvars ou sur le serveur)
cat ~/.ssh/nemoclaw_ed25519.pub
```

Copier la cle publique sur le serveur (si installation manuelle, hors Terraform) :

```bash
ssh-copy-id -i ~/.ssh/nemoclaw_ed25519.pub -p 22 utilisateur@ip-du-serveur
```

Configurer le client SSH local pour utiliser cette cle automatiquement :

```bash
cat >> ~/.ssh/config <<EOF

Host nemoclaw
    HostName <tailscale-ip>
    Port 2222
    User nemoclaw-admin
    IdentityFile ~/.ssh/nemoclaw_ed25519
    IdentitiesOnly yes
EOF
```

Connexion simplifiee : `ssh nemoclaw`

### 6.3 Configuration SSH avancee

Editer `/etc/ssh/sshd_config.d/nemoclaw-hardening.conf` sur le serveur :

```bash
# Port personnalise (evite le bruit des bots sur le port 22)
Port 2222

# Interdire le login root
PermitRootLogin no

# Desactiver l'authentification par mot de passe
PasswordAuthentication no

# Activer uniquement l'authentification par cle publique
PubkeyAuthentication yes
AuthenticationMethods publickey

# Desactiver l'authentification interactive
KbdInteractiveAuthentication no

# Desactiver le X11 forwarding (inutile pour un serveur)
X11Forwarding no

# Limiter les tentatives d'authentification
MaxAuthTries 3

# Deconnecter les sessions inactives
ClientAliveInterval 300
ClientAliveCountMax 2
```

Appliquer :

```bash
sudo systemctl restart sshd
```

> **Important** : Tester la connexion SSH dans un **nouveau terminal** avant de fermer la session active, pour eviter de se verrouiller.

### 6.4 Acces sans root

Creer un utilisateur non-root avec les droits sudo :

```bash
# Creer l'utilisateur
sudo useradd -m -s /bin/bash -G sudo,docker nemoclaw-admin

# Configurer sudo sans mot de passe (optionnel, pour l'automatisation)
echo "nemoclaw-admin ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nemoclaw-admin
sudo chmod 440 /etc/sudoers.d/nemoclaw-admin

# Deployer la cle SSH
sudo mkdir -p /home/nemoclaw-admin/.ssh
sudo cp ~/.ssh/authorized_keys /home/nemoclaw-admin/.ssh/
sudo chown -R nemoclaw-admin:nemoclaw-admin /home/nemoclaw-admin/.ssh
sudo chmod 700 /home/nemoclaw-admin/.ssh
sudo chmod 600 /home/nemoclaw-admin/.ssh/authorized_keys
```

Verrouiller le compte root (apres avoir verifie que l'acces sudo fonctionne) :

```bash
sudo passwd -l root
```

### 6.5 fail2ban

Installation et configuration :

```bash
sudo apt-get install -y fail2ban
```

Creer `/etc/fail2ban/jail.d/nemoclaw.conf` :

```ini
[sshd]
enabled  = true
port     = 2222
filter   = sshd
logpath  = /var/log/auth.log
maxretry = 3
bantime  = 3600
findtime = 600
```

Activer :

```bash
sudo systemctl enable fail2ban
sudo systemctl restart fail2ban

# Verifier le statut
sudo fail2ban-client status sshd
```

### 6.6 Mises a jour automatiques

Installer `unattended-upgrades` :

```bash
sudo apt-get install -y unattended-upgrades apt-listchanges
```

Configurer `/etc/apt/apt.conf.d/50unattended-upgrades` :

```
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}";
    "${distro_id}:${distro_codename}-security";
};
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";
```

Configurer `/etc/apt/apt.conf.d/20auto-upgrades` :

```
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
```

Verifier :

```bash
sudo unattended-upgrade --dry-run --debug
```

### 6.7 Firewall strict

Configurer **nftables** pour rejeter toutes les connexions entrantes sauf le port UDP 41641 (Tailscale WireGuard) :

```bash
sudo apt-get install -y nftables
```

Creer `/etc/nftables.conf` :

```nft
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;

        # Autoriser le loopback
        iif "lo" accept

        # Autoriser les connexions etablies
        ct state established,related accept

        # Autoriser ICMP (ping) — optionnel, commenter pour plus de discretion
        # ip protocol icmp accept
        # ip6 nexthdr icmpv6 accept

        # Autoriser Tailscale WireGuard
        udp dport 41641 accept

        # Autoriser SSH depuis le reseau Tailscale uniquement
        ip saddr 100.64.0.0/10 tcp dport 2222 accept

        # Rejeter tout le reste avec un message
        reject with icmpx type admin-prohibited
    }

    chain forward {
        type filter hook forward priority 0; policy drop;

        # Docker a besoin du forwarding
        ct state established,related accept
        iifname "docker0" accept
        oifname "docker0" accept
    }

    chain output {
        type filter hook output priority 0; policy accept;
    }
}
```

Activer :

```bash
sudo systemctl enable nftables
sudo systemctl start nftables

# Verifier les regles
sudo nft list ruleset
```

### 6.8 Tailscale : installation et mode invisible

**Installation** :

```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

**Activation en mode invisible** (`--shields-up`) :

```bash
# Avec une cle d'authentification ephemere
sudo tailscale up --authkey=tskey-auth-xxxxxxxxxxxx --shields-up --accept-routes

# Verifier le statut
tailscale status

# Obtenir l'IP Tailscale
tailscale ip -4
```

Le flag `--shields-up` signifie que la machine **refuse toute connexion entrante** sauf celles provenant de votre reseau Tailscale. Elle est invisible pour le reste d'Internet.

**Configuration des ACLs Tailscale** :

Dans la console d'administration Tailscale (https://login.tailscale.com/admin/acls), definir des regles restrictives :

```json
{
  "acls": [
    {
      "action": "accept",
      "src": ["group:admins"],
      "dst": ["tag:nemoclaw:2222"]
    }
  ],
  "tagOwners": {
    "tag:nemoclaw": ["group:admins"]
  },
  "groups": {
    "group:admins": ["user@example.com"]
  }
}
```

Cette configuration autorise uniquement les membres du groupe `admins` a se connecter au port SSH des machines taguees `nemoclaw`.

Taguer la machine lors de la connexion :

```bash
sudo tailscale up --authkey=tskey-auth-xxxxxxxxxxxx --shields-up --advertise-tags=tag:nemoclaw
```

### 6.9 Options entreprise avancees

#### auditd — Journal d'audit systeme

```bash
sudo apt-get install -y auditd

# Regles d'audit pour NemoClaw
cat <<'EOF' | sudo tee /etc/audit/rules.d/nemoclaw.rules
# Surveiller les modifications de la config SSH
-w /etc/ssh/sshd_config -p wa -k ssh_config
-w /etc/ssh/sshd_config.d/ -p wa -k ssh_config

# Surveiller les modifications dans le repertoire sandbox
-w /sandbox/ -p wa -k sandbox_changes

# Surveiller les changements de comptes utilisateurs
-w /etc/passwd -p wa -k user_accounts
-w /etc/shadow -p wa -k user_accounts
-w /etc/sudoers -p wa -k sudo_changes
-w /etc/sudoers.d/ -p wa -k sudo_changes

# Surveiller les commandes executees en tant que root
-a always,exit -F arch=b64 -S execve -F euid=0 -k root_commands
EOF

sudo systemctl restart auditd

# Consulter les logs
sudo ausearch -k ssh_config
sudo aureport --summary
```

#### Chiffrement de disque (LUKS)

Pour les donnees sensibles sur le disque de donnees (pas le disque de boot) :

```bash
# Installer les outils
sudo apt-get install -y cryptsetup

# Creer un volume chiffre (sur un disque secondaire, ex: /dev/sdb)
sudo cryptsetup luksFormat /dev/sdb
sudo cryptsetup luksOpen /dev/sdb nemoclaw-data

# Formater et monter
sudo mkfs.ext4 /dev/mapper/nemoclaw-data
sudo mkdir -p /data/nemoclaw
sudo mount /dev/mapper/nemoclaw-data /data/nemoclaw
```

> **Note** : Le chiffrement LUKS du disque de boot necessite une configuration plus complexe et n'est generalement pas necessaire sur GCP (les disques GCE sont chiffres au repos par defaut avec des cles gerees par Google).

---

## 7. Publics cibles et parcours

### 7.1 DevOps / SRE

**Responsabilites** : Provisionnement de l'infrastructure, durcissement securite, supervision, gestion des politiques reseau.

**Parcours recommande** :

1. **Section 2** (Architecture) — Comprendre les 4 couches de securite et le routage d'inference
2. **Section 5** (Terraform) — Provisionner la VM GCP avec le profil adapte
3. **Section 6** (Durcissement) — Verifier et completer le hardening (meme si le startup script le fait)
4. **Section 3** (Installation) — Valider les pre-requis sur la machine
5. **Section 4** (Onboarding) — Executer `nemoclaw onboard`, configurer l'inference et les politiques
6. **Section 8** (Administration) — Deployer le script de backup et configurer le cron

**Commandes quotidiennes** :

```bash
nemoclaw <nom> status        # Sante du sandbox
nemoclaw <nom> logs -f       # Logs en temps reel
nemoclaw <nom> policy-list   # Politiques appliquees
nemoclaw <nom> policy-add    # Ajouter un preset
nemoclaw debug               # Diagnostics complets
nemoclaw-backup backup <nom> # Sauvegarder le workspace
nemoclaw-backup list         # Lister les sauvegardes
```

### 7.2 Developpeurs

**Responsabilites** : Developper des cas d'usage metiers, orchestrer des agents OpenClaw, tester dans un environnement sandbox.

**Parcours recommande** :

1. **Section 1** (Definition) — Comprendre ce qu'est NemoClaw et son role
2. **Section 3** (Installation) — Installer NemoClaw sur sa machine (ou se connecter a un sandbox deja provisionne par le DevOps)
3. **Section 4** (Onboarding) — Lancer l'onboarding, choisir son provider d'inference
4. **Section 2.5** (Routage d'inference) — Comprendre comment les requetes LLM sont acheminee

**Commandes quotidiennes** :

```bash
nemoclaw <nom> connect       # Ouvrir un shell dans le sandbox
nemoclaw <nom> status        # Verifier que tout fonctionne
nemoclaw <nom> logs          # Consulter les logs
nemoclaw list                # Lister les sandboxes disponibles
```

**Acces au dashboard** : Apres l'onboarding, le dashboard est accessible a `http://127.0.0.1:18789` (ou via Tailscale depuis une machine distante).

---

## 8. Administration operationnelle

Cette section couvre les outils d'administration a deployer sur la VM GCP (ou tout serveur hebergeant NemoClaw) pour gerer les fichiers produits durant la vie de l'agent OpenClaw.

### 8.1 Problematique : scripts absents de la VM

Le depot NemoClaw contient un script de backup (`scripts/backup-workspace.sh`) et des skills Claude Code (`.claude/skills/nemoclaw-workspace`) qui documentent la sauvegarde du workspace. Cependant, **aucun de ces outils n'est installe sur la VM** lors du deploiement :

- `npm install -g nemoclaw` n'inclut pas le repertoire `scripts/`
- Les skills Claude Code restent dans le depot Git, sur le PC du developpeur

L'administrateur qui gere le sandbox sur la VM GCP n'a donc pas acces a ces utilitaires. Cette section comble cette lacune en fournissant un script autonome a deployer sur la VM.

### 8.2 Script de backup/restore du workspace

Creer le fichier `/usr/local/bin/nemoclaw-backup` sur la VM :

```bash
sudo tee /usr/local/bin/nemoclaw-backup > /dev/null <<'SCRIPT'
#!/usr/bin/env bash
# NemoClaw Workspace Backup/Restore
# Deployer sur la VM GCP pour gerer les fichiers de l'agent OpenClaw.

set -euo pipefail

WORKSPACE_PATH="/sandbox/.openclaw/workspace"
BACKUP_BASE="${HOME}/.nemoclaw/backups"
FILES=(SOUL.md USER.md IDENTITY.md AGENTS.md MEMORY.md)
DIRS=(memory)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[backup]${NC} $1"; }
warn() { echo -e "${YELLOW}[backup]${NC} $1"; }
fail() { echo -e "${RED}[backup]${NC} $1" >&2; exit 1; }

usage() {
  cat <<EOF
Usage:
  $(basename "$0") backup  <sandbox-name>
  $(basename "$0") restore <sandbox-name> [timestamp]
  $(basename "$0") list

Commands:
  backup   Sauvegarder les fichiers workspace du sandbox vers l'hote.
  restore  Restaurer les fichiers workspace dans un sandbox.
           Sans timestamp, la sauvegarde la plus recente est utilisee.
  list     Lister toutes les sauvegardes disponibles.

Emplacement des sauvegardes : ${BACKUP_BASE}/<timestamp>/
EOF
  exit 1
}

do_backup() {
  local sandbox="$1"
  local ts
  ts="$(date +%Y%m%d-%H%M%S)"
  local dest="${BACKUP_BASE}/${ts}"

  mkdir -p "$BACKUP_BASE"
  chmod 0700 "${HOME}/.nemoclaw" "$BACKUP_BASE" \
    || fail "Impossible de securiser les permissions sur ${HOME}/.nemoclaw"
  mkdir -p "$dest"
  chmod 0700 "$dest"

  info "Sauvegarde du workspace depuis le sandbox '${sandbox}'..."

  local count=0
  for f in "${FILES[@]}"; do
    if openshell sandbox download "$sandbox" "${WORKSPACE_PATH}/${f}" "${dest}/" 2>/dev/null; then
      count=$((count + 1))
    else
      warn "Ignore ${f} (introuvable ou echec du telechargement)"
    fi
  done

  for d in "${DIRS[@]}"; do
    if openshell sandbox download "$sandbox" "${WORKSPACE_PATH}/${d}/" "${dest}/${d}/" 2>/dev/null; then
      count=$((count + 1))
    else
      warn "Ignore ${d}/ (introuvable ou echec du telechargement)"
    fi
  done

  if [ "$count" -eq 0 ]; then
    fail "Aucun fichier sauvegarde. Verifiez que le sandbox '${sandbox}' existe et contient des fichiers workspace."
  fi

  info "Sauvegarde enregistree dans ${dest}/ (${count} elements)"
}

do_restore() {
  local sandbox="$1"
  local ts="${2:-}"

  if [ -z "$ts" ]; then
    ts="$(find "$BACKUP_BASE" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort -r | head -n1 || true)"
    [ -n "$ts" ] || fail "Aucune sauvegarde trouvee dans ${BACKUP_BASE}/"
    info "Utilisation de la sauvegarde la plus recente : ${ts}"
  fi

  local src="${BACKUP_BASE}/${ts}"
  [ -d "$src" ] || fail "Repertoire de sauvegarde introuvable : ${src}"

  info "Restauration du workspace dans le sandbox '${sandbox}' depuis ${src}..."

  local count=0
  for f in "${FILES[@]}"; do
    if [ -f "${src}/${f}" ]; then
      if openshell sandbox upload "$sandbox" "${src}/${f}" "${WORKSPACE_PATH}/"; then
        count=$((count + 1))
      else
        warn "Echec de la restauration de ${f}"
      fi
    fi
  done

  for d in "${DIRS[@]}"; do
    if [ -d "${src}/${d}" ]; then
      if openshell sandbox upload "$sandbox" "${src}/${d}/" "${WORKSPACE_PATH}/${d}/"; then
        count=$((count + 1))
      else
        warn "Echec de la restauration de ${d}/"
      fi
    fi
  done

  if [ "$count" -eq 0 ]; then
    fail "Aucun fichier restaure. Verifiez que le sandbox '${sandbox}' est en cours d'execution."
  fi

  info "Restauration de ${count} elements dans le sandbox '${sandbox}'."
}

do_list() {
  if [ ! -d "$BACKUP_BASE" ]; then
    info "Aucune sauvegarde trouvee."
    return
  fi

  info "Sauvegardes disponibles :"
  echo ""
  for dir in $(find "$BACKUP_BASE" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort -r); do
    local count
    count=$(find "${BACKUP_BASE}/${dir}" -maxdepth 1 -type f | wc -l)
    echo "  ${dir}  (${count} fichiers)"
  done
}

# --- Main ---
[ $# -ge 1 ] || usage
command -v openshell >/dev/null 2>&1 || fail "'openshell' est requis mais introuvable dans le PATH."

action="$1"
shift

case "$action" in
  backup)  [ $# -ge 1 ] || usage; do_backup "$1" ;;
  restore) [ $# -ge 1 ] || usage; do_restore "$@" ;;
  list)    do_list ;;
  *)       usage ;;
esac
SCRIPT
sudo chmod +x /usr/local/bin/nemoclaw-backup
```

### 8.3 Installation du script sur la VM

**Option A** — Installation manuelle via SSH :

```bash
ssh -p 2222 nemoclaw-admin@<tailscale-ip>
# Coller le script ci-dessus
```

**Option B** — Integration dans le startup script Terraform :

Pour automatiser l'installation, ajouter le bloc suivant dans le startup script (`startup.sh`) du profil Terraform, avant le marqueur de fin :

```bash
echo "=== Installation des outils d'administration NemoClaw ==="
cat > /usr/local/bin/nemoclaw-backup <<'BACKUPSCRIPT'
#!/usr/bin/env bash
# ... (contenu du script ci-dessus)
BACKUPSCRIPT
chmod +x /usr/local/bin/nemoclaw-backup
```

### 8.4 Utilisation

```bash
# Sauvegarder le workspace d'un sandbox
nemoclaw-backup backup mon-assistant

# Lister les sauvegardes existantes
nemoclaw-backup list

# Restaurer la derniere sauvegarde
nemoclaw-backup restore mon-assistant

# Restaurer une sauvegarde specifique
nemoclaw-backup restore mon-assistant 20260325-143000
```

Les sauvegardes sont stockees dans `~/.nemoclaw/backups/<timestamp>/` sur la VM hote (pas dans le sandbox).

### 8.5 Backup automatique avec cron

Configurer un cron job pour sauvegarder automatiquement le workspace toutes les 6 heures :

```bash
# Detecter le nom du sandbox par defaut
SANDBOX=$(nemoclaw list 2>/dev/null | head -1 | awk '{print $1}')

# Ajouter le cron (en tant qu'utilisateur nemoclaw-admin)
(crontab -l 2>/dev/null; echo "0 */6 * * * /usr/local/bin/nemoclaw-backup backup ${SANDBOX} >> /var/log/nemoclaw-backup.log 2>&1") | crontab -

# Verifier
crontab -l
```

**Rotation des sauvegardes** — Pour eviter de saturer le disque, ajouter un second cron qui supprime les sauvegardes de plus de 30 jours :

```bash
(crontab -l 2>/dev/null; echo "0 3 * * 0 find ~/.nemoclaw/backups -maxdepth 1 -type d -mtime +30 -exec rm -rf {} +") | crontab -
```

### 8.6 Fichiers du workspace OpenClaw

Les fichiers suivants sont produits et maintenus par l'agent OpenClaw durant sa vie dans le sandbox :

| Fichier | Role |
|---------|------|
| `SOUL.md` | Personnalite, ton, regles de comportement de l'agent |
| `USER.md` | Preferences et contexte appris sur l'utilisateur |
| `IDENTITY.md` | Nom de l'agent, emoji, presentation |
| `AGENTS.md` | Coordination multi-agents, conventions de memoire |
| `MEMORY.md` | Memoire long terme distillee des notes quotidiennes |
| `memory/` | Repertoire de notes quotidiennes (`YYYY-MM-DD.md`) |

Ces fichiers resident dans `/sandbox/.openclaw/workspace/` a l'interieur du sandbox. Ils sont lus par l'agent au debut de chaque session.

### 8.7 Persistence et cycle de vie

Les donnees du workspace vivent dans un **PVC** (Persistent Volume Claim) gere par OpenShell (k3s). Ce PVC :

- **N'est pas un bind mount** vers un repertoire de l'hote — c'est un volume Kubernetes interne
- **Survit aux redemarrages** du sandbox (le pod peut etre recree, le PVC reste)
- **Est detruit** lors d'un `nemoclaw <nom> destroy` — le PVC est supprime avec le sandbox

| Evenement | Fichiers workspace |
|-----------|-------------------|
| Redemarrage du sandbox | **Preserves** |
| `nemoclaw <nom> destroy` | **Perdus definitivement** |
| Mise a jour NemoClaw | **Preserves** (si le sandbox n'est pas recree) |

> **Regle d'or** : Toujours executer `nemoclaw-backup backup <nom>` **avant** un `nemoclaw <nom> destroy` ou une mise a jour majeure de NemoClaw.

---

## 9. Audits et Observabilite

### 9.1 Vue d'ensemble

NemoClaw fournit un ensemble d'outils de monitoring **temps reel** pour superviser l'activite des agents OpenClaw et de leurs sous-agents a l'interieur du sandbox. Ces outils couvrent la sante du sandbox, les logs, l'activite reseau et les diagnostics systeme.

| Outil | Type | Quand l'utiliser |
|-------|------|-----------------|
| `nemoclaw <nom> status` | Ponctuel | Verifier la sante et la configuration du sandbox |
| `nemoclaw <nom> logs [-f]` | Continu | Suivre les logs du blueprint runner et du sandbox |
| `openshell term` | Interactif | Superviser le reseau en temps reel, approuver/refuser les requetes |
| `nemoclaw <nom> connect` + test | Ponctuel | Verifier que l'inference fonctionne |
| `nemoclaw debug` | Ponctuel | Collecter un rapport de diagnostics complet |
| `/nemoclaw status` | Dans le chat | Consulter l'etat depuis l'interface agent |

### 9.2 Verification de sante du sandbox

**Commande** :

```bash
nemoclaw <nom> status
```

**Informations affichees** :

| Champ | Description |
|-------|-------------|
| Etat du sandbox | `running`, `stopped` ou `error` |
| Blueprint Run ID | Identifiant unique de la derniere execution (`nc-YYYYMMDD-HHMMSS-xxxxxxxx`) |
| Provider d'inference | Nom du provider actif (ex: `nvidia-inference`, `ollama-local`) |
| Modele | Identifiant du modele (ex: `nvidia/nemotron-3-super-120b-a12b`) |
| GPU | Active ou non |
| Politiques | Liste des presets appliques |

Pour voir les details bas-niveau du sandbox (pod Kubernetes, volumes, reseau) :

```bash
openshell sandbox list          # Liste tous les sandboxes
openshell sandbox get <nom>     # Details complets d'un sandbox specifique
```

### 9.3 Logs du sandbox

**Commande** :

```bash
# Derniere 200 lignes de logs
nemoclaw <nom> logs

# Suivi en temps reel (equivalent tail -f)
nemoclaw <nom> logs -f
```

Les logs incluent :
- Les sorties du **blueprint runner** (messages `PROGRESS:`, `RUN_ID:`)
- Les logs du **gateway OpenClaw** (demarrage, authentification, erreurs de routage)
- Les logs de l'**agent OpenClaw** (sessions, requetes, erreurs)

> **Note** : Les logs sont en **texte brut non structure**. Il n'y a pas de format JSON ou de mecanisme d'export vers un systeme de logging externe.

### 9.4 TUI : monitoring reseau temps reel

Le TUI (Terminal User Interface) d'OpenShell est l'outil principal pour superviser l'activite reseau du sandbox et gerer les approbations en temps reel.

**Demarrage** :

```bash
# Sur la machine ou tourne le sandbox
openshell term

# Pour un sandbox distant (via SSH + Tailscale)
ssh -p 2222 nemoclaw-admin@<tailscale-ip> 'openshell term'
```

**Ce que le TUI affiche** :

| Information | Description |
|-------------|-------------|
| Connexions actives | Liste des connexions reseau sortantes du sandbox en cours |
| Requetes bloquees | Endpoints non autorises par la politique, en attente d'approbation |
| Routage d'inference | Etat de la route inference.local vers le provider reel |
| Etat du sandbox | Vue synthetique de la sante du sandbox |

**Flux d'approbation operateur** :

Lorsqu'un agent (ou un sous-agent) tente d'acceder a un endpoint non liste dans la politique :

1. OpenShell **bloque la requete** et la remonte dans le TUI
2. Le TUI affiche les details de la requete :
   - **Hote et port** de la destination (ex: `api.example.com:443`)
   - **Binaire** a l'origine de la requete (ex: `/usr/local/bin/node`)
   - **Methode HTTP et chemin** si disponibles (ex: `POST /v1/messages`)
3. L'operateur choisit :
   - **Approuver** → l'endpoint est ajoute a la politique pour la session en cours
   - **Refuser** → la connexion reste bloquee
4. L'approbation est **en memoire uniquement** — elle disparait au redemarrage du sandbox

> **Important** : Les decisions d'approbation/refus ne sont **pas persistees**. Il n'existe pas de journal d'audit des decisions operateur. Au redemarrage du sandbox, seule la politique de base est active.

**Walkthrough guide** :

Pour observer le flux d'approbation dans une session guidee (split tmux avec le TUI a gauche et l'agent a droite) :

```bash
./scripts/walkthrough.sh    # Necessite tmux et NVIDIA_API_KEY
```

**Ajouter un endpoint de maniere permanente** :

Si un endpoint doit etre autorise en permanence (pas seulement pour la session), utiliser les presets ou la politique personnalisee :

```bash
# Ajouter un preset existant
nemoclaw <nom> policy-add

# Voir les presets appliques
nemoclaw <nom> policy-list

# Politique personnalisee via OpenShell
openshell policy set <fichier-policy.yaml>
```

### 9.5 Test d'inference

Pour verifier que le provider d'inference repond correctement depuis l'interieur du sandbox :

```bash
# Se connecter au sandbox
nemoclaw <nom> connect

# Executer un test d'inference
openclaw agent --agent main --local -m "Test inference" --session-id debug
```

En cas d'echec :

1. Verifier le provider et l'endpoint : `nemoclaw <nom> status`
2. Consulter les logs : `nemoclaw <nom> logs -f`
3. Tester la connectivite reseau depuis l'hote vers l'endpoint d'inference

### 9.6 Collecte de diagnostics

La commande `nemoclaw debug` collecte un rapport complet de l'etat du systeme, utile pour le depannage ou les rapports de bug.

**Utilisation** :

```bash
# Diagnostics complets (affichage stdout)
nemoclaw debug

# Diagnostics rapides (informations minimales)
nemoclaw debug --quick

# Cibler un sandbox specifique
nemoclaw debug --sandbox mon-assistant

# Exporter en archive compressée
nemoclaw debug --output /tmp/nemoclaw-diag.tar.gz
```

**Informations collectees** :

| Categorie | Details |
|-----------|---------|
| **Systeme** | Date, OS, uptime, memoire libre, espace disque |
| **Processus** | Top 30 processus par CPU et memoire |
| **GPU** | `nvidia-smi` : nom, utilisation, memoire, temperature, consommation electrique |
| **Docker** | Conteneurs actifs, stats (CPU/mem/IO), espace utilise, images |
| **OpenShell** | Statut du gateway, liste des sandboxes, details du sandbox cible, logs OpenShell |
| **Sandbox interne** | Processus dans le sandbox, memoire, top, logs du gateway (via SSH) |
| **Reseau** | Ports en ecoute, interfaces, routes, resolution DNS, connectivite API NVIDIA |
| **Kernel** | Messages dmesg (100 dernieres lignes), vmstat, iostat |

> **Securite** : Les secrets (cles API, tokens) sont automatiquement masques dans la sortie (`<REDACTED>`). Neanmoins, verifier le contenu avant de partager l'archive.

### 9.7 Commande slash /nemoclaw status

Depuis l'interface chat de l'agent (a l'interieur du sandbox), la commande `/nemoclaw status` affiche :

- Le **Run ID** du dernier blueprint execute
- La **derniere action** (plan, apply, status, rollback)
- Le **nom du sandbox**
- L'**etat du snapshot** de migration (si applicable)

C'est un raccourci pour les developpeurs qui interagissent directement avec l'agent sans quitter le chat.

### 9.8 Lacunes a combler

NemoClaw est en version alpha. Les capacites d'audit et d'observabilite presentent des lacunes significatives qui devront etre adressees pour un usage en production.

#### Comptage de tokens et suivi des couts

| Besoin | Statut | Impact |
|--------|--------|--------|
| Comptage de tokens par requete d'inference | Non disponible | Impossible de mesurer la consommation reelle |
| Suivi des couts / facturation par sandbox | Non disponible | Pas de visibilite sur les depenses API |
| Historique des requetes d'inference (modele, latence, tokens) | Non disponible | Pas de metriques de performance |
| Budget / plafond de consommation par agent | Non disponible | Risque de depassement non controle |
| Repartition des couts par sous-agent | Non disponible | Impossible d'identifier quel agent consomme le plus |

#### Audit et tracabilite

| Besoin | Statut | Impact |
|--------|--------|--------|
| Journal d'audit persistant des approbations/refus reseau | Non disponible | Les decisions operateur sont perdues au redemarrage |
| Historique des acces aux services externes autorises | Non disponible | Pas de trace de qui a accede a quoi et quand |
| Trail d'audit pour conformite reglementaire (SOC2, RGPD) | Non disponible | Non conforme pour les environnements regules |
| Horodatage et signature des evenements de securite | Non disponible | Pas de preuve d'integrite des logs |

#### Logging structure

| Besoin | Statut | Impact |
|--------|--------|--------|
| Logs au format JSON structure | Non disponible | Impossibilite d'ingestion dans ELK, Datadog, Splunk |
| Correlation d'evenements entre agents et sous-agents | Non disponible | Pas de tracabilite des chaines de delegation |
| Niveaux de log configurables (DEBUG, INFO, WARN, ERROR) | Non disponible | Tout est en texte brut non filtre |

#### Alertes et notifications

| Besoin | Statut | Impact |
|--------|--------|--------|
| Webhooks sur evenements (requete bloquee, erreur, seuil) | Non disponible | L'operateur doit surveiller manuellement |
| Notifications Slack / email / Telegram sur incidents | Non disponible | Pas d'alerte proactive |
| Alertes sur depassement de seuils (tokens, erreurs, latence) | Non disponible | Detection tardive des anomalies |

#### Metriques et dashboards

| Besoin | Statut | Impact |
|--------|--------|--------|
| Export Prometheus / OpenTelemetry | Non disponible | Pas d'integration avec l'ecosysteme d'observabilite |
| Dashboard Grafana (ou equivalent) | Non disponible | Pas de visualisation temps reel avancee |
| Metriques de latence / throughput des requetes d'inference | Non disponible | Pas d'optimisation possible |
| Time-series pour analyse de tendances | Non disponible | Pas de vision historique |

#### API programmatique

| Besoin | Statut | Impact |
|--------|--------|--------|
| API REST/GraphQL pour interroger l'historique d'activite | Non disponible | Automatisation impossible |
| Export des donnees d'activite au format CSV/JSON | Non disponible | Pas de reporting |
| Integration avec des outils BI (Metabase, Looker) | Non disponible | Pas d'analyse business |

> **Perspective** : Ces lacunes sont coherentes avec le statut alpha de NemoClaw. La priorite du projet a ete mise sur la securite (les 4 couches d'isolation) plutot que sur l'observabilite. A mesure que le projet maturera, ces capacites seront probablement ajoutees par NVIDIA ou par la communaute open source.

---

## 10. Retour d'experience : deploiement reel

Cette section documente un deploiement reel du profil personnel sur GCP, realise en mars 2026. Elle decrit les ecueils rencontres, les solutions appliquees et la procedure finale validee.

### 10.1 Contexte du deploiement

| Parametre | Valeur |
|-----------|--------|
| Profil | Personnel (CPU, inference distante) |
| Projet GCP | `nemoclaw-openclaw-mvp` |
| Region | `europe-west9-a` (Paris) |
| Machine | `e2-standard-4` (4 vCPU, 16 GB RAM) |
| OS | Debian 12 (Bookworm) |
| Disque | 50 GB SSD |
| Provider d'inference | NVIDIA Endpoints |
| Modele | `nvidia/nemotron-3-super-120b-a12b` |
| Acces | Tailscale (pas d'IP publique) |
| SSH | Port 2222, cle ED25519, mot de passe desactive |

### 10.2 Ecueils rencontres et solutions

#### Eceuil 1 : VM sous-dimensionnee (`e2-standard-2`)

**Probleme** : La premiere iteration utilisait une `e2-standard-2` (2 vCPU, 8 GB) alors que les pre-requis NemoClaw exigent **minimum 4 vCPU, 8 GB RAM** (recommande 16 GB).

**Solution** : Passage a `e2-standard-4` (4 vCPU, 16 GB). La variable `machine_type` dans `variables.tf` a ete corrigee.

**Lecon** : Toujours verifier les pre-requis hardware dans le README officiel du projet avant de dimensionner l'infrastructure.

#### Eceuil 2 : `npm install -g nemoclaw` installe un package vide

**Probleme** : Le package `nemoclaw` sur le registre npm est un placeholder (alpha). L'installation via `npm install -g nemoclaw` produit un binaire non fonctionnel.

**Solution** : Utiliser le script d'installation officiel NVIDIA :
```bash
curl -fsSL https://www.nvidia.com/nemoclaw.sh | bash
```
Ce script clone les sources depuis GitHub, compile le plugin TypeScript et installe le CLI via `npm link`.

**Lecon** : Pour un projet alpha, toujours se referer a la methode d'installation documentee dans le README officiel, pas a la methode "standard" npm.

#### Eceuil 3 : Tailscale `--shields-up` bloque le SSH

**Probleme** : Le flag `--shields-up` de Tailscale refuse **toutes** les connexions entrantes, y compris le SSH via le reseau Tailscale. Resultat : la VM est provisionnee mais inaccessible.

**Solution** : Ne pas activer `--shields-up` dans le startup script. La securite reseau est deja assuree par :
- Le firewall GCP (deny-all ingress sauf UDP 41641 Tailscale)
- L'absence d'IP publique sur la VM
- Le SSH restreint au CIDR Tailscale (`100.64.0.0/10`)

Le mode `--shields-up` pourra etre active plus tard manuellement, une fois les ACLs Tailscale correctement configurees.

**Lecon** : Tester l'accessibilite SSH avant d'activer des restrictions reseau supplementaires. `--shields-up` necessite une configuration ACL prealable.

#### Eceuil 4 : Cle Tailscale ephemere consommee

**Probleme** : Une cle Tailscale ephemere ne peut etre utilisee qu'**une seule fois**. A chaque `terraform apply -replace` (recreation de la VM), il faut generer une nouvelle cle.

**Solution** : Generer une nouvelle cle dans la console Tailscale (https://login.tailscale.com/admin/settings/keys) avant chaque recreation de VM. Mettre a jour `terraform.tfvars`.

**Lecon** : Pour une automatisation robuste, envisager une cle **reusable** (non-ephemere) ou une integration avec Tailscale OAuth.

#### Eceuil 5 : Machines fantomes dans Tailscale

**Probleme** : Chaque VM detruite par Terraform laisse une entree "offline" dans le reseau Tailscale, car `terraform destroy` ne deconnecte pas la machine de Tailscale.

**Solution** : Nettoyer manuellement via la console Tailscale (https://login.tailscale.com/admin/machines) en supprimant les machines offline.

**Lecon** : Prevoir un `pre-destroy` hook dans Terraform qui execute `tailscale logout` avant la destruction de la VM (amelioration future).

#### Eceuil 6 : `HOME` non defini dans le startup script GCP

**Probleme** : Le script `install.sh` de NemoClaw utilise `$HOME` (via nvm), mais le startup script GCP s'execute en tant que root sans variable `HOME` definie. Le `set -euo pipefail` de l'install script echoue avec `HOME: unbound variable`.

**Solution** : Executer le script d'installation en tant que l'utilisateur admin via `su -` qui definit correctement `HOME` :
```bash
su - "$ADMIN_USER" -c "bash /tmp/nemoclaw-install.sh --non-interactive"
```

**Lecon** : Les startup scripts GCP s'executent en tant que root avec un environnement minimal. Toujours utiliser `su -` pour executer des scripts qui dependent de variables utilisateur.

#### Eceuil 7 : Onboarding echoue en mode non-interactif sans cle API

**Probleme** : L'etape `[2/7] Configuring inference` du script `install.sh` echoue en mode `--non-interactive` si aucune cle API n'est fournie via les variables d'environnement (`NVIDIA_API_KEY`, `OPENAI_API_KEY`, etc.).

**Solution actuelle** : Deploiement semi-automatise. Le startup script installe tout (Docker, Tailscale, hardening, NemoClaw CLI, OpenShell), puis l'administrateur se connecte en SSH et lance `nemoclaw onboard` interactivement.

**Solution future** : Passer la cle API via les metadata GCP et les variables d'environnement du mode non-interactif (voir section 11.1).

#### Eceuil 8 : Cloud NAT oublie

**Probleme** : La VM sans IP publique ne peut pas acceder a Internet pour telecharger les paquets (Docker, Node.js, Tailscale, NemoClaw). Le `private_ip_google_access` ne couvre que les APIs Google, pas les depots externes.

**Solution** : Ajouter un Cloud Router + Cloud NAT dans le Terraform :
```hcl
resource "google_compute_router" "nemoclaw" { ... }
resource "google_compute_router_nat" "nemoclaw" {
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
```

**Lecon** : Toute VM sans IP publique qui a besoin d'acceder a Internet necessite un Cloud NAT.

### 10.3 Procedure validee de bout en bout

Voici la procedure exacte qui a abouti a un deploiement fonctionnel :

**Sur le PC local** :

```bash
# 1. Generer la cle SSH
ssh-keygen -t ed25519 -C "nemoclaw-admin" -f ~/.ssh/nemoclaw_ed25519 -N ""

# 2. Creer un compte Tailscale + generer une cle auth ephemere
#    https://login.tailscale.com/admin/settings/keys

# 3. Configurer terraform.tfvars
cd terraform/gcp-personal
cat > terraform.tfvars <<EOF
project_id         = "mon-projet-gcp"
region             = "europe-west9"
zone               = "europe-west9-a"
tailscale_auth_key = "tskey-auth-xxxxxxxxxx"
ssh_public_key     = "$(cat ~/.ssh/nemoclaw_ed25519.pub)"
admin_user         = "nemoclaw-admin"
instance_name      = "nemoclaw-personal"
EOF

# 4. Deployer
terraform init
terraform plan
terraform apply

# 5. Attendre ~6 minutes (startup script)
# Verifier les logs :
gcloud compute instances get-serial-port-output nemoclaw-personal \
  --zone=europe-west9-a --project=mon-projet-gcp

# 6. Installer Tailscale sur le PC local (une seule fois)
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# 7. Se connecter a la VM
ssh -p 2222 -i ~/.ssh/nemoclaw_ed25519 nemoclaw-admin@<tailscale-ip>
```

**Sur la VM GCP** :

```bash
# 8. Lancer l'onboarding NemoClaw
nemoclaw onboard

# Repondre aux questions :
#   Provider : 1 (NVIDIA Endpoints)
#   API Key  : nvapi-xxxxxxxxxx
#   Modele   : 1 (Nemotron 3 Super 120B)
#   Sandbox  : my-assistant
#   Policies : Y (pypi, npm)

# 9. Se connecter au sandbox
openshell sandbox connect my-assistant

# 10. Lancer l'agent
openclaw tui
```

**Temps total** : ~15 minutes (dont 6 min de startup script + 5 min de build Docker sandbox).

### 10.4 Lecons apprises

1. **Toujours lire le README officiel** avant de coder l'automatisation. Les pre-requis hardware et la methode d'installation sont la source de verite.

2. **Le script `install.sh` est monolithique** : il gere Node.js, NemoClaw, OpenShell et l'onboarding. Ne pas essayer de le decouper — le laisser faire son travail.

3. **Le mode semi-automatise est le bon compromis pour l'instant** : l'infrastructure est automatisee (Terraform), l'onboarding est interactif (choix du provider, cle API, nom du sandbox).

4. **Tailscale et VPC sont complementaires** mais le `--shields-up` necessite une configuration ACL prealable. Sans ACL, le SSH est bloque.

5. **Les cles Tailscale ephemeres sont a usage unique**. Chaque recreation de VM necessite une nouvelle cle.

6. **Cloud NAT est indispensable** pour toute VM GCP sans IP publique qui doit acceder a Internet.

7. **L'agent OpenClaw met ~1 minute pour repondre** au premier message (chargement du modele cote NVIDIA Endpoints). Les messages suivants sont plus rapides.

---

## 11. Axes de reflexion et evolutions

### 11.1 Onboarding entierement automatise

**Objectif** : Eliminer l'etape manuelle de `nemoclaw onboard` pour un deploiement 100% automatique via Terraform.

**Approche envisagee** :

1. Passer la cle API via GCP Secret Manager (pas en metadata pour des raisons de securite) :
```hcl
resource "google_secret_manager_secret_version" "nvidia_api_key" {
  secret      = google_secret_manager_secret.nvidia_api_key.id
  secret_data = var.nvidia_api_key
}
```

2. Le startup script recupere la cle et l'exporte avant de lancer l'install :
```bash
NVIDIA_API_KEY=$(gcloud secrets versions access latest --secret=nvidia-api-key)
export NVIDIA_API_KEY
export NEMOCLAW_NON_INTERACTIVE=1
export NEMOCLAW_PROVIDER=build
export NEMOCLAW_MODEL=nvidia/nemotron-3-super-120b-a12b
export NEMOCLAW_SANDBOX_NAME=my-assistant
su - "$ADMIN_USER" -c "
  export NVIDIA_API_KEY='$NVIDIA_API_KEY'
  export NEMOCLAW_NON_INTERACTIVE=1
  bash /tmp/nemoclaw-install.sh --non-interactive
"
```

3. Le mode `--non-interactive` du script `install.sh` supporte toutes ces variables d'environnement (documente dans le README).

**Complexite** : Moyenne. Necessite l'activation de l'API Secret Manager, un IAM binding pour le service account de la VM, et la gestion du cycle de vie du secret.

**Statut** : Nice to have. A implementer quand le flux semi-automatise sera stabilise.

### 11.2 Industrialisation via service web

**Objectif** : Proposer un service web en self-service qui permet a des clients non-techniques de provisionner un environnement NemoClaw complet sans manipuler Terraform, SSH ou les cles API.

**Vision fonctionnelle** :

1. **Interface web** : Le client se connecte, choisit son profil (personnel/entreprise), sa region, son provider d'inference, et fournit sa cle API.
2. **Backend** : Un service orchestre le provisionnement via l'API Terraform Cloud ou directement via l'API GCP :
   - Creation du VPC, firewall, Cloud NAT, VM
   - Execution du startup script (hardening + installation NemoClaw)
   - Onboarding automatise (mode non-interactif avec les parametres fournis par le client)
3. **Resultat** : Le client recoit une URL Tailscale (ou un tunnel Cloudflare) pour acceder a son dashboard OpenClaw, sans jamais toucher a un terminal.

**Architecture envisagee** :

```
Client (navigateur)
    |
    v
Service Web (FastAPI / Next.js)
    |
    ├── Terraform Cloud API → Provisionnement GCP
    ├── Tailscale API → Enregistrement machine + ACLs
    ├── GCP Secret Manager → Stockage cles API
    └── Webhook → Notification de fin de deploiement
```

**Defis techniques** :

| Defi | Complexite | Solution envisagee |
|------|-----------|-------------------|
| Gestion multi-tenant des VPCs | Elevee | Un VPC par client avec isolation stricte |
| Distribution des cles Tailscale | Moyenne | Tailscale OAuth ou API d'invitation |
| Cycle de vie des sandboxes | Moyenne | Dashboard d'administration avec start/stop/destroy |
| Facturation et quotas | Elevee | Integration avec Stripe + suivi des couts GCP par label |
| Monitoring centralise | Elevee | Agent de collecte sur chaque VM → dashboard central |
| Securite des cles API clients | Critique | Chiffrement at-rest, rotation automatique, audit trail |
| Haute disponibilite du service web | Moyenne | Deploiement sur Cloud Run ou GKE |

**Phases de mise en oeuvre** :

| Phase | Scope | Duree estimee |
|-------|-------|---------------|
| Phase 1 — MVP | Interface web basique + provisionnement GCP automatise (profil personnel uniquement) | 4-6 semaines |
| Phase 2 — Multi-tenant | Isolation VPC, profil entreprise, gestion des ACLs Tailscale | 6-8 semaines |
| Phase 3 — Production | Facturation, monitoring centralise, haute disponibilite, support client | 8-12 semaines |

### 11.3 Autres evolutions envisagees

| Evolution | Description | Priorite |
|-----------|-------------|----------|
| **Tailscale logout pre-destroy** | Hook Terraform qui execute `tailscale logout` avant destruction de la VM pour eviter les machines fantomes | Haute |
| **Cle Tailscale reusable** | Utiliser une cle non-ephemere ou l'API OAuth Tailscale pour eviter la regeneration manuelle a chaque recreation de VM | Haute |
| **Backup workspace automatise** | Integrer le script `nemoclaw-backup` dans le startup script avec cron pre-configure | Moyenne |
| **Alertes Tailscale** | Notification si la VM perd sa connexion Tailscale (machine offline) | Moyenne |
| **Support multi-region** | Permettre le choix de la region dans le service web avec calcul de latence | Basse |
| **Template Packer** | Image VM pre-construite avec Docker, Node.js, Tailscale, hardening pour accelerer le provisionnement (startup en 1 min au lieu de 6) | Moyenne |
| **Terraform modules reutilisables** | Factoriser les profils personnel/entreprise en modules Terraform partages | Basse |

---

## Annexes

### A. Glossaire

| Terme | Definition |
|-------|-----------|
| **OpenClaw** | Agent autonome ("always-on assistant") qui execute des taches en continu |
| **OpenShell** | Runtime sandbox de NVIDIA — conteneur isole avec gateway, policies et inference routing |
| **NemoClaw** | Stack de reference qui orchestre le deploiement d'OpenClaw dans OpenShell |
| **Blueprint** | Artefact Python versionne qui definit comment creer un sandbox (image, inference, policies) |
| **Gateway** | Composant OpenShell qui intercepte le trafic reseau et d'inference du sandbox |
| **Sandbox** | Conteneur Docker isole ou l'agent OpenClaw s'execute |
| **Landlock** | Module de securite du noyau Linux pour le controle d'acces au systeme de fichiers |
| **gosu** | Outil qui permet d'executer des commandes en tant qu'un autre utilisateur (alternative legere a `su`) |
| **SSRF** | Server-Side Request Forgery — attaque ou un serveur est trompe pour acceder a des ressources internes |
| **Tailscale** | Service VPN mesh base sur WireGuard, cree un reseau prive entre les machines |
| **TUI** | Terminal User Interface — interface textuelle d'OpenShell pour approuver les requetes reseau |
| **DAC** | Discretionary Access Control — controle d'acces base sur les permissions Unix (chmod, chown) |
| **nftables** | Framework de filtrage de paquets du noyau Linux (successeur d'iptables) |
| **PVC** | Persistent Volume Claim — volume de stockage persistant dans Kubernetes, attache au pod du sandbox |
| **VPC** | Virtual Private Cloud — reseau isole dans GCP |

### B. Liens utiles

| Ressource | URL |
|-----------|-----|
| NemoClaw GitHub | `https://github.com/NVIDIA/NemoClaw` |
| OpenShell GitHub | `https://github.com/NVIDIA/OpenShell` |
| OpenClaw | `https://openclaw.ai` |
| NVIDIA Build (cles API) | `https://build.nvidia.com` |
| Tailscale | `https://tailscale.com` |
| Terraform | `https://developer.hashicorp.com/terraform` |
| Debian 12 | `https://www.debian.org/releases/bookworm/` |

### C. Depannage courant

**Le port 8080 ou 18789 est occupe** :

```bash
# Identifier le processus
sudo lsof -i :8080
sudo lsof -i :18789

# Ou tuer le processus
sudo kill -9 <PID>
```

**Docker n'est pas en cours d'execution** :

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

**GPU non detecte** :

```bash
# Verifier les drivers NVIDIA
nvidia-smi

# Si absent, installer les drivers
sudo apt-get install -y nvidia-driver
```

**Gateway obsolete** :

```bash
# Lister les gateways
openshell gateway list

# Detruire un gateway obsolete
openshell gateway destroy nemoclaw
```

**Sandbox ne demarre pas** :

```bash
# Verifier les logs de build
nemoclaw <nom> logs

# Verifier l'etat du pod
openshell sandbox list

# Recree le sandbox
nemoclaw <nom> destroy --yes
nemoclaw onboard
```

**Impossible de se connecter via Tailscale** :

```bash
# Sur le serveur
tailscale status
tailscale ip -4

# Sur la machine locale
tailscale ping <tailscale-ip-du-serveur>
```

**Erreur SSRF lors de la configuration d'un endpoint custom** :

L'erreur "Endpoint URL resolves to private/internal address" signifie que l'URL pointe vers une adresse IP privee (127.x, 10.x, 172.16-31.x, 192.168.x). Pour les fournisseurs locaux (Ollama, vLLM), utilisez les providers dedies plutot qu'un endpoint custom.
