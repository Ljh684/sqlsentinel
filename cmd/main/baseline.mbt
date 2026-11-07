///|
priv struct BaselineEntry {
  path : String
  rule_id : String
  evidence : String
  fingerprint : String
  count : Int
}

///|
priv suberror BaselineLoadError {
  BaselineLoadError(String)
}

///|
fn baseline_error(path : String, message : String) -> String {
  "invalid baseline '\{path}': \{message}"
}

///|
fn[T] fail_baseline(
  path : String,
  message : String,
) -> T raise BaselineLoadError {
  raise BaselineLoadError(baseline_error(path, message))
}

///|
fn baseline_normalize(value : String) -> String {
  value.replace_all(old="\\", new="/").trim().to_owned().to_lower()
}

///|
fn baseline_key(
  path : String,
  rule_id : String,
  fingerprint : String,
  evidence : String,
) -> String {
  let identity = if fingerprint.is_empty() {
    baseline_normalize(evidence)
  } else {
    fingerprint
  }
  "\{baseline_normalize(path)}\u001f\{rule_id.to_upper()}\u001f\{identity}"
}

///|
fn compare_baseline_entries(a : BaselineEntry, b : BaselineEntry) -> Int {
  let left = baseline_key(a.path, a.rule_id, a.fingerprint, a.evidence)
  let right = baseline_key(b.path, b.rule_id, b.fingerprint, b.evidence)
  left.compare(right)
}

///|
fn collect_baseline_entries(
  files : Array[@lib.FileReport],
) -> Array[BaselineEntry] {
  let by_key : Map[String, BaselineEntry] = Map([])
  for file in files {
    for finding in file.report.findings {
      let key = baseline_key(
        file.path,
        finding.rule_id,
        finding.fingerprint,
        finding.evidence,
      )
      match by_key.get(key) {
        Some(entry) =>
          by_key[key] = {
            path: entry.path,
            rule_id: entry.rule_id,
            evidence: entry.evidence,
            fingerprint: entry.fingerprint,
            count: entry.count + 1,
          }
        None =>
          by_key[key] = {
            path: file.path.replace_all(old="\\", new="/"),
            rule_id: finding.rule_id,
            evidence: finding.evidence,
            fingerprint: finding.fingerprint,
            count: 1,
          }
      }
    }
  }
  let entries : Array[BaselineEntry] = []
  for _, entry in by_key {
    entries.push(entry)
  }
  entries.sort_by(compare_baseline_entries)
  entries
}

///|
fn baseline_json_string(value : String) -> Json {
  Json::string(value)
}

///|
fn baseline_json_int(value : Int) -> Json {
  Json::number(value.to_double(), repr=value.to_string())
}

///|
fn baseline_json_object(fields : Array[(String, Json)]) -> Json {
  Json::object(Map::from_array(fields))
}

///|
fn baseline_entry_json(entry : BaselineEntry) -> Json {
  baseline_json_object([
    ("path", baseline_json_string(entry.path)),
    ("rule_id", baseline_json_string(entry.rule_id)),
    ("evidence", baseline_json_string(entry.evidence)),
    ("fingerprint", baseline_json_string(entry.fingerprint)),
    ("count", baseline_json_int(entry.count)),
  ])
}

///|
fn baseline_to_json(files : Array[@lib.FileReport]) -> String {
  let entries = collect_baseline_entries(files)
  baseline_json_object([
    ("schema_version", baseline_json_string("1.0")),
    ("tool", baseline_json_string("SQLSentinel baseline")),
    ("findings", Json::array(entries.map(baseline_entry_json))),
  ]).stringify(indent=2)
}

///|
fn baseline_required_string(
  object : Map[String, Json],
  key : String,
  path : String,
) -> String raise BaselineLoadError {
  match object.get(key) {
    Some(Json::String(value)) =>
      if value.trim().is_empty() {
        fail_baseline(path, "'\{key}' cannot be empty")
      } else {
        value
      }
    Some(_) => fail_baseline(path, "'\{key}' must be a string")
    None => fail_baseline(path, "missing required field '\{key}'")
  }
}

///|
fn baseline_required_count(
  object : Map[String, Json],
  path : String,
) -> Int raise BaselineLoadError {
  match object.get("count") {
    Some(Json::Number(value, ..)) => {
      let count = value.to_int()
      if count <= 0 {
        fail_baseline(path, "'count' must be greater than zero")
      } else {
        count
      }
    }
    Some(_) => fail_baseline(path, "'count' must be a number")
    None => fail_baseline(path, "missing required field 'count'")
  }
}

