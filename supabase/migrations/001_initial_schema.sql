-- Cipher Studio — Initial Schema
-- Run this in the Supabase SQL editor

-- ─────────────────────────────────────────
-- OPPORTUNITIES
-- Research Agent writes here
-- ─────────────────────────────────────────
create table if not exists opportunities (
  id            uuid primary key default gen_random_uuid(),
  created_at    timestamptz default now(),

  title         text not null,
  niche         text,
  keywords      text[],
  etsy_search   text,              -- the search term that surfaced this
  score         numeric(4,2),      -- 0–10 composite score
  rationale     text,              -- Claude's reasoning
  status        text default 'pending',  -- pending | approved | rejected | created
  reviewed_at   timestamptz,
  notes         text               -- reviewer notes
);

-- ─────────────────────────────────────────
-- PRODUCTS
-- Creation Agent writes here
-- ─────────────────────────────────────────
create table if not exists products (
  id              uuid primary key default gen_random_uuid(),
  created_at      timestamptz default now(),
  opportunity_id  uuid references opportunities(id),

  name            text not null,
  type            text,            -- spreadsheet | notion | document-bundle
  description     text,
  file_url        text,            -- Supabase Storage URL
  thumbnail_url   text,
  status          text default 'draft'  -- draft | listed | paused | archived
);

-- ─────────────────────────────────────────
-- LISTINGS
-- Listing Agent writes here
-- ─────────────────────────────────────────
create table if not exists listings (
  id              uuid primary key default gen_random_uuid(),
  created_at      timestamptz default now(),
  product_id      uuid references products(id),

  platform        text not null,   -- etsy | payhip
  external_id     text,            -- platform's listing ID
  title           text,
  description     text,
  tags            text[],
  price_usd       numeric(8,2),
  status          text default 'draft',  -- draft | published | paused
  published_at    timestamptz,
  url             text
);

-- ─────────────────────────────────────────
-- ORDERS
-- Pulled from Etsy/Payhip APIs
-- ─────────────────────────────────────────
create table if not exists orders (
  id              uuid primary key default gen_random_uuid(),
  created_at      timestamptz default now(),
  listing_id      uuid references listings(id),

  platform        text,
  external_id     text unique,
  amount_usd      numeric(8,2),
  fee_usd         numeric(8,2),
  net_usd         numeric(8,2),
  buyer_country   text,
  ordered_at      timestamptz
);

-- ─────────────────────────────────────────
-- MESSAGES
-- Customer Service Agent reads/writes here
-- ─────────────────────────────────────────
create table if not exists messages (
  id              uuid primary key default gen_random_uuid(),
  created_at      timestamptz default now(),

  platform        text,
  external_id     text unique,
  sender          text,
  subject         text,
  body            text,
  draft_reply     text,
  status          text default 'pending',  -- pending | replied | ignored
  replied_at      timestamptz
);

-- ─────────────────────────────────────────
-- WEEKLY REPORTS
-- Finance Agent writes here
-- ─────────────────────────────────────────
create table if not exists weekly_reports (
  id              uuid primary key default gen_random_uuid(),
  created_at      timestamptz default now(),
  week_start      date not null,
  week_end        date not null,

  total_revenue   numeric(10,2),
  total_orders    integer,
  total_fees      numeric(10,2),
  net_revenue     numeric(10,2),
  top_products    jsonb,           -- [{product_id, name, revenue, orders}]
  summary         text             -- Claude's narrative summary
);
