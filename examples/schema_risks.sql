-- users is referenced by orders.user_id.
DELETE FROM users WHERE id = 42;

-- email is protected by a unique index.
ALTER TABLE users DROP COLUMN email;
