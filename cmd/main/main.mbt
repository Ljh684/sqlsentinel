///|
let usage_text =
  #|SQLSentinel - deterministic SQL safety review
  #|
  #|Usage:
  #|  sqlsentinel [options] <file-or-directory>...
  #|  sqlsentinel --sql "<SQL text>"
  #|
  #|Options:
  #|  -f, --format <text|json|markdown|sarif|github|plan|plan-json|plan-markdown>
  #|                                      Output format (default: text)
  #|      --config <path>                 Read project config (default: .sqlsentinel.json)
  #|      --no-config                     Disable project config discovery
  #|      --fail-on <never|info|warning|error>
  #|                                      Exit non-zero at this severity (default: error)
  #|      --dialect <auto|postgres|mysql|sqlite>
  #|                                      SQL dialect profile (default: auto)
  #|      --schema <path>                 JSON schema for cross-object checks
  #|      --no-schema                     Disable schema from project config
  #|      --baseline <path>               Suppress findings recorded in a baseline
  #|      --write-baseline <path>         Write current findings as a baseline
  #|      --no-baseline                   Disable baseline from project config
  #|      --allow-destructive             Downgrade destructive findings to warnings
  #|      --strict-destructive            Restore destructive findings to errors
  #|      --no-style                      Disable style and portability checks
  #|      --style                         Enable style and portability checks
  #|      --ignore <SQL001,SQL003>        Suppress selected rule IDs
  #|      --severity <SQL008=error,...>   Override rule severities
  #|      --no-severity-overrides         Disable configured severity overrides
  #|      --changed                       Scan SQL changed from --base to the worktree
  #|      --base <git-ref>                Git comparison base (default: HEAD)
  #|      --rules                         Print the rule catalog as Markdown
  #|  -h, --help                          Show this help
  #|  -V, --version                       Show the version
  #|
  #|Exit codes:
  #|  0  Scan completed and no finding reached the fail threshold
  #|  1  At least one finding reached the fail threshold
  #|  2  Invalid arguments or file I/O failure

///|
fn print_error(message : String) -> Unit {
  eprintln("error: \{message}")
}

///|
fn require_value(args : Array[String], index : Int, option : String) -> String {
  if index + 1 >= args.length() {
    print_error("missing value for \{option}")
    @sys.exit(2)
  }
  args[index + 1]
}

///|
fn parse_format(value : String) -> String? {
  match value {
    "text"
    | "json"
    | "markdown"
    | "md"
    | "sarif"
    | "github"
    | "plan"
    | "plan-json"
    | "plan-markdown" => Some(value)
    _ => None
  }
}

///|
fn all_reports_fail(
  files : Array[@lib.FileReport],
  threshold : @lib.FailLevel,
) -> Bool {
  for file in files {
    if file.report.should_fail(threshold) {
      return true
    }
  }
  false
}

///|
fn is_known_rule(rule_id : String) -> Bool {
  for rule in @lib.rule_catalog() {
    if rule.id == rule_id {
      return true
    }
  }
  false
}

///|
fn parse_ignored_rules(value : String) -> Array[String] {
  let parsed = []
  for raw in value.split(",") {
    let rule_id = raw.trim().to_upper().to_owned()
    if rule_id.is_empty() {
      continue
    }
    if !is_known_rule(rule_id) {
      print_error("unknown rule ID '\{rule_id}' in --ignore")
      @sys.exit(2)
    }
    if !parsed.contains(rule_id) {
      parsed.push(rule_id)
    }
  }
  parsed
}

