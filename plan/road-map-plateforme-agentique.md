# Roadmap — Plateforme Agentique pour TPE/PME

> Date : 2026-04-03
> Projet : Azeka Consulting — NemoClaw + OpenClaw + Paperclip
> Fichier : `plan/road-map-plateforme-agentique.md`

---

## Vision

Creer une **plateforme agentique en self-service** pour les TPE/PME, deployee automatiquement sur GCP.

| Couche | Role | Technologie |
|--------|------|-------------|
| **Infrastructure** | Provisionnement automatise | Terraform + GCP + Tailscale |
| **Securite & Isolation** | Sandbox agent securise | NemoClaw (OpenShell + OpenClaw) |
| **Execution** | Agents IA autonomes, multi-agents | OpenClaw (orchestration, tools, skills, memory) |
| **Gouvernance** | Workflows metier, budgets, audit | Paperclip (a integrer en phase 3) |
| **Interface** | Acces client non-technique | Service web (a construire en phase 4) |

---

## Etat actuel (2026-04-03)

| Element | Statut |
|---------|--------|
| Guide utilisateur FR (2065 lignes) | Termine, committe |
| Terraform GCP (2 profils) | Termine, committe |
| VM GCP Paris (e2-standard-4) | Active, NemoClaw fonctionnel |
| Sandbox `my-mvp-compagny` | Actif, agent DimaOne + Nemotron 120B |
| Etude OpenClaw orchestration | Terminee (sections 6.7-6.9) |
| Etude Paperclip | Terminee (architecture validee) |

---

## Phase 1 — Cas d'usage metier : Equipe de Prospection Commerciale

### 1.0 Contexte

Deployer une equipe de 5 agents IA (1 maitre + 4 workers) dans le sandbox existant pour valider la capacite d'orchestration multi-agents d'OpenClaw dans NemoClaw.

**Source** : `/home/abdelilah/azeka-consulting/labs/openclaw/mydocs/etude-openclaw-orchestration.md` (sections 6.7-6.9)

### 1.1 Parametres retenus

