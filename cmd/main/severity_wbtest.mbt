///|
test "CLI severity parser normalizes and sorts overrides" {
  let overrides = parse_severity_overrides("SQL008=error,sql003=info")
  assert_eq(overrides.length(), 2)
  assert_eq(overrides[0].rule_id, "SQL003")
  assert_true(overrides[0].severity == @lib.Severity::Info)
  assert_eq(overrides[1].rule_id, "SQL008")
  assert_true(overrides[1].severity == @lib.Severity::Error)
}
