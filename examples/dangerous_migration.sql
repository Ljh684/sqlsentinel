-- This file intentionally contains review failures for the CI demo.
ALTER TABLE users
  ADD COLUMN risk_level INTEGER NOT NULL;

UPDATE users
SET risk_level = 0;

INSERT INTO audit_events
VALUES (now(), 'migration');

DROP TABLE legacy_sessions;