///|
fn parse_baseline(
  text : String,
  path : String,
) -> Result[Map[String, Int], String] {
  let parsed = @json.parse(text) catch {
    error => return Err(baseline_error(path, "JSON parse error: \{error}"))
  }
  try {
    let root = match parsed {
      Json::Object(object) => object
      _ => fail_baseline(path, "top-level value must be an object")
    }
    let version = baseline_required_string(root, "schema_version", path)
    if version != "1.0" {
      fail_baseline(path, "unsupported schema_version '\{version}'")
    }
    let findings = match root.get("findings") {
      Some(Json::Array(items)) => items
      Some(_) => fail_baseline(path, "'findings' must be an array")
      None => fail_baseline(path, "missing required field 'findings'")
    }
    let counts : Map[String, Int] = Map([])
    for value in findings {
      let object = match value {
        Json::Object(object) => object
        _ => fail_baseline(path, "baseline findings must be objects")
      }
      let finding_path = baseline_required_string(object, "path", path)
      let rule_id = baseline_required_string(object, "rule_id", path)
      let evidence = baseline_required_string(object, "evidence", path)
      let fingerprint = match object.get("fingerprint") {
        Some(Json::String(value)) => value
        Some(_) => fail_baseline(path, "'fingerprint' must be a string")
        None => ""
      }
      let count = baseline_required_count(object, path)
      let key = baseline_key(finding_path, rule_id, fingerprint, evidence)
      let merged = match counts.get(key) {
        Some(previous) => previous + count
        None => count
      }
      counts[key] = merged
    }
    Ok(counts)
  } catch {
    BaselineLoadError(message) => Err(message)
  }
}

///|
fn load_baseline(path : String) -> Result[Map[String, Int], String] {
  let text = @fs.read_file_to_string(path) catch {
    @fs.IOError(message) =>
      return Err("cannot read baseline '\{path}': \{message}")
  }
  parse_baseline(text, path)
}

///|
fn write_baseline(
  path : String,
  files : Array[@lib.FileReport],
) -> Result[Unit, String] {
  @fs.write_string_to_file(path, baseline_to_json(files)) catch {
    @fs.IOError(message) =>
      return Err("cannot write baseline '\{path}': \{message}")
  }
  Ok(())
}

///|
fn merge_baseline_suppressions(
  existing : Array[@lib.SuppressedRule],
  matched : Array[@lib.Finding],
) -> Array[@lib.SuppressedRule] {
  let counts : Map[String, Int] = Map([])
  for rule in existing {
    counts.update_or_default(rule.rule_id, rule.count, count => {
      count + rule.count
    })
  }
  for finding in matched {
    counts.update_or_default(finding.rule_id, 1, count => count + 1)
  }
  let merged : Array[@lib.SuppressedRule] = []
  for rule_id, count in counts {
    merged.push({ rule_id, count, })
  }
  merged.sort_by((a, b) => a.rule_id.compare(b.rule_id))
  merged
}

///|
fn apply_baseline(
  files : Array[@lib.FileReport],
  counts : Map[String, Int],
) -> (Array[@lib.FileReport], Int) {
  let remaining : Map[String, Int] = Map([])
  for key, count in counts {
    remaining[key] = count
  }
  let filtered : Array[@lib.FileReport] = []
  let mut total_suppressed = 0
  for file in files {
    let active : Array[@lib.Finding] = []
    let matched : Array[@lib.Finding] = []
    for finding in file.report.findings {
      let key = baseline_key(
        file.path,
        finding.rule_id,
        finding.fingerprint,
        finding.evidence,
      )
      match remaining.get(key) {
        Some(count) if count > 0 => {
          remaining[key] = count - 1
          matched.push(finding)
        }
        _ => active.push(finding)
      }
    }
    let baseline_suppressed = matched.length()
    total_suppressed = total_suppressed + baseline_suppressed
    let report = @lib.Report::from_parts(
      file.report.statement_count,
      active,
      file.report.suppressed_count + baseline_suppressed,
      merge_baseline_suppressions(file.report.suppressions, matched),
      file.report.dialect,
      file.report.schema_enabled,
      baseline_enabled=true,
      baseline_suppressed_count=baseline_suppressed,
      severity_overrides=file.report.severity_overrides,
    )
    filtered.push({ path: file.path, report, })
  }
  (filtered, total_suppressed)
}
