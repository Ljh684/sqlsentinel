///|
test "safe query has no findings" {
  let report = @sqlsentinel.scan_sql(
    "SELECT id, email FROM users WHERE id = ? ORDER BY id LIMIT 20;",
  )
  assert_eq(report.statement_count, 1)
  assert_eq(report.findings.length(), 0)
  assert_eq(report.suppressed_count, 0)
  assert_false(report.should_fail(@sqlsentinel.FailLevel::Error))
}

///|
test "delete without where is blocking" {
  let report = @sqlsentinel.scan_sql("DELETE FROM users;")
  assert_eq(report.error_count, 1)
  assert_eq(report.findings[0].rule_id, "SQL001")
  assert_true(report.should_fail(@sqlsentinel.FailLevel::Error))
}

///|
test "update with a selective predicate passes" {
  let report = @sqlsentinel.scan_sql(
    "UPDATE users SET active = false WHERE id = 42;",
  )
  assert_eq(report.error_count, 0)
}

///|
test "always true update predicate is rejected" {
  let report = @sqlsentinel.scan_sql(
    "UPDATE users SET active = false WHERE 1 = 1;",
  )
  assert_eq(report.findings[0].rule_id, "SQL001")
  assert_eq(report.error_count, 1)
}

///|
test "destructive ddl is rejected by default" {
  let report = @sqlsentinel.scan_sql(
    "DROP TABLE audit_events; ALTER TABLE users DROP COLUMN legacy_id;",
  )
  assert_eq(report.error_count, 2)
  assert_eq(report.findings[0].rule_id, "SQL002")
  assert_eq(report.findings[1].rule_id, "SQL002")
}

///|
test "destructive statements can be downgraded" {
  let options = @sqlsentinel.ScanOptions::new(allow_destructive=true)
  let report = @sqlsentinel.scan_sql_with(
    "TRUNCATE TABLE sessions; DELETE FROM staging_rows;", options,
  )
  assert_eq(report.error_count, 0)
  assert_eq(report.warning_count, 2)
  assert_false(report.should_fail(@sqlsentinel.FailLevel::Error))
  assert_true(report.should_fail(@sqlsentinel.FailLevel::Warning))
}

///|
test "semicolons and keywords inside literals do not split statements" {
  let report = @sqlsentinel.scan_sql(
    "INSERT INTO notes (body) VALUES ('drop table users; delete from x'); SELECT 1;",
  )
  assert_eq(report.statement_count, 2)
  assert_eq(report.findings.length(), 0)
}

///|
test "comments and dollar quoted bodies are ignored structurally" {
  let report = @sqlsentinel.scan_sql(
    "/* outer /* nested */ comment */\nSELECT $$body; DELETE FROM users$$;",
  )
  assert_eq(report.statement_count, 1)
  assert_eq(report.error_count, 0)
}

///|
test "select star and unstable pagination are reported" {
  let report = @sqlsentinel.scan_sql("SELECT * FROM events LIMIT 10;")
  assert_eq(report.findings.length(), 2)
  assert_eq(report.findings[0].rule_id, "SQL003")
  assert_eq(report.findings[1].rule_id, "SQL004")
}

///|
test "count star is not mistaken for a wildcard projection" {
  let report = @sqlsentinel.scan_sql("SELECT COUNT(*) FROM events;")
  assert_eq(report.findings.length(), 0)
}

///|
test "leading wildcard like is reported" {
  let report = @sqlsentinel.scan_sql(
    "SELECT id FROM users WHERE name LIKE '%bob';",
  )
  assert_eq(report.findings[0].rule_id, "SQL005")
}

///|
test "prefix like is accepted" {
  let report = @sqlsentinel.scan_sql(
    "SELECT id FROM users WHERE name LIKE 'bob%';",
  )
  assert_eq(report.findings.length(), 0)
}

///|
test "comma join is reported" {
  let report = @sqlsentinel.scan_sql(
    "SELECT u.id FROM users AS u, accounts AS a WHERE u.id = a.user_id;",
  )
  assert_eq(report.findings[0].rule_id, "SQL006")
}

///|
test "explicit join is accepted" {
  let report = @sqlsentinel.scan_sql(
    "SELECT u.id FROM users AS u JOIN accounts AS a ON u.id = a.user_id;",
  )
  assert_eq(report.findings.length(), 0)
}

///|
test "insert without columns is reported" {
  let report = @sqlsentinel.scan_sql("INSERT INTO users VALUES (1, 'a');")
  assert_eq(report.findings[0].rule_id, "SQL007")
}

