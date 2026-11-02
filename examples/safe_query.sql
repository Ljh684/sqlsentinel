-- A normal application query with a bounded, deterministic result.
SELECT id, email, created_at
FROM users
WHERE tenant_id = 42
  AND email LIKE 'alice%'
ORDER BY id
LIMIT 20;
