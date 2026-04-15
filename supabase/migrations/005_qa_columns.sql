-- Products table — QA tracking columns
ALTER TABLE products
  ADD COLUMN IF NOT EXISTS qa_retry_count INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS qa_score        NUMERIC(4,2);
