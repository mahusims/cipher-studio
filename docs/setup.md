# Setup Guide

## Prerequisites
- Railway account (railway.app)
- Supabase account (supabase.com)
- Anthropic API key
- GitHub account

---

## Step 1: Supabase

1. Create a new project at supabase.com
2. Go to **SQL Editor** and run `supabase/migrations/001_initial_schema.sql`
3. Go to **Settings → API** and copy:
   - `Project URL` → `SUPABASE_URL`
   - `publishable` key → `SUPABASE_PUBLISHABLE_KEY`
   - `secret` key → `SUPABASE_SECRET_KEY`

---

## Step 2: Railway + n8n

1. Go to [railway.app](https://railway.app) and create a new project
2. Click **+ New → Template** and search for **n8n**
3. Deploy — Railway auto-provisions a Postgres instance (we use Supabase instead, but Railway's Postgres manages n8n's own state)
4. Once deployed, open the n8n URL and complete setup:
   - Create owner account
   - Go to **Settings → API** and generate an API key → `N8N_API_KEY`
   - Copy the base URL → `N8N_WEBHOOK_BASE_URL`
5. In Railway environment variables, add:
   - `N8N_ENCRYPTION_KEY` — generate with `openssl rand -hex 32`
   - `WEBHOOK_URL` — your Railway n8n URL

---

## Step 3: Configure Credentials in n8n

In your n8n instance, add the following credentials:

- **HTTP Request → Header Auth**: name=`x-api-key`, value=`ANTHROPIC_API_KEY`
- **Supabase**: URL + service key
- (Phase 3) Etsy OAuth, Payhip API key

---

## Step 4: Import Workflows

1. In n8n, go to **Workflows → Import**
2. Import each JSON file from `n8n/workflows/`
3. Activate the **Research Agent** workflow

---

## Step 5: Verify

- Trigger the Research Agent manually
- Check Supabase `opportunities` table for results
- Check n8n execution logs for errors