///|
fn parse_severity_overrides(value : String) -> Array[@lib.SeverityOverride] {
  let parsed : Array[@lib.SeverityOverride] = []
  for raw in value.split(",") {
    let entry = raw.trim()
    let (raw_rule, raw_level) = match entry.split_once("=") {
      Some(parts) => parts
      None => {
        print_error("invalid severity override '\{entry}'; expected RULE=LEVEL")
        @sys.exit(2)
        abort("unreachable after invalid severity override")
      }
    }
    let rule_id = raw_rule.trim().to_owned().to_upper()
    if !is_known_rule(rule_id) {
      print_error("unknown rule ID '\{rule_id}' in --severity")
      @sys.exit(2)
    }
    let level = raw_level.trim().to_owned()
    let severity = match @lib.Severity::parse(level) {
      Some(severity) => severity
      None => {
        print_error(
          "invalid severity '\{level}' for \{rule_id}; expected info, warning, or error",
        )
        @sys.exit(2)
        abort("unreachable after invalid severity")
      }
    }
    if parsed.any(policy => policy.rule_id == rule_id) {
      print_error("duplicate rule ID '\{rule_id}' in --severity")
      @sys.exit(2)
    }
    parsed.push({ rule_id, severity, })
  }
  parsed.sort_by((a, b) => a.rule_id.compare(b.rule_id))
  parsed
}

