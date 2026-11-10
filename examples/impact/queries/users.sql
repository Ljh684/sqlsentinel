-- References users.email, whose type changes in the migration plan.
SELECT id, email
FROM users
WHERE id = 42;
