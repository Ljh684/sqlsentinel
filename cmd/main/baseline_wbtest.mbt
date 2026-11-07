///|
test "baseline suppresses the same finding after line movement" {
  let original = @lib.scan_sql("DELETE FROM users;")
  let files = [@lib.FileReport::{ path: "db\\cleanup.sql", report: original, }]
  let text = baseline_to_json(files)
  let counts = match parse_baseline(text, "baseline.json") {
    Ok(counts) => counts
    Err(message) => fail(message)
  }
  let shifted = @lib.scan_sql("\n\n\nDELETE FROM users;")
  let filtered = apply_baseline(
    [@lib.FileReport::{ path: "db/cleanup.sql", report: shifted, }],
    counts,
  )
  assert_eq(filtered.1, 1)
  assert_eq(filtered.0[0].report.findings.length(), 0)
  assert_eq(filtered.0[0].report.error_count, 0)
  assert_eq(filtered.0[0].report.baseline_suppressed_count, 1)
  assert_true(filtered.0[0].report.baseline_enabled)
  let rendered = @lib.report_to_json(filtered.0[0].report)
  assert_true(rendered.contains("\"baseline\": true"))
  assert_true(rendered.contains("\"baseline_suppressed\": 1"))
}

///|
test "baseline counts duplicates and still reports new occurrences" {
  let original = @lib.scan_sql("DELETE FROM users;\nDELETE FROM users;")
  let text = baseline_to_json([
    @lib.FileReport::{ path: "db/cleanup.sql", report: original, },
  ])
  let counts = match parse_baseline(text, "baseline.json") {
    Ok(counts) => counts
    Err(message) => fail(message)
  }
  let expanded = @lib.scan_sql(
    "DELETE FROM users;\nDELETE FROM users;\nDELETE FROM users;",
  )
  let filtered = apply_baseline(
    [@lib.FileReport::{ path: "db/cleanup.sql", report: expanded, }],
    counts,
  )
  assert_eq(filtered.1, 2)
  assert_eq(filtered.0[0].report.findings.length(), 1)
  assert_eq(filtered.0[0].report.error_count, 1)
  assert_eq(filtered.0[0].report.suppressed_count, 2)
}

///|
test "baseline parser rejects malformed entries" {
  let text =
    #|{
    #|  "schema_version": "1.0",
    #|  "findings": [
    #|    {"path": "db/cleanup.sql", "rule_id": "SQL001", "evidence": "DELETE FROM users", "count": 0}
    #|  ]
    #|}
  match parse_baseline(text, "baseline.json") {
    Ok(_) => fail("expected invalid count")
    Err(message) =>
      assert_true(message.contains("'count' must be greater than zero"))
  }
}

///|
test "baseline fingerprints distinguish changed literal values" {
  let original = @lib.scan_sql(
    "SELECT id FROM users WHERE name LIKE '%alice%';",
  )
  let text = baseline_to_json([
    @lib.FileReport::{ path: "queries/search.sql", report: original, },
  ])
  let counts = match parse_baseline(text, "baseline.json") {
    Ok(counts) => counts
    Err(message) => fail(message)
  }
  let changed = @lib.scan_sql(
    "SELECT id FROM users WHERE name LIKE '%secret%';",
  )
  let filtered = apply_baseline(
    [@lib.FileReport::{ path: "queries/search.sql", report: changed, }],
    counts,
  )
  assert_eq(filtered.1, 0)
  assert_eq(filtered.0[0].report.findings.length(), 1)
  assert_eq(filtered.0[0].report.findings[0].rule_id, "SQL005")
}

///|
test "baseline filtering preserves severity policy audit" {
  let options = @lib.ScanOptions::new(severity_overrides=[
    @lib.SeverityOverride::{
      rule_id: "SQL008",
      severity: @lib.Severity::Error,
    },
  ])
  let report = @lib.scan_sql_with(
    "ALTER TABLE users ADD COLUMN status TEXT NOT NULL;", options,
  )
  let text = baseline_to_json([
    @lib.FileReport::{ path: "db/add_status.sql", report, },
  ])
  let counts = match parse_baseline(text, "baseline.json") {
    Ok(counts) => counts
    Err(message) => fail(message)
  }
  let filtered = apply_baseline(
    [
      @lib.FileReport::{
        path: "db/add_status.sql",
        report: @lib.scan_sql_with(
          "ALTER TABLE users ADD COLUMN status TEXT NOT NULL;", options,
        ),
      },
    ],
    counts,
  )
  assert_eq(filtered.1, 1)
  assert_eq(filtered.0[0].report.findings.length(), 0)
  assert_eq(filtered.0[0].report.severity_overrides.length(), 1)
  assert_eq(filtered.0[0].report.severity_overrides[0].rule_id, "SQL008")
}
