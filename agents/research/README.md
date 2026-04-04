# Research Agent

**Trigger:** Daily cron — 6:00 AM  
**Model:** Claude Sonnet (reasoning-heavy)  
**Output:** `opportunities` table in Supabase

## What it does

1. Fetches Etsy search results for target keyword clusters (via Etsy API or scrape)
2. Extracts listing metadata: title, price, review count, review velocity, tags
3. Sends data + system prompt to Claude Sonnet
4. Parses scored opportunity list from Claude's response
5. Writes new opportunities to Supabase (`status = pending`)
6. Skips duplicates (matched by `etsy_search` + `title`)

## n8n Workflow

File: `n8n/workflows/research-agent.json`

Nodes:
1. **Schedule Trigger** — 6:00 AM daily
2. **HTTP Request** — Etsy search for each keyword cluster
3. **Code** — flatten and deduplicate listing data
4. **HTTP Request** — Claude API (Sonnet)
5. **Code** — parse JSON response, validate scores
6. **Supabase** — upsert to `opportunities`

## Keyword Clusters (Seed List)

- freelance invoice tracker
- client onboarding template notion
- small business budget spreadsheet
- freelance contract template
- project proposal template
- business expense tracker google sheets
- social media content calendar notion
- client proposal template canva
- freelancer rate calculator
- business starter kit bundle

## Adding New Keywords

Add to the seed list in the n8n workflow's Code node, or extend `agents/research/keywords.json`.