///|
test "insert with columns is accepted" {
  let report = @sqlsentinel.scan_sql(
    "INSERT INTO users (id, name) VALUES (1, 'a');",
  )
  assert_eq(report.findings.length(), 0)
}

///|
test "required added column without default is reported" {
  let report = @sqlsentinel.scan_sql(
    "ALTER TABLE users ADD COLUMN status TEXT NOT NULL;",
  )
  assert_eq(report.findings[0].rule_id, "SQL008")
}

///|
test "required added column with default is accepted" {
  let report = @sqlsentinel.scan_sql(
    "ALTER TABLE users ADD COLUMN status TEXT NOT NULL DEFAULT 'active';",
  )
  assert_eq(report.findings.length(), 0)
}

///|
test "sqlite dialect elevates NOT NULL additions to errors" {
  let options = @sqlsentinel.ScanOptions::new(
    dialect=@sqlsentinel.Dialect::Sqlite,
  )
  let report = @sqlsentinel.scan_sql_with(
    "ALTER TABLE users ADD COLUMN status TEXT NOT NULL;", options,
  )
  assert_true(report.dialect == @sqlsentinel.Dialect::Sqlite)
  assert_true(report.findings[0].severity == @sqlsentinel.Severity::Error)
  assert_eq(report.error_count, 1)
}

///|
test "postgres and mysql dialects differ on ILIKE checks" {
  let sql = "SELECT id FROM users WHERE name ILIKE '%bob';"
  let postgres = @sqlsentinel.scan_sql_with(
    sql,
    @sqlsentinel.ScanOptions::new(dialect=@sqlsentinel.Dialect::Postgres),
  )
  let mysql = @sqlsentinel.scan_sql_with(
    sql,
    @sqlsentinel.ScanOptions::new(dialect=@sqlsentinel.Dialect::Mysql),
  )
  assert_eq(postgres.findings[0].rule_id, "SQL005")
  assert_eq(mysql.findings.length(), 0)
}

///|
test "style checks can be disabled without disabling destructive checks" {
  let options = @sqlsentinel.ScanOptions::new(style_checks=false)
  let report = @sqlsentinel.scan_sql_with(
    "SELECT * FROM accounts LIMIT 10; DELETE FROM accounts;", options,
  )
  assert_eq(report.findings.length(), 1)
  assert_eq(report.findings[0].rule_id, "SQL001")
}

///|
test "selected rules can be suppressed deliberately" {
  let options = @sqlsentinel.ScanOptions::new(ignored_rules=["SQL003", "SQL004"])
  let report = @sqlsentinel.scan_sql_with(
    "SELECT * FROM users LIMIT 10;", options,
  )
  assert_eq(report.findings.length(), 0)
  assert_eq(report.warning_count, 0)
}

///|
test "suppressing one rule leaves other rules active" {
  let options = @sqlsentinel.ScanOptions::new(ignored_rules=["SQL003"])
  let report = @sqlsentinel.scan_sql_with(
    "SELECT * FROM users LIMIT 10;", options,
  )
  assert_eq(report.findings.length(), 1)
  assert_eq(report.findings[0].rule_id, "SQL004")
}

///|
test "suppression audit counts inline and global policy exceptions" {
  let options = @sqlsentinel.ScanOptions::new(ignored_rules=["SQL004"])
  let report = @sqlsentinel.scan_sql_with(
    "-- sqlsentinel: ignore SQL003\nSELECT * FROM users LIMIT 10;", options,
  )
  assert_eq(report.findings.length(), 0)
  assert_eq(report.suppressed_count, 2)
  assert_eq(report.suppressions.length(), 2)
  assert_eq(report.suppressions[0].rule_id, "SQL003")
  assert_eq(report.suppressions[0].count, 1)
  assert_eq(report.suppressions[1].rule_id, "SQL004")
  assert_eq(report.suppressions[1].count, 1)
}

///|
test "inline ignore applies only to the next statement" {
  let report = @sqlsentinel.scan_sql(
    "-- sqlsentinel: ignore SQL003\nSELECT * FROM legacy_view;\nSELECT * FROM users;",
  )
  assert_eq(report.findings.length(), 1)
  assert_eq(report.findings[0].rule_id, "SQL003")
  assert_eq(report.findings[0].statement_index, 2)
}

///|
test "inline ignore accepts multiple rules" {
  let report = @sqlsentinel.scan_sql(
    "-- sqlsentinel: ignore SQL003, SQL004\nSELECT * FROM users LIMIT 10;",
  )
  assert_eq(report.findings.length(), 0)
}