| Parametre | Choix | Justification |
|-----------|-------|---------------|
| Sandbox | Modifier `my-mvp-compagny` | Hot-reload, evite reconfiguration complete |
| LLM | NVIDIA Nemotron 3 Super 120B | Deja configure, gratuit (credits NVIDIA) |
| APIs externes | Minimum viable (web_fetch natif) | Zero cout additionnel pour le MVP |
| Canal | CLI uniquement (openclaw tui) | Le plus simple pour valider le workflow |
| Memoire | Desactivee (pas d'embeddings) | Pas de provider configure |

### 1.2 Architecture de l'equipe

| Agent | Role | Outils |
|-------|------|--------|
| `prospection-manager` | Maitre orchestrateur | `group:sessions`, `group:fs` |
| `lead-researcher` | Recherche de prospects | `group:web`, `group:fs` |
| `market-analyst` | Analyse de marche | `group:web`, `group:fs` |
| `lead-qualifier` | Scoring et qualification | `group:web`, `group:fs` |
| `copywriter` | Redaction emails | `group:web`, `group:fs` |

### 1.3 Contrainte critique : openclaw.json immutable

Dans le sandbox NemoClaw, le fichier `openclaw.json` est :
- Proprietaire `root:root`, permissions `444`
- Protege par Landlock (repertoire `.openclaw` en lecture seule)
- Integrite verifiee au boot par hash SHA256
- `configWrites` desactive dans la config channels

Les declarations d'agents (IDs, outils, subagents) vivent dans `openclaw.json` sous `agents.list`.
**Il n'y a pas de mecanisme de decouverte d'agents depuis le filesystem.**

**Consequence** : il faut **reconstruire le sandbox** avec un Dockerfile modifie qui bake la config 5 agents.

### 1.4 Etapes de realisation

#### Etape 0 : Backup du sandbox actuel

```bash
ssh -p 2222 -i ~/.ssh/nemoclaw_ed25519 nemoclaw-admin@<tailscale-ip>
SANDBOX="my-mvp-compagny"
BACKUP_DIR=~/.nemoclaw/backups/$(date +%Y%m%d-%H%M%S)
mkdir -p "$BACKUP_DIR"
openshell sandbox download "$SANDBOX" /sandbox/.openclaw/workspace/ "$BACKUP_DIR/"
```

#### Etape 1 : Modifier le Dockerfile

**Fichier** : `/home/abdelilah/azeka-consulting/labs/NemoClaw/Dockerfile`

**Modification 1** — Ajouter les repertoires agents (ligne ~54) :

Ajouter dans le bloc `RUN mkdir -p` :
```
/sandbox/.openclaw-data/agents/prospection-manager/agent
/sandbox/.openclaw-data/agents/prospection-manager/workspace
/sandbox/.openclaw-data/agents/lead-researcher/agent
/sandbox/.openclaw-data/agents/lead-researcher/workspace
/sandbox/.openclaw-data/agents/market-analyst/agent
/sandbox/.openclaw-data/agents/market-analyst/workspace
/sandbox/.openclaw-data/agents/lead-qualifier/agent
/sandbox/.openclaw-data/agents/lead-qualifier/workspace
/sandbox/.openclaw-data/agents/copywriter/agent
/sandbox/.openclaw-data/agents/copywriter/workspace
```

**Modification 2** — Modifier le generateur Python `openclaw.json` (lignes 131-170) :

Remplacer le bloc `config = { ... }` par une version qui inclut :
- `agents.defaults.subagents` : maxSpawnDepth=1, maxConcurrent=8, runTimeoutSeconds=600
- `agents.list` : 5 agents avec leurs IDs, identites, outils, et permissions subagents
- Adapter le modele : tous les agents utilisent `primary_model_ref` (Nemotron via inference.local)
- Pas de bindings channels (CLI only)
- Pas de memorySearch (MVP)
- Pas de MCP servers (MVP)

**Adaptation du modele** (etude → NemoClaw) :

| Etude (section 6.7) | NemoClaw |
|---------------------|----------|
| `anthropic/claude-opus-4-6` (manager) | `primary_model_ref` (Nemotron 120B via inference.local) |
| `anthropic/claude-sonnet-4-6` (workers) | `primary_model_ref` (meme modele pour tous) |
| Channels Telegram + WhatsApp | Aucun (CLI only) |
| MCP servers (firecrawl, postgres) | Aucun (MVP) |
| Memory (openai embeddings) | Desactivee |

#### Etape 2 : Creer les fichiers workspace des agents

**Repertoire local** : `~/prospection-agents/`

Creer l'arborescence :
```
~/prospection-agents/
  prospection-manager/AGENTS.md, SOUL.md, IDENTITY.md
  lead-researcher/AGENTS.md, SOUL.md, IDENTITY.md
  market-analyst/AGENTS.md, SOUL.md, IDENTITY.md
  lead-qualifier/AGENTS.md, SOUL.md, IDENTITY.md
  copywriter/AGENTS.md, SOUL.md, IDENTITY.md
  shared/schemas/
    lead-list.schema.md
    market-report.schema.md
    qualified-leads.schema.md
    email-campaign.schema.md
```

**Contenu** : Reprendre les sections 6.7 (base) + 6.9.5 (echanges structures) de l'etude.

**Adaptation des chemins** : Remplacer `~/.openclaw/shared/` par `/sandbox/shared/` (repertoire entierement accessible en ecriture dans le sandbox).

#### Etape 3 : Reconstruire le sandbox

```bash
# Detruire l'ancien sandbox
nemoclaw my-mvp-compagny destroy --yes

# Relancer l'onboarding (utilise le Dockerfile modifie)
nemoclaw onboard
# Provider : NVIDIA Endpoints (meme cle API)
# Modele : Nemotron 3 Super 120B
# Sandbox name : my-mvp-compagny
# Policies : pypi, npm
```

#### Etape 4 : Uploader les fichiers workspace et schemas

```bash
SANDBOX="my-mvp-compagny"

# Workspace des agents
for agent in prospection-manager lead-researcher market-analyst lead-qualifier copywriter; do
  for file in AGENTS.md SOUL.md IDENTITY.md; do
    openshell sandbox upload "$SANDBOX" \
      ~/prospection-agents/$agent/$file \
      /sandbox/.openclaw/agents/$agent/workspace/
  done
done

# Schemas d'echange
for schema in lead-list.schema.md market-report.schema.md qualified-leads.schema.md email-campaign.schema.md; do
  openshell sandbox upload "$SANDBOX" \
    ~/prospection-agents/shared/schemas/$schema \
    /sandbox/shared/schemas/
done

# Creer les repertoires d'echange
openshell sandbox connect "$SANDBOX" -- bash -c '
  mkdir -p /sandbox/shared/exchange/{leads,market-reports,qualified,campaigns}
'
```

#### Etape 5 : Politique reseau pour le web

**Probleme** : La politique deny-by-default bloque `web_fetch`.

**MVP** : Ajouter une politique pour les domaines cibles de la prospection :

```yaml
web_access:
  name: web_access
  endpoints:
    - host: "*.linkedin.com"
      port: 443
      rules: [{ allow: { method: GET, path: "/**" } }]
    - host: "*.crunchbase.com"
      port: 443
      rules: [{ allow: { method: GET, path: "/**" } }]
    - host: "*.google.com"
      port: 443
      rules: [{ allow: { method: GET, path: "/**" } }]
  binaries:
    - { path: /usr/local/bin/node }
```

Appliquer dynamiquement :
```bash
openshell policy set web-access-policy.yaml my-mvp-compagny
```

> Note : cette politique est session-only. Pour la persister, l'integrer dans `openclaw-sandbox.yaml` avant le rebuild.

#### Etape 6 : Tests end-to-end

| Test | Commande | Resultat attendu |
|------|----------|-----------------|
| Config 5 agents | `cat /sandbox/.openclaw/openclaw.json \| python3 -c "import json,sys; print(len(json.load(sys.stdin)['agents']['list']))"` | `5` |
| Agent repond | `openclaw agent --agent prospection-manager --local -m "Bonjour"` | Reponse Nemotron |
| Spawn worker | `openclaw agent --agent prospection-manager --local -m "Lance une campagne test sur les DSI fintech FR. campaignId=test-001"` | Logs montrent le spawn de lead-researcher et market-analyst |
| Fichiers echange | `ls /sandbox/shared/exchange/leads/` | Fichier JSON cree par lead-researcher |
| Pipeline complet | Campagne complete via openclaw tui | Rapport final avec leads + marche + emails |

### 1.5 Risques et limitations

| Risque | Impact | Mitigation |
|--------|--------|------------|
| `web_search` hallucine sans provider | Donnees fictives (faux leads, faux emails) | Ajouter Brave Search (gratuit 2000 req/mois) des que possible |
| Nemotron moins fiable que Claude pour le tool-calling multi-step | Orchestration echoue ou boucle | Tester d'abord un spawn simple (2 agents) avant le pipeline complet |
| Context window pression (131K tokens) | Rapport tronque | Augmenter maxTokens si necessaire |
| Pas de memoire inter-campagnes | Chaque campagne repart de zero | Acceptable pour le MVP |
| Rebuild sandbox pour chaque changement de config | 3-5 min par iteration | Planifier les changements de config en batch |

### 1.6 Livrables

| Livrable | Fichier |
|----------|---------|
| Dockerfile modifie | `Dockerfile` (config 5 agents) |
| Fichiers workspace (5 agents x 3 fichiers) | `~/prospection-agents/` |
| Schemas d'echange (4 fichiers) | `~/prospection-agents/shared/schemas/` |
| Politique reseau web | `web-access-policy.yaml` |
| Documentation deploiement | Mise a jour du guide section 10 |

---

## Phase 2 — Ameliorations du cas de prospection

| # | Action | Priorite |
|---|--------|----------|
| 2.1 | Ajouter Brave Search API (gratuit 2000 req/mois) pour `web_search` reel | Haute |
| 2.2 | Ajouter Firecrawl pour le scraping intelligent (LinkedIn, sites corporate) | Haute |
| 2.3 | Activer la memoire (embeddings OpenAI) pour capitaliser inter-campagnes | Moyenne |
| 2.4 | Ajouter le canal Telegram (piloter la campagne par bot) | Moyenne |
| 2.5 | Ajouter les notifications WhatsApp (resume executif) | Basse |
| 2.6 | Connecter un CRM PostgreSQL via MCP server | Basse |
| 2.7 | Creer des skills metier (framework email AIDA, scoring B2B) | Moyenne |

---

## Phase 3 — Integration Paperclip : meme cas d'usage, orchestration differente

### 3.0 Objectif

Deployer la **meme equipe de prospection commerciale** (5 agents) mais orchestree par **Paperclip** au lieu d'OpenClaw natif. Cela permet un **comparatif factuel** des deux approches sur le meme cas d'usage.

### 3.1 Comparatif des approches

| Critere | Approche A — OpenClaw natif (Phase 1) | Approche B — Paperclip (Phase 3) |
|---------|----------------------------------------|----------------------------------|
| **Orchestration** | `sessions_spawn` / `sessions_yield` dans openclaw.json | Taches Paperclip, heartbeat scheduler, API REST |
| **Declaration des agents** | Bake dans openclaw.json (immutable) | Dashboard Paperclip (dynamique, modifiable a chaud) |
| **Communication inter-agents** | Auto-announce + fichiers JSON partages | API taches + commentaires + webhooks |
| **Suivi des couts** | Aucun | Cost events par agent/tache/projet |
| **Audit** | Logs texte brut | Activity log immutable avec acteur, timestamp |
| **Gouvernance** | Aucune | Approbations board, budgets hard-stop |
| **Modification de config** | Rebuild sandbox (3-5 min) | Dashboard UI (instantane) |
| **Visibilite** | `openclaw tui` / `nemoclaw logs` | Dashboard web avec historique complet |
| **Canal de pilotage** | CLI / Telegram direct | Dashboard Paperclip + API |

### 3.2 Architecture Paperclip pour la prospection

```
Paperclip (Docker)
  |
  ├── Entreprise "Azeka Prospection"
  │     ├── Objectif : "Generer des leads qualifies pour les clients TPE/PME"
  │     ├── Projet : "Campagne Fintech DSI France"
  │     │
  │     ├── Agent "Prospection Manager" (CEO)
  │     │     adapter: openclaw_gateway → ws://127.0.0.1:18789
  │     │     role: CEO, orchestre les taches
  │     │
  │     ├── Agent "Lead Researcher"
  │     │     adapter: openclaw_gateway
  │     │     role: Engineer, recherche de prospects
  │     │
  │     ├── Agent "Market Analyst"
  │     │     adapter: openclaw_gateway
  │     │     role: Engineer, analyse de marche
  │     │
  │     ├── Agent "Lead Qualifier"
  │     │     adapter: openclaw_gateway
  │     │     role: Engineer, scoring et qualification
  │     │
  │     └── Agent "Copywriter"
  │           adapter: openclaw_gateway
  │           role: Engineer, redaction emails
  │
  └── PostgreSQL (suivi couts, audit, taches)
```

Chaque agent Paperclip se connecte au **meme sandbox NemoClaw** via l'adaptateur `openclaw-gateway` (WebSocket). Paperclip gere l'orchestration (qui fait quoi, quand, combien), OpenClaw/NemoClaw gere l'execution securisee.

### 3.3 Etapes de realisation

| # | Action | Detail |
|---|--------|--------|
| 3.3.1 | Redimensionner VM a e2-standard-8 (8 vCPU, 32 GB) + disque data 50 GB | Terraform |
| 3.3.2 | Creer repo `nemoclaw-infra` (CI/CD, compose, workflows) | GitHub |
| 3.3.3 | Build image Docker Paperclip → push GHCR | GitHub Actions |
| 3.3.4 | `docker-compose.prod.yml` (Paperclip + PostgreSQL, volumes /data) | Deploiement |
| 3.3.5 | Deployer Paperclip sur la VM | `docker compose up -d` |
| 3.3.6 | Creer l'entreprise "Azeka Prospection" dans Paperclip | Dashboard UI |
| 3.3.7 | Configurer les 5 agents avec l'adaptateur `openclaw-gateway` | Dashboard UI + token OpenClaw |
| 3.3.8 | Creer le projet "Campagne Fintech DSI" + objectif + taches | Dashboard UI |
| 3.3.9 | Lancer la campagne via Paperclip (heartbeat ou assignation manuelle) | Dashboard UI |
| 3.3.10 | Comparer les resultats avec l'Approche A (Phase 1) | Rapport comparatif |

### 3.4 Grille de comparaison (a remplir apres execution)

| Critere | Approche A (OpenClaw) | Approche B (Paperclip) | Gagnant |
|---------|----------------------|------------------------|---------|
| Temps de configuration | ? min | ? min | ? |
| Temps d'execution campagne | ? min | ? min | ? |
| Qualite des resultats (leads) | ? / 10 | ? / 10 | ? |
| Visibilite operateur | ? / 10 | ? / 10 | ? |
| Suivi des couts | Oui / Non | Oui / Non | ? |
| Facilite de modification | ? / 10 | ? / 10 | ? |
| Robustesse (erreurs, retry) | ? / 10 | ? / 10 | ? |
| Industrialisable pour clients | ? / 10 | ? / 10 | ? |

### 3.5 Decision post-comparatif

Le resultat du comparatif determinera l'approche retenue pour la Phase 4 (industrialisation) :
- Si **Approche A** gagne : la plateforme utilise OpenClaw natif, Paperclip en option pour la gouvernance
- Si **Approche B** gagne : la plateforme utilise Paperclip comme orchestrateur principal
- Si **complementaires** : OpenClaw pour l'execution, Paperclip pour la gouvernance (architecture hybride)

**Apport Paperclip** : suivi des couts/tokens, audit persistant, orchestration multi-sandbox, gouvernance par approbation, API interrogeable, dashboard centralise.

---

## Phase 4 — Industrialisation (service web self-service)

| # | Action | Detail |
|---|--------|--------|
| 4.1 | MVP service web (FastAPI/Next.js) pour provisionnement self-service | Frontend + Backend |
| 4.2 | Integration Terraform Cloud API pour provisionnement GCP automatise | Infrastructure |
| 4.3 | Integration Tailscale API pour enregistrement machine + ACLs | Reseau |
| 4.4 | Gestion multi-tenant (1 VPC par client, isolation stricte) | Architecture |
| 4.5 | Facturation et quotas (Stripe + suivi couts GCP par label) | Business |
| 4.6 | Monitoring centralise (collecte → dashboard central) | Observabilite |
| 4.7 | Template Packer (image VM pre-construite, startup en 1 min) | Performance |

---

## Criteres de passage entre phases

| Transition | Critere de validation |
|------------|----------------------|
| Phase 1 → Phase 2 | Pipeline 5 agents fonctionne de bout en bout via CLI. Le prospection-manager orchestre les 4 workers et produit un rapport complet. |
| Phase 2 → Phase 3 | Campagnes de prospection avec donnees reelles (Brave Search + Firecrawl). Canal Telegram fonctionnel. |
| Phase 3 → Phase 4 | Comparatif Approche A vs B realise. Grille de comparaison remplie. Decision prise sur l'architecture retenue pour l'industrialisation. |

---

## Fichiers critiques pour l'implementation

| Fichier | Role |
|---------|------|
| `/home/abdelilah/azeka-consulting/labs/NemoClaw/Dockerfile` | Modifier pour bake la config 5 agents |
| `/home/abdelilah/azeka-consulting/labs/NemoClaw/nemoclaw-blueprint/policies/openclaw-sandbox.yaml` | Ajouter politique web access |
| `/home/abdelilah/azeka-consulting/labs/NemoClaw/scripts/nemoclaw-start.sh` | Reference pour comprendre le boot du sandbox |
| `/home/abdelilah/azeka-consulting/labs/openclaw/mydocs/etude-openclaw-orchestration.md` | Source des configs agents (sections 6.7-6.9) |
| `/home/abdelilah/azeka-consulting/labs/NemoClaw/docs/guide-utilisateur-nemoclaw.md` | A mettre a jour apres chaque phase |
