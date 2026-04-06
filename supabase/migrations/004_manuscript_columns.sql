-- Products table — manuscript output columns (added by Content Writer Agent)
ALTER TABLE products
  ADD COLUMN IF NOT EXISTS manuscript_url        TEXT,
  ADD COLUMN IF NOT EXISTS manuscript_word_count INTEGER;
