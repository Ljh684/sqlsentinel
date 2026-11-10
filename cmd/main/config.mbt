///|
priv struct ProjectConfig {
  paths : Array[String]
  format : String?
  fail_on : @lib.FailLevel?
  allow_destructive : Bool?
  style_checks : Bool?
  ignored_rules : Array[String]?
  base : String?
  dialect : @lib.Dialect?
  schema : String?
  baseline : String?
  severity_overrides : Array[@lib.SeverityOverride]?
}

///|
fn empty_project_config() -> ProjectConfig {
  {
    paths: [],
    format: None,
    fail_on: None,
    allow_destructive: None,
    style_checks: None,
    ignored_rules: None,
    base: None,
    dialect: None,
    schema: None,
    baseline: None,
    severity_overrides: None,
  }
}

///|
fn config_error(path : String, message : String) -> String {
  "invalid config '\{path}': \{message}"
}

///|
fn config_string_array(
  value : Json,
  field : String,
  path : String,
) -> Result[Array[String], String] {
  match value {
    Json::Array(items) => {
      let result = []
      for item in items {
        match item {
          Json::String(text) =>
            if text.trim().is_empty() {
              return Err(
                config_error(path, "\{field} cannot contain empty strings"),
              )
            } else {
              result.push(text)
            }
          _ =>
            return Err(
              config_error(path, "\{field} must be an array of strings"),
            )
        }
      }
      Ok(result)
    }
    _ => Err(config_error(path, "\{field} must be an array of strings"))
  }
}

///|
fn parse_project_config(
  text : String,
  path : String,
) -> Result[ProjectConfig, String] {
  let parsed = @json.parse(text) catch {
    error => return Err(config_error(path, "JSON parse error: \{error}"))
  }
  let object = match parsed {
    Json::Object(object) => object
    _ => return Err(config_error(path, "top-level value must be an object"))
  }
  let allowed = [
    "paths", "format", "failOn", "allowDestructive", "styleChecks", "ignore", "base",
    "dialect", "schema", "baseline", "severityOverrides",
  ]
  for key, _ in object {
    if !allowed.contains(key) {
      return Err(config_error(path, "unknown field '\{key}'"))
    }
  }

  let mut config = empty_project_config()
  match object.get("paths") {
    Some(value) =>
      match config_string_array(value, "paths", path) {
        Ok(paths) => config = { ..config, paths, }
        Err(message) => return Err(message)
      }
    None => ()
  }
  match object.get("format") {
    Some(Json::String(value)) =>
      match parse_format(value) {
        Some(format) => config = { ..config, format: Some(format), }
        None =>
          return Err(
            config_error(
              path, "format must be text, json, markdown, sarif, github, plan, plan-json, or plan-markdown",
            ),
          )
      }
    Some(_) => return Err(config_error(path, "format must be a string"))
    None => ()
  }
  match object.get("failOn") {
    Some(Json::String(value)) =>
      match @lib.FailLevel::parse(value.to_lower()) {
        Some(level) => config = { ..config, fail_on: Some(level), }
        None =>
          return Err(
            config_error(path, "failOn must be never, info, warning, or error"),
          )
      }
    Some(_) => return Err(config_error(path, "failOn must be a string"))
    None => ()
  }
  match object.get("allowDestructive") {
    Some(Json::True) => config = { ..config, allow_destructive: Some(true), }
    Some(Json::False) => config = { ..config, allow_destructive: Some(false), }
    Some(_) =>
      return Err(config_error(path, "allowDestructive must be a boolean"))
    None => ()
  }
  match object.get("styleChecks") {
    Some(Json::True) => config = { ..config, style_checks: Some(true), }
    Some(Json::False) => config = { ..config, style_checks: Some(false), }
    Some(_) => return Err(config_error(path, "styleChecks must be a boolean"))
    None => ()
  }
  match object.get("ignore") {
    Some(value) =>
      match config_string_array(value, "ignore", path) {
        Ok(raw_rules) => {
          let rules = []
          for raw_rule in raw_rules {
            let rule_id = raw_rule.to_upper()
            if !is_known_rule(rule_id) {
              return Err(config_error(path, "unknown rule ID '\{rule_id}'"))
            }
            if !rules.contains(rule_id) {
              rules.push(rule_id)
            }
          }
          config = { ..config, ignored_rules: Some(rules), }
        }
        Err(message) => return Err(message)
      }
    None => ()
  }
  match object.get("base") {
    Some(Json::String(value)) =>
      if !valid_git_ref(value) {
        return Err(config_error(path, "base must be a valid Git ref or range"))
      } else {
        config = { ..config, base: Some(value), }
      }
    Some(_) => return Err(config_error(path, "base must be a string"))
    None => ()
  }
  match object.get("dialect") {
    Some(Json::String(value)) =>
      match @lib.Dialect::parse(value.to_lower()) {
        Some(dialect) => config = { ..config, dialect: Some(dialect), }
        None =>
          return Err(
            config_error(
              path, "dialect must be auto, postgres, mysql, or sqlite",
            ),
          )
      }
    Some(_) => return Err(config_error(path, "dialect must be a string"))
    None => ()
  }
  match object.get("schema") {
    Some(Json::String(value)) =>
      if value.trim().is_empty() {
        return Err(config_error(path, "schema cannot be empty"))
      } else {
        config = { ..config, schema: Some(value), }
      }
    Some(_) => return Err(config_error(path, "schema must be a string"))
    None => ()
  }
  match object.get("baseline") {
    Some(Json::String(value)) =>
      if value.trim().is_empty() {
        return Err(config_error(path, "baseline cannot be empty"))
      } else {
        config = { ..config, baseline: Some(value), }
      }
    Some(_) => return Err(config_error(path, "baseline must be a string"))
    None => ()
  }
  match object.get("severityOverrides") {
    Some(Json::Object(overrides)) => {
      let parsed : Array[@lib.SeverityOverride] = []
      let rule_ids = []
      for raw_rule, value in overrides {
        let rule_id = raw_rule.to_upper()
        if !is_known_rule(rule_id) {
          return Err(
            config_error(
              path,
              "unknown rule ID '\{rule_id}' in severityOverrides",
            ),
          )
        }
        if rule_ids.contains(rule_id) {
          return Err(
            config_error(
              path,
              "duplicate rule ID '\{rule_id}' in severityOverrides",
            ),
          )
        }
        rule_ids.push(rule_id)
        let severity = match value {
          Json::String(level) =>
            match @lib.Severity::parse(level) {
              Some(severity) => severity
              None =>
                return Err(
                  config_error(
                    path, "severityOverrides values must be info, warning, or error",
                  ),
                )
            }
          _ =>
            return Err(
              config_error(path, "severityOverrides values must be strings"),
            )
        }
        parsed.push({ rule_id, severity, })
      }
      parsed.sort_by((a, b) => a.rule_id.compare(b.rule_id))
      config = { ..config, severity_overrides: Some(parsed), }
    }
    Some(_) =>
      return Err(config_error(path, "severityOverrides must be an object"))
    None => ()
  }
  Ok(config)
}

