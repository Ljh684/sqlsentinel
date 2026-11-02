-- Expand phase: add a nullable column first so existing rows remain valid.
ALTER TABLE users
  ADD COLUMN retention_score INTEGER NULL;

-- Backfill in bounded batches from the application job.
UPDATE users
SET retention_score = 0
WHERE retention_score IS NULL;
