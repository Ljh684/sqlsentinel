///|
let usage_text =
  #|SQLSentinel - deterministic SQL safety review
  #|
  #|Usage:
  #|  sqlsentinel [options] <file-or-directory>...
  #|  sqlsentinel --sql "<SQL text>"
  #|
  #|Options:
  #|  -f, --format <text|json|markdown|sarif>
  #|                                      Output format (default: text)
  #|      --fail-on <never|info|warning|error>
  #|                                      Exit non-zero at this severity (default: error)
  #|      --allow-destructive             Downgrade destructive findings to warnings
  #|      --no-style                      Disable style and portability checks
  #|      --ignore <SQL001,SQL003>        Suppress selected rule IDs
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
    "text" | "json" | "markdown" | "md" | "sarif" => Some(value)
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
fn main {
  let args = @env.args()
  let files = []
  let mut format = "text"
  let mut fail_level = @lib.FailLevel::Error
  let mut allow_destructive = false
  let mut style_checks = true
  let ignored_rules = []
  let mut inline_sql = None
  let mut changed_mode = false
  let mut git_base = "HEAD"
  let mut index = 1
  while index < args.length() {
    let arg = args[index]
    match arg {
      "-h" | "--help" => {
        println(usage_text)
        @sys.exit(0)
      }
      "-V" | "--version" => {
        println("sqlsentinel 0.1.0")
        @sys.exit(0)
      }
      "--rules" => {
        println(@lib.rule_catalog_markdown())
        @sys.exit(0)
      }
      "-f" | "--format" => {
        let value = require_value(args, index, arg)
        match parse_format(value) {
          Some(parsed) => format = parsed
          None => {
            print_error(
              "unknown format '\{value}'; expected text, json, markdown, or sarif",
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
      "--allow-destructive" => allow_destructive = true
      "--no-style" => style_checks = false
      "--changed" => changed_mode = true
      "--base" => {
        git_base = require_value(args, index, arg)
        changed_mode = true
        index = index + 1
      }
      "--ignore" => {
        let value = require_value(args, index, arg)
        for rule_id in parse_ignored_rules(value) {
          if !ignored_rules.contains(rule_id) {
            ignored_rules.push(rule_id)
          }
        }
        index = index + 1
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

  let options = @lib.ScanOptions::new(
    allow_destructive~,
    style_checks~,
    ignored_rules~,
  )
  let reports = []
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
    Some(sql) =>
      reports.push(@lib.FileReport::{
        path: "inline.sql",
        report: @lib.scan_sql_with(sql, options),
      })
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
    }
  }
  if had_io_error && reports.is_empty() {
    @sys.exit(2)
  }

  let output = match format {
    "json" => @lib.files_to_json(reports)
    "markdown" => @lib.files_to_markdown(reports)
    "sarif" => @lib.files_to_sarif(reports)
    _ => @lib.files_to_text(reports)
  }
  println(output)

  if had_io_error {
    @sys.exit(2)
  } else if all_reports_fail(reports, fail_level) {
    @sys.exit(1)
  }
}