///|
fn load_project_config(
  explicit_path : String?,
  disabled : Bool,
) -> Result[ProjectConfig, String] {
  if disabled {
    return Ok(empty_project_config())
  }
  let path = match explicit_path {
    Some(path) => path
    None => ".sqlsentinel.json"
  }
  if !@fs.path_exists(path) {
    if explicit_path is Some(_) {
      return Err("config file not found: \{path}")
    }
    return Ok(empty_project_config())
  }
  let text = @fs.read_file_to_string(path) catch {
    @fs.IOError(message) =>
      return Err("cannot read config '\{path}': \{message}")
  }
  match parse_project_config(text, path) {
    Err(message) => Err(message)
    Ok(config) => {
      let base = @path.Path(path).dirname()
      let resolved_paths = []
      for config_path in config.paths {
        if @path.Path(config_path).is_absolute() {
          resolved_paths.push(config_path)
        } else {
          resolved_paths.push(base.join(@path.Path(config_path)).to_string())
        }
      }
      let resolved_schema = match config.schema {
        None => None
        Some(schema_path) =>
          if @path.Path(schema_path).is_absolute() {
            Some(schema_path)
          } else {
            Some(base.join(@path.Path(schema_path)).to_string())
          }
      }
      let resolved_baseline = match config.baseline {
        None => None
        Some(baseline_path) =>
          if @path.Path(baseline_path).is_absolute() {
            Some(baseline_path)
          } else {
            Some(base.join(@path.Path(baseline_path)).to_string())
          }
      }
      Ok({
        ..config,
        paths: resolved_paths,
        schema: resolved_schema,
        baseline: resolved_baseline,
      })
    }
  }
}
