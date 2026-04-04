-- Cipher Studio — Migration 002
-- Adds spec, pricing, and keyword columns to products table
-- Run this in the Supabase SQL editor before activating the Product Creation Agent

alter table products
  add column if not exists spec              jsonb,
  add column if not exists suggested_price_usd numeric(8,2),
  add column if not exists target_keywords   text[];

-- Index for filtering by status (used by all agents)
create index if not exists products_status_idx on products(status);
create index if not exists products_opportunity_idx on products(opportunity_id);
