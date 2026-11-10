///|
fn impact_test_schema() -> SchemaCatalog {
  SchemaCatalog::{
    tables: [
      SchemaTable::{
        name: "users",
        columns: [
          SchemaColumn::{ name: "id", nullable: false, },
          SchemaColumn::{ name: "email", nullable: false, },
        ],
        indexes: [],
        foreign_keys: [],
      },
    ],
  }
}

///|
test "impact analysis cross-references changed objects and queries" {
  let migrations = [
    MigrationInput::{
      path: "db/001_plan.sql",
      source: "CREATE TABLE ledger (id INT, user_id INT);\n" +
      "ALTER TABLE users ALTER COLUMN email SET DATA TYPE VARCHAR(320);\n" +
      "ALTER TABLE ledger RENAME TO postings;",
    },
  ]
  let queries = [
    MigrationInput::{
      path: "queries/users.sql",
      source: "SELECT email FROM users WHERE id = 1;",
    },
    MigrationInput::{
      path: "queries/ledger.sql",
      source: "SELECT id FROM ledger;",
    },
    MigrationInput::{
      path: "queries/safe.sql",
      source: "SELECT id FROM users;",
    },
  ]
  let analysis = analyze_change_impact(
    migrations,
    queries,
    ScanOptions::new(schema=impact_test_schema()),
  )
  assert_eq(analysis.references.length(), 2)
  assert_eq(analysis.findings.length(), 2)
  assert_eq(analysis.warning_count, 2)
  assert_true(analysis.impacted_tables.contains("users"))
  assert_true(analysis.impacted_tables.contains("ledger"))
  assert_true(analysis.impacted_files.contains("queries/users.sql"))
  assert_true(analysis.impacted_files.contains("queries/ledger.sql"))
  assert_true(analysis.should_fail(FailLevel::Warning))
}

///|
test "impact analysis elevates dropped columns to errors" {
  let analysis = analyze_change_impact(
    [
      MigrationInput::{
        path: "db/002_drop.sql",
        source: "ALTER TABLE users DROP COLUMN email;",
      },
    ],
    [
      MigrationInput::{
        path: "queries/login.sql",
        source: "SELECT email FROM users WHERE id = 1;",
      },
    ],
    ScanOptions::new(schema=impact_test_schema()),
  )
  assert_eq(analysis.references.length(), 1)
  assert_eq(analysis.findings.length(), 1)
  assert_eq(analysis.error_count, 1)
  assert_true(analysis.findings[0].finding.rule_id == "SQL305")
  assert_true(analysis.should_fail(FailLevel::Error))
}

///|
test "impact analysis honors SQL305 suppression" {
  let analysis = analyze_change_impact(
    [
      MigrationInput::{
        path: "db/002_drop.sql",
        source: "ALTER TABLE users DROP COLUMN email;",
      },
    ],
    [
      MigrationInput::{
        path: "queries/login.sql",
        source: "SELECT email FROM users WHERE id = 1;",
      },
    ],
    ScanOptions::new(schema=impact_test_schema(), ignored_rules=["SQL305"]),
  )
  assert_eq(analysis.references.length(), 1)
  assert_eq(analysis.findings.length(), 0)
  assert_eq(analysis.error_count, 0)
}