///|
test "consecutive directives combine for one statement" {
  let report = @sqlsentinel.scan_sql(
    "-- sqlsentinel: ignore SQL003\n-- explanation for the reviewed query\n\n-- sqlsentinel: ignore SQL004\nSELECT * FROM users LIMIT 10;",
  )
  assert_eq(report.findings.length(), 0)
}

///|
test "inline ignore supports block comments" {
  let report = @sqlsentinel.scan_sql(
    "/* sqlsentinel: ignore SQL003 */\nSELECT * FROM users;",
  )
  assert_eq(report.findings.length(), 0)
}

///|
test "inline ignore rejects unknown rule ids" {
  let report = @sqlsentinel.scan_sql(
    "-- sqlsentinel: ignore SQL999\nSELECT * FROM users;",
  )
  assert_eq(report.findings.length(), 2)
  assert_eq(report.findings[0].rule_id, "SQL100")
  assert_eq(report.findings[1].rule_id, "SQL003")
  assert_eq(report.findings[0].line, 1)
}

///|
test "inline ignore rejects malformed directives" {
  let report = @sqlsentinel.scan_sql("-- sqlsentinel: ignore\nSELECT 1;")
  assert_eq(report.findings.length(), 1)
  assert_eq(report.findings[0].rule_id, "SQL100")
}

///|
test "inline ignore reports a missing colon" {
  let report = @sqlsentinel.scan_sql("-- sqlsentinel ignore SQL003\nSELECT 1;")
  assert_eq(report.findings.length(), 1)
  assert_eq(report.findings[0].rule_id, "SQL100")
}

///|
test "inline ignore reports a directive without a statement" {
  let report = @sqlsentinel.scan_sql(
    "SELECT 1;\n-- sqlsentinel: ignore SQL003\n",
  )
  assert_eq(report.findings.length(), 1)
  assert_eq(report.findings[0].rule_id, "SQL100")
}

///|
test "directive-like text inside a string is ignored" {
  let report = @sqlsentinel.scan_sql(
    "SELECT '-- sqlsentinel: ignore SQL003', * FROM users;",
  )
  assert_eq(report.findings.length(), 1)
  assert_eq(report.findings[0].rule_id, "SQL003")
}

///|
test "locations track comments and newlines" {
  let report = @sqlsentinel.scan_sql("-- setup\n\nSELECT * FROM users;\n")
  assert_eq(report.findings[0].line, 3)
  assert_eq(report.findings[0].column, 8)
}

///|
test "json renderer contains stable machine fields" {
  let report = @sqlsentinel.scan_sql("DELETE FROM users;")
  let rendered = @sqlsentinel.report_to_json(report)
  assert_true(rendered.contains("\"schema_version\": \"1.0\""))
  assert_true(rendered.contains("\"rule_id\": \"SQL001\""))
  assert_true(rendered.contains("\"severity\": \"error\""))
}

///|
test "markdown renderer includes evidence and remediation" {
  let report = @sqlsentinel.scan_sql("DELETE FROM users;")
  let rendered = @sqlsentinel.report_to_markdown(report)
  assert_true(rendered.contains("SQL001"))
  assert_true(rendered.contains("Suggested action"))
}

///|
test "sarif renderer exposes code scanning locations and rules" {
  let report = @sqlsentinel.scan_sql("DELETE FROM users;")
  let files = [@sqlsentinel.FileReport::{ path: "db/cleanup.sql", report, }]
  let rendered = @sqlsentinel.files_to_sarif(files)
  assert_true(rendered.contains("\"version\": \"2.1.0\""))
  assert_true(rendered.contains("\"ruleId\": \"SQL001\""))
  assert_true(rendered.contains("\"uri\": \"db/cleanup.sql\""))
  assert_true(rendered.contains("\"startLine\": 1"))
}

///|
test "github renderer emits escaped workflow annotations" {
  let report = @sqlsentinel.scan_sql("DELETE FROM users;")
  let files = [@sqlsentinel.FileReport::{ path: "db/cleanup,old.sql", report, }]
  let rendered = @sqlsentinel.files_to_github(files)
  assert_true(
    rendered.contains(
      "::error file=db/cleanup%2Cold.sql,line=1,col=1,title=SQL001 Unbounded data mutation::",
    ),
  )
  assert_true(rendered.contains("SQLSentinel total: 1 file(s)"))
}

///|
test "rule catalog is complete and uniquely identified" {
  let rules = @sqlsentinel.rule_catalog()
  assert_eq(rules.length(), 9)
  let ids = []
  for rule in rules {
    assert_false(ids.contains(rule.id))
    ids.push(rule.id)
  }
}
