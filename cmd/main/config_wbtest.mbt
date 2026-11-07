///|
test "project config parses supported policy fields" {
  let text =
    #|{
    #|  "paths": ["db", "sql"],
    #|  "format": "json",
    #|  "failOn": "warning",
    #|  "allowDestructive": true,
    #|  "styleChecks": false,
    #|  "ignore": ["sql003", "SQL003", "SQL004"],
    #|  "base": "origin/main...HEAD",
    #|  "dialect": "postgres",
    #|  "schema": "schema.json",
    #|  "baseline": "baseline.json",
    #|  "severityOverrides": {
    #|    "SQL008": "error",
    #|    "sql003": "info"
    #|  }
    #|}
  match parse_project_config(text, "config.json") {
    Ok(config) => {
      assert_eq(config.paths.length(), 2)
      assert_eq(config.format.unwrap(), "json")
      assert_true(config.fail_on == Some(@lib.FailLevel::Warning))
      assert_eq(config.allow_destructive.unwrap(), true)
      assert_eq(config.style_checks.unwrap(), false)
      assert_eq(config.ignored_rules.unwrap().length(), 2)
      assert_eq(config.base.unwrap(), "origin/main...HEAD")
      assert_true(config.dialect == Some(@lib.Dialect::Postgres))
      assert_eq(config.schema.unwrap(), "schema.json")
      assert_eq(config.baseline.unwrap(), "baseline.json")
      let overrides = config.severity_overrides.unwrap()
      assert_eq(overrides.length(), 2)
      assert_eq(overrides[0].rule_id, "SQL003")
      assert_true(overrides[0].severity == @lib.Severity::Info)
      assert_eq(overrides[1].rule_id, "SQL008")
      assert_true(overrides[1].severity == @lib.Severity::Error)
    }
    Err(message) => fail(message)
  }
}

///|
test "project config rejects unknown fields" {
  let text = "{\"pathz\": [\"db\"]}"
  match parse_project_config(text, "config.json") {
    Ok(_) => fail("expected an unknown-field error")
    Err(message) => assert_true(message.contains("unknown field 'pathz'"))
  }
}

///|
test "project config rejects malformed values" {
  let unknown_rule = "{\"ignore\": [\"SQL999\"]}"
  let wrong_type = "{\"styleChecks\": \"yes\"}"
  let wrong_dialect = "{\"dialect\": \"oracle\"}"
  let wrong_baseline = "{\"baseline\": 42}"
  let wrong_severity = "{\"severityOverrides\": {\"SQL008\": \"fatal\"}}"
  let unknown_severity_rule = "{\"severityOverrides\": {\"SQL999\": \"error\"}}"
  match parse_project_config(unknown_rule, "config.json") {
    Ok(_) => fail("expected an unknown-rule error")
    Err(message) => assert_true(message.contains("unknown rule ID 'SQL999'"))
  }
  match parse_project_config(wrong_type, "config.json") {
    Ok(_) => fail("expected a type error")
    Err(message) =>
      assert_true(message.contains("styleChecks must be a boolean"))
  }
  match parse_project_config(wrong_dialect, "config.json") {
    Ok(_) => fail("expected a dialect error")
    Err(message) => assert_true(message.contains("dialect must be auto"))
  }
  match parse_project_config(wrong_baseline, "config.json") {
    Ok(_) => fail("expected a baseline error")
    Err(message) => assert_true(message.contains("baseline must be a string"))
  }
  match parse_project_config(wrong_severity, "config.json") {
    Ok(_) => fail("expected a severity value error")
    Err(message) => assert_true(message.contains("info, warning, or error"))
  }
  match parse_project_config(unknown_severity_rule, "config.json") {
    Ok(_) => fail("expected an unknown severity rule error")
    Err(message) => assert_true(message.contains("unknown rule ID 'SQL999'"))
  }
}

///|
#cfg(target="native")
test "config paths resolve relative to the config file" {
  let root = "_build/config_fixture"
  let config_path = test_join(root, ".sqlsentinel.json")
  @fs.create_dir(root) catch {
    @fs.IOError(_) => ()
  }
  @fs.write_string_to_file(
    config_path, "{\"paths\": [\"db\", \"../shared\"], \"schema\": \"schema.json\", \"baseline\": \".sqlsentinel/baseline.json\"}",
  )
  match load_project_config(Some(config_path), false) {
    Ok(config) => {
      assert_eq(config.paths.length(), 2)
      assert_true(
        config.paths[0].has_suffix("config_fixture\\db") ||
        config.paths[0].has_suffix("config_fixture/db"),
      )
      assert_true(config.paths[1].has_suffix("shared"))
      assert_true(
        config.schema.unwrap().has_suffix("config_fixture\\schema.json") ||
        config.schema.unwrap().has_suffix("config_fixture/schema.json"),
      )
      assert_true(
        config.baseline
        .unwrap()
        .has_suffix("config_fixture\\.sqlsentinel\\baseline.json") ||
        config.baseline
        .unwrap()
        .has_suffix("config_fixture/.sqlsentinel/baseline.json"),
      )
    }
    Err(message) => fail(message)
  }
  @fs.remove_file(config_path)
  @fs.remove_dir(root)
}
