///|
/// Severity assigned to one finding.
pub(all) enum Severity {
  Info
  Warning
  Error
} derive(Eq)

///|
pub extend Severity with Eq::{equal, not_equal}

///|
/// Minimum severity that should fail a CI job.
pub(all) enum FailLevel {
  Never
  Info
  Warning
  Error
} derive(Eq)

///|
pub extend FailLevel with Eq::{equal, not_equal}

///|
/// Policy controls for a scan.
pub(all) struct ScanOptions {
  allow_destructive : Bool
  style_checks : Bool
  ignored_rules : Array[String]
} derive(Eq)

///|
pub extend ScanOptions with Eq::{equal, not_equal}

///|
/// One actionable result from the static analysis.
pub(all) struct Finding {
  rule_id : String
  title : String
  severity : Severity
  message : String
  suggestion : String
  statement_index : Int
  line : Int
  column : Int
  evidence : String
}

///|
/// Result of scanning one SQL source string.
pub(all) struct Report {
  statement_count : Int
  findings : Array[Finding]
  error_count : Int
  warning_count : Int
  info_count : Int
}

///|
/// A report associated with a file path.
pub(all) struct FileReport {
  path : String
  report : Report
}

///|
/// Public documentation for a rule.
pub(all) struct RuleDefinition {
  id : String
  title : String
  severity : Severity
  rationale : String
  remediation : String
}

///|
/// Return a stable three-level severity rank.
pub fn Severity::rank(self : Severity) -> Int {
  match self {
    Info => 1
    Warning => 2
    Error => 3
  }
}

///|
/// Return a lowercase severity label suitable for reports.
pub fn Severity::label(self : Severity) -> String {
  match self {
    Info => "info"
    Warning => "warning"
    Error => "error"
  }
}

///|
/// Return a lowercase fail-policy label.
pub fn FailLevel::label(self : FailLevel) -> String {
  match self {
    Never => "never"
    Info => "info"
    Warning => "warning"
    Error => "error"
  }
}

///|
/// Parse a fail policy from its command-line spelling.
pub fn FailLevel::parse(value : String) -> FailLevel? {
  match value.trim() {
    "never" => Some(Never)
    "info" => Some(Info)
    "warning" => Some(Warning)
    "error" => Some(Error)
    _ => None
  }
}

///|
/// Default policy: block destructive statements and fail on errors.
pub fn ScanOptions::default() -> ScanOptions {
  { allow_destructive: false, style_checks: true, ignored_rules: [], }
}

///|
/// Construct explicit scan options.
pub fn ScanOptions::new(
  allow_destructive? : Bool = false,
  style_checks? : Bool = true,
  ignored_rules? : Array[String] = [],
) -> ScanOptions {
  { allow_destructive, style_checks, ignored_rules, }
}

///|
/// Whether a report contains a finding at or above the selected threshold.
pub fn Report::should_fail(self : Report, threshold : FailLevel) -> Bool {
  match threshold {
    Never => false
    Info => self.info_count + self.warning_count + self.error_count > 0
    Warning => self.warning_count + self.error_count > 0
    Error => self.error_count > 0
  }
}

///|
/// The highest severity present in a report.
pub fn Report::highest_severity(self : Report) -> Severity? {
  if self.error_count > 0 {
    Some(Error)
  } else if self.warning_count > 0 {
    Some(Warning)
  } else if self.info_count > 0 {
    Some(Info)
  } else {
    None
  }
}

///|
/// Return every built-in rule and its rationale.
pub fn rule_catalog() -> Array[RuleDefinition] {
  [
    {
      id: "SQL001",
      title: "Unbounded data mutation",
      severity: Error,
      rationale: "UPDATE or DELETE without a top-level WHERE clause, or with an always-true predicate, can modify every row in a table.",
      remediation: "Add a precise WHERE predicate. For an intentional full-table operation, use an explicit reviewed migration or dedicated maintenance path.",
    },
    {
      id: "SQL002",
      title: "Destructive schema change",
      severity: Error,
      rationale: "DROP TABLE, TRUNCATE, and DROP COLUMN remove or erase data and are difficult to reverse after deployment.",
      remediation: "Back up the affected data, use an expand-and-contract migration, and obtain an explicit destructive-change approval.",
    },
    {
      id: "SQL003",
      title: "Wildcard projection",
      severity: Warning,
      rationale: "SELECT * couples callers to every column and can make schema changes silently break applications.",
      remediation: "List the columns that the caller actually consumes.",
    },
    {
      id: "SQL004",
      title: "Non-deterministic pagination",
      severity: Warning,
      rationale: "LIMIT without ORDER BY gives the database freedom to return a different subset for the same query.",
      remediation: "Add a stable ORDER BY expression, preferably backed by a unique key.",
    },
    {
      id: "SQL005",
      title: "Leading-wildcard LIKE",
      severity: Warning,
      rationale: "A LIKE pattern beginning with % or _ usually prevents an ordinary B-tree index from narrowing the scan.",
      remediation: "Use a prefix pattern where possible, or deliberately adopt a trigram or full-text index.",
    },
    {
      id: "SQL006",
      title: "Comma join",
      severity: Warning,
      rationale: "Comma-separated tables hide the join condition and are easy to turn into an accidental cross join.",
      remediation: "Use explicit JOIN syntax and move the relationship predicate into ON.",
    },
    {
      id: "SQL007",
      title: "INSERT without a column list",
      severity: Warning,
      rationale: "Positional INSERT statements break when a column is inserted, reordered, or generated by a later schema change.",
      remediation: "Name every target column in the INSERT statement.",
    },
    {
      id: "SQL008",
      title: "NOT NULL column without a default",
      severity: Warning,
      rationale: "Adding a required column without a default can fail on existing rows or lock and rewrite a large table.",
      remediation: "Use a staged nullable/defaulted column migration, backfill data, then enforce NOT NULL.",
    },
  ]
}
