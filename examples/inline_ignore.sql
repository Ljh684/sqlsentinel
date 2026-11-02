-- The wildcard is intentional for this reviewed compatibility view.
-- sqlsentinel: ignore SQL003
SELECT * FROM legacy_export_view;

-- The next statement is independent and still receives normal checks.
SELECT id, email FROM users ORDER BY id;
