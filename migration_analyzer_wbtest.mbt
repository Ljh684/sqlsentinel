///|
fn migration_test_schema() -> SchemaCatalog {
  SchemaCatalog::{
    tables: [
      SchemaTable::{
        name: "users",
        columns: [
          SchemaColumn::{ name: "id", nullable: false, },
          SchemaColumn::{ name: "email", nullable: false, },
        ],
        indexes: [
          SchemaIndex::{ name: "users_pk", columns: ["id"], unique: true, },
        ],
        foreign_keys: [],
      },
    ],
  }
}

///|
test "migration plan tracks schema evolution and semantic findings" {
  let source = "CREATE TABLE ledger (id INT PRIMARY KEY, user_id INT);\n" +
    "ALTER TABLE users ALTER COLUMN email SET DATA TYPE VARCHAR(320);\n" +
    "ALTER TABLE ledger ADD CONSTRAINT ledger_users FOREIGN KEY (user_id) REFERENCES users(id);\n" +
    "ALTER TABLE missing ADD COLUMN x INT;"
  let analysis = analyze_migrations(
    [MigrationInput::{ path: "db/001_plan.sql", source, }],
    ScanOptions::new(schema=migration_test_schema()),
  )
  assert_eq(analysis.changes.length(), 3)
  assert_eq(analysis.breaking_changes, 1)
  assert_eq(analysis.error_count, 1)
  assert_eq(analysis.warning_count, 2)
  assert_eq(analysis.findings.length(), 3)
  let ids = analysis.findings.map(entry => entry.finding.rule_id)
  assert_true(ids.contains("SQL301"))
  assert_true(ids.contains("SQL302"))
  assert_true(ids.contains("SQL303"))
  assert_true(analysis.affected_tables.contains("users"))
  assert_true(analysis.affected_tables.contains("ledger"))
  assert_true(analysis.should_fail(FailLevel::Warning))
  assert_false(analysis.should_fail(FailLevel::Never))
}

///|
test "migration plan accepts indexed foreign keys" {
  let source = "CREATE TABLE ledger (id INT PRIMARY KEY, user_id INT);\n" +
    "CREATE INDEX ledger_user_idx ON ledger (user_id);\n" +
    "ALTER TABLE ledger ADD CONSTRAINT ledger_users FOREIGN KEY (user_id) REFERENCES users(id);"
  let analysis = analyze_migrations(
    [MigrationInput::{ path: "db/001_ledger.sql", source, }],
    ScanOptions::new(schema=migration_test_schema()),
  )
  assert_eq(analysis.findings.length(), 0)
  assert_eq(analysis.changes.length(), 3)
  assert_true(analysis.tables_after.contains("ledger"))
}

///|
test "migration plan audits renames across table state" {
  let source = "ALTER TABLE users RENAME COLUMN email TO primary_email;\n" +
    "ALTER TABLE users RENAME TO accounts;"
  let analysis = analyze_migrations(
    [MigrationInput::{ path: "db/002_rename.sql", source, }],
    ScanOptions::new(schema=migration_test_schema()),
  )
  assert_eq(analysis.changes.length(), 2)
  assert_eq(analysis.findings.length(), 2)
  assert_true(analysis.findings.any(entry => entry.finding.rule_id == "SQL304"))
  assert_true(analysis.tables_after.contains("accounts"))
  assert_false(analysis.tables_after.contains("users"))
}
