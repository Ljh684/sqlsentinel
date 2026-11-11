///|
test "unified review packet aggregates scan plan and impact" {
  let migrations = [
    MigrationInput::{
      path: "db/001.sql",
      source: "CREATE TABLE ledger (id INT, user_id INT);\n" +
      "ALTER TABLE users ALTER COLUMN email SET DATA TYPE VARCHAR(320);\n" +
      "ALTER TABLE ledger RENAME TO postings;\n" +
      "ALTER TABLE missing ADD COLUMN note TEXT;",
    },
  ]
  let queries = [
    MigrationInput::{
      path: "queries/users.sql",
      source: "SELECT email FROM users;",
    },
  ]
  let schema = SchemaCatalog::{
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
  let options = ScanOptions::new(schema~)
  let migration = analyze_migrations(migrations, options)
  let impact = analyze_change_impact(migrations, queries, options)
  let report = scan_sql_with(migrations[0].source, options)
  let files = [FileReport::{ path: "db/001.sql", report, }]
  let json = review_packet_to_json(files, migration, Some(impact))
  assert_true(json.contains("\"tool\": \"SQLSentinel review packet\""))
  assert_true(json.contains("\"verdict\": \"block\""))
  assert_true(json.contains("\"schema_changes\": 3"))
  assert_true(json.contains("\"impacted_query_files\": 1"))
  let markdown = review_packet_to_markdown(files, migration, Some(impact))
  assert_true(markdown.contains("# SQLSentinel unified review"))
  assert_true(markdown.contains("## Migration plan"))
  assert_true(markdown.contains("## Downstream query impact"))
  assert_true(markdown.contains("## Suggested actions"))
}