///|
fn main {
  let args = @env.args()
  for arg in args[1:] {
    match arg {
      "-h" | "--help" => {
        println(usage_text)
        @sys.exit(0)
      }
      "-V" | "--version" => {
        println("sqlsentinel 0.9.0")
        @sys.exit(0)
      }
      "--rules" => {
        println(@lib.rule_catalog_markdown())
        @sys.exit(0)
      }
      _ => ()
    }
  }

  let mut config_path = None
  let mut config_disabled = false
  let mut config_scan_index = 1
  while config_scan_index < args.length() {
    match args[config_scan_index] {
      "--config" => {
        config_path = Some(require_value(args, config_scan_index, "--config"))
        config_scan_index = config_scan_index + 1
      }
      "--no-config" => config_disabled = true
      _ => ()
    }
    config_scan_index = config_scan_index + 1
  }
  if config_disabled && config_path is Some(_) {
    print_error("--config cannot be combined with --no-config")
    @sys.exit(2)
  }
  let config = match load_project_config(config_path, config_disabled) {
    Ok(config) => config
    Err(message) => {
      print_error(message)
      @sys.exit(2)
      abort("unreachable after invalid config")
    }
  }

  let files = []
  let mut format = match config.format {
    Some(format) => format
    None => "text"
  }
  let mut fail_level = match config.fail_on {
    Some(level) => level
    None => @lib.FailLevel::Error
  }
  let mut allow_destructive = match config.allow_destructive {
    Some(value) => value
    None => false
  }
  let mut style_checks = match config.style_checks {
    Some(value) => value
    None => true
  }
  let mut dialect = match config.dialect {
    Some(dialect) => dialect
    None => @lib.Dialect::Auto
  }
  let mut schema_path = config.schema
  let mut schema_disabled = false
  let mut baseline_path = config.baseline
  let mut baseline_disabled = false
  let mut cli_baseline_seen = false
  let mut write_baseline_path : String? = None
  let ignored_rules = match config.ignored_rules {
    Some(rules) => rules
    None => []
  }
  let severity_overrides = match config.severity_overrides {
    Some(overrides) => overrides
    None => []
  }
  let mut cli_ignore_seen = false
  let mut cli_severity_seen = false
  let mut inline_sql = None
  let mut changed_mode = false
  let mut git_base = match config.base {
    Some(base) => base
    None => "HEAD"
  }
  let mut index = 1
  while index < args.length() {
    let arg = args[index]
    match arg {
      "-h" | "--help" => {
        println(usage_text)
        @sys.exit(0)
      }
      "-V" | "--version" => {
        println("sqlsentinel 0.9.0")
        @sys.exit(0)
      }
      "--rules" => {
        println(@lib.rule_catalog_markdown())
        @sys.exit(0)
      }
      "--config" => index = index + 1
      "--no-config" => ()
      "-f" | "--format" => {
        let value = require_value(args, index, arg)
        match parse_format(value) {
          Some(parsed) => format = parsed
          None => {
            print_error(
              "unknown format '\{value}'; expected text, json, markdown, sarif, github, plan, plan-json, or plan-markdown",
            )
            @sys.exit(2)
          }
        }
        index = index + 1
      }
      "--fail-on" => {
        let value = require_value(args, index, arg)
        match @lib.FailLevel::parse(value) {
          Some(parsed) => fail_level = parsed
          None => {
            print_error(
              "unknown fail threshold '\{value}'; expected never, info, warning, or error",
            )
            @sys.exit(2)
          }
        }
        index = index + 1
      }
      "--dialect" => {
        let value = require_value(args, index, arg)
        match @lib.Dialect::parse(value.to_lower()) {
          Some(parsed) => dialect = parsed
          None => {
            print_error(
              "unknown dialect '\{value}'; expected auto, postgres, mysql, or sqlite",
            )
            @sys.exit(2)
          }
        }
        index = index + 1
      }
      "--schema" => {
        schema_path = Some(require_value(args, index, arg))
        schema_disabled = false
        index = index + 1
      }
      "--no-schema" => schema_disabled = true
      "--baseline" => {
        baseline_path = Some(require_value(args, index, arg))
        baseline_disabled = false
        cli_baseline_seen = true
        index = index + 1
      }
      "--write-baseline" => {
        write_baseline_path = Some(require_value(args, index, arg))
        baseline_disabled = true
        index = index + 1
      }
      "--no-baseline" => baseline_disabled = true
      "--allow-destructive" => allow_destructive = true
      "--strict-destructive" => allow_destructive = false
      "--no-style" => style_checks = false
      "--style" => style_checks = true
      "--changed" => changed_mode = true
      "--base" => {
        git_base = require_value(args, index, arg)
        changed_mode = true
        index = index + 1
      }
      "--ignore" => {
        let value = require_value(args, index, arg)
        if !cli_ignore_seen {
          ignored_rules.clear()
          cli_ignore_seen = true
        }
        for rule_id in parse_ignored_rules(value) {
          if !ignored_rules.contains(rule_id) {
            ignored_rules.push(rule_id)
          }
        }
        index = index + 1
      }
      "--severity" => {
        let value = require_value(args, index, arg)
        if !cli_severity_seen {
          severity_overrides.clear()
          cli_severity_seen = true
        }
        for policy in parse_severity_overrides(value) {
          if severity_overrides.any(existing => {
              existing.rule_id == policy.rule_id
            }) {
            print_error("duplicate rule ID '\{policy.rule_id}' in --severity")
            @sys.exit(2)
          }
          severity_overrides.push(policy)
        }
        index = index + 1
      }
      "--no-severity-overrides" => {
        severity_overrides.clear()
        cli_severity_seen = true
      }
      "--sql" => {
        inline_sql = Some(require_value(args, index, arg))
        index = index + 1
      }
      _ =>
        if arg.has_prefix("-") {
          print_error("unknown option '\{arg}'")
          @sys.exit(2)
        } else {
          files.push(arg)
        }
    }
    index = index + 1
  }

  if files.is_empty() && inline_sql is None && !changed_mode {
    for path in config.paths {
      files.push(path)
    }
  }
  if changed_mode && (!files.is_empty() || !(inline_sql is None)) {
    print_error("--changed/--base cannot be combined with file or --sql inputs")
    @sys.exit(2)
  }
  if !changed_mode && files.is_empty() && inline_sql is None {
    print_error(
      "no SQL input; pass a file/directory, use --sql, or use --changed",
    )
    eprintln("")
    eprintln(usage_text)
    @sys.exit(2)
  }
  if format == "md" {
    format = "markdown"
  }
  if write_baseline_path is Some(_) && cli_baseline_seen {
    print_error("--baseline cannot be combined with --write-baseline")
    @sys.exit(2)
  }

  let schema = if schema_disabled {
    @lib.SchemaCatalog::empty()
  } else {
    match schema_path {
      Some(path) =>
        match load_schema(path) {
          Ok(schema) => schema
          Err(message) => {
            print_error(message)
            @sys.exit(2)
            abort("unreachable after invalid schema")
          }
        }
      None => @lib.SchemaCatalog::empty()
    }
  }
  let options = @lib.ScanOptions::new(
    allow_destructive~,
    style_checks~,
    ignored_rules~,
    dialect~,
    schema~,
    severity_overrides~,
  )
  let reports = []
  let migration_inputs : Array[@lib.MigrationInput] = []
  let discovery = if changed_mode {
    match discover_changed_inputs(git_base) {
      Ok(result) => result
      Err(message) => {
        print_error(message)
        @sys.exit(2)
        abort("unreachable after failed Git discovery")
      }
    }
  } else {
    discover_inputs(files)
  }
  for message in discovery.errors {
    print_error(message)
  }
  let mut had_io_error = !discovery.errors.is_empty()
  match inline_sql {
    Some(sql) => {
      reports.push(@lib.FileReport::{
        path: "inline.sql",
        report: @lib.scan_sql_with(sql, options),
      })
      migration_inputs.push({ path: "inline.sql", source: sql, })
    }
    None => ()
  }
  for path in discovery.files {
    let mut read_ok = true
    let content = @fs.read_file_to_string(path) catch {
      @fs.IOError(message) => {
        print_error("cannot read \{path}: \{message}")
        had_io_error = true
        read_ok = false
        ""
      }
    }
    if read_ok {
      reports.push(@lib.FileReport::{
        path,
        report: @lib.scan_sql_with(content, options),
      })
      migration_inputs.push({ path, source: content, })
    }
  }
  if had_io_error && reports.is_empty() {
    @sys.exit(2)
  }
  let plan_mode = match format {
    "plan" | "plan-json" | "plan-markdown" => true
    _ => false
  }
  if plan_mode &&
    (
      write_baseline_path is Some(_) ||
      (!baseline_disabled && baseline_path is Some(_))
    ) {
    print_error("baseline options cannot be combined with plan formats")
    @sys.exit(2)
  }
  if plan_mode {
    let analysis = @lib.analyze_migrations(migration_inputs, options)
    let plan_output = match format {
      "plan-json" => @lib.migration_analysis_to_json(analysis)
      "plan-markdown" => @lib.migration_analysis_to_markdown(analysis)
      _ => @lib.migration_analysis_to_text(analysis)
    }
    println(plan_output)
    if had_io_error {
      @sys.exit(2)
    } else if analysis.should_fail(fail_level) {
      @sys.exit(1)
    }
    @sys.exit(0)
  }

  let mut output_reports = reports
  let mut baseline_written = false
  match write_baseline_path {
    Some(path) =>
      if !had_io_error {
        match write_baseline(path, reports) {
          Ok(_) => {
            baseline_written = true
            eprintln("baseline written to \{path}")
          }
          Err(message) => {
            print_error(message)
            @sys.exit(2)
          }
        }
      }
    None =>
      if !baseline_disabled && baseline_path is Some(path) {
        match load_baseline(path) {
          Ok(counts) => {
            let filtered = apply_baseline(reports, counts)
            output_reports = filtered.0
          }
          Err(message) => {
            print_error(message)
            @sys.exit(2)
          }
        }
      }
  }

  let output = match format {
    "json" => @lib.files_to_json(output_reports)
    "markdown" => @lib.files_to_markdown(output_reports)
    "sarif" => @lib.files_to_sarif(output_reports)
    "github" => @lib.files_to_github(output_reports)
    _ => @lib.files_to_text(output_reports)
  }
  println(output)

  if had_io_error {
    @sys.exit(2)
  } else if !baseline_written && all_reports_fail(output_reports, fail_level) {
    @sys.exit(1)
  }
}
