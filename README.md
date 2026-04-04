# Cipher Studio — Autonomous Digital Products Business

> AI-powered system for researching, creating, listing, marketing, and selling digital products on Etsy + Payhip — with a 30-minute weekly review cadence.

**Website:** cipherstudio.co  
**Products:** Spreadsheet templates, Notion templates, business document bundles  
**Audience:** Freelancers and small business owners

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        CIPHER STUDIO SYSTEM                     │
│                                                                 │
│  ┌──────────┐    ┌──────────────────────────────────────────┐  │
│  │  Weekly  │    │              n8n (Railway)                │  │
│  │  Review  │◄───│  Orchestration layer — triggers, routes, │  │
│  │Dashboard │    │  schedules, and connects all agents       │  │
│  └──────────┘    └──────────┬───────────────────────────────┘  │
│                             │                                   │
│         ┌───────────────────┼───────────────────────┐          │
│         ▼                   ▼                       ▼          │
│  ┌─────────────┐   ┌──────────────┐   ┌──────────────────┐    │
│  │  Research   │   │  Creation    │   │    Listing       │    │
│  │   Agent     │   │   Agent      │   │    Agent         │    │
│  │             │   │              │   │                  │    │
│  │ Etsy trend  │   │ Generate     │   │ Write titles,    │    │
│  │ scraping,   │   │ product      │   │ descriptions,    │    │
│  │ scoring,    │   │ content via  │   │ tags, pricing    │    │
│  │ opportunity │   │ Claude       │   │ via Claude       │    │
│  │ ranking     │   │              │   │                  │    │
│  └──────┬──────┘   └──────┬───────┘   └──────┬───────────┘    │
│         │                 │                   │                │
│         ├─────────────────┼───────────────────┘                │
│         ▼                 ▼                                     │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                  Supabase (Free Tier)                    │  │
│  │  products │ opportunities │ listings │ orders │ metrics  │  │
│  └──────────────────────────────────────────────────────────┘  │
│         │                 │                                     │
│         ▼                 ▼                                     │
│  ┌─────────────┐   ┌──────────────┐   ┌──────────────────┐    │
│  │  Marketing  │   │  Customer    │   │    Finance       │    │
│  │   Agent     │   │  Service     │   │    Agent         │    │
│  │             │   │   Agent      │   │                  │    │
│  │ Social copy,│   │ Auto-reply   │   │ Revenue, costs,  │    │
│  │ Pinterest,  │   │ to Etsy/     │   │ margin tracking, │    │
│  │ email ideas │   │ Payhip msgs  │   │ weekly reports   │    │
│  └─────────────┘   └──────────────┘   └──────────────────┘    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Agent Breakdown

| Agent | Model | Trigger | Output |
|---|---|---|---|
| **Research** | Sonnet | Daily 6am | Ranked opportunity list → Supabase |
| **Creation** | Sonnet | On approved opportunity | Product file + metadata → Supabase |
| **Listing** | Haiku | On created product | Etsy/Payhip listing draft → Supabase |
| **Marketing** | Haiku | On published listing | Social captions, Pinterest pins |
| **Customer Service** | Haiku | On incoming message | Draft reply (auto-send or staged) |
| **Finance** | Haiku | Weekly Sunday 8pm | Revenue/expense report → Dashboard |

---

## Tech Stack

| Layer | Tool | Purpose |
|---|---|---|
| **Orchestration** | n8n on Railway | Visual workflows, scheduling, routing |
| **AI (reasoning)** | Claude Sonnet | Research, content creation, complex tasks |
| **AI (fast/cheap)** | Claude Haiku | Listings, replies, reports |
| **Database** | Supabase (Postgres) | All structured data + file storage |
| **Storefronts** | Etsy + Payhip | Product listing and sales |
| **Version Control** | GitHub | Workflow exports, prompts, config |

---

## Project Structure

```
cipher-studio/
├── agents/
│   ├── research/         # Research agent logic and prompts
│   ├── creation/         # Content creation workflows
│   ├── listing/          # Listing optimization
│   ├── marketing/        # Social + email copy
│   ├── customer-service/ # Auto-reply logic
│   └── finance/          # Tracking and reporting
│
├── n8n/
│   └── workflows/        # Exported n8n workflow JSON files
│
├── supabase/
│   ├── migrations/       # Schema SQL migrations
│   ├── functions/        # Edge functions (if any)
│   └── seed/             # Seed data for dev
│
├── prompts/              # Claude system + user prompts (versioned)
│   ├── research/
│   ├── creation/
│   ├── listing/
│   ├── marketing/
│   ├── customer-service/
│   └── finance/
│
├── docs/
│   ├── architecture.md   # Deep-dive architecture notes
│   ├── setup.md          # Full setup guide
│   └── weekly-review.md  # 30-min review SOP
│
└── scripts/
    ├── setup.sh          # One-shot environment bootstrap
    └── deploy.sh         # Deploy workflows to Railway n8n
```

---

## Phases

### Phase 1 — Foundation ✅
- Define business model, products, audience
- Choose tech stack

### Phase 2 — Scaffold (Current)
- [x] Project structure
- [ ] Railway + n8n deployment
- [ ] Supabase schema + connection
- [ ] Research Agent (first live workflow)

### Phase 3 — Core Agents
- [ ] Creation Agent
- [ ] Listing Agent (Etsy + Payhip)
- [ ] Finance Agent + weekly dashboard

### Phase 4 — Growth Agents
- [ ] Marketing Agent
- [ ] Customer Service Agent
- [ ] A/B testing on listings

### Phase 5 — Autonomy
- [ ] Full weekly digest email
- [ ] Approval queue UI (simple web dashboard)
- [ ] Self-healing workflows (error retries, alerts)

---

## Weekly Review SOP (30 min)

See [`docs/weekly-review.md`](docs/weekly-review.md)

1. **Finance snapshot** (5 min) — revenue, orders, top products
2. **Research queue** (10 min) — approve/reject opportunities from Research Agent
3. **Listing review** (10 min) — approve staged listings
4. **Marketing queue** (5 min) — approve social posts

---

## Getting Started

See [`docs/setup.md`](docs/setup.md) for the full setup guide.

Quick start:
```bash
# 1. Clone and configure environment
cp .env.example .env
# fill in ANTHROPIC_API_KEY, SUPABASE_URL, SUPABASE_KEY, N8N_WEBHOOK_URL

# 2. Apply database schema
# Run supabase/migrations/001_initial_schema.sql in Supabase SQL editor

# 3. Deploy n8n to Railway
# See docs/setup.md — Railway one-click deploy
```
