-- Research directives table (CEO Agent → Research Agent communication)
CREATE TABLE IF NOT EXISTS research_directives (
  id         UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  directive  TEXT        NOT NULL,
  priority   TEXT        DEFAULT 'normal',
  source     TEXT        DEFAULT 'manual',
  status     TEXT        DEFAULT 'active',
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Opportunities table — additional columns for Research Agent v3
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS source               TEXT;
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS evidence             TEXT;
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS competitive_strategy TEXT;
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS bundle_opportunity   TEXT;
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS suggested_price      DECIMAL;
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS score_demand         INTEGER;
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS score_competition_gap INTEGER;
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS score_fit            INTEGER;
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS score_revenue        INTEGER;
ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS description          TEXT;

-- Auto-expire directives past their expiry date
-- Run manually or schedule as a cron job:
-- UPDATE research_directives SET status = 'expired'
--   WHERE expires_at < now() AND status = 'active';
