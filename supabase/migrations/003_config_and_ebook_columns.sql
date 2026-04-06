-- ─────────────────────────────────────────────────────────────────────────────
-- Config table (key/value store for runtime settings)
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS config (
  key        TEXT PRIMARY KEY,
  value      TEXT,
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Seed the PDF service URL (Docker internal networking)
INSERT INTO config (key, value)
VALUES ('pdf_service_url', 'http://ebook-pdf:3456')
ON CONFLICT (key) DO UPDATE
  SET value      = EXCLUDED.value,
      updated_at = now();

-- Seed the ebook template public URL
INSERT INTO config (key, value)
VALUES ('ebook_template_url', 'https://illcsxpidmluhdwgygwf.supabase.co/storage/v1/object/public/templates/cipher-ebook-v1.html')
ON CONFLICT (key) DO UPDATE
  SET value      = EXCLUDED.value,
      updated_at = now();

-- ─────────────────────────────────────────────────────────────────────────────
-- Products table — ebook output columns
-- ─────────────────────────────────────────────────────────────────────────────
ALTER TABLE products
  ADD COLUMN IF NOT EXISTS ebook_html_url TEXT,
  ADD COLUMN IF NOT EXISTS ebook_pdf_url  TEXT;
