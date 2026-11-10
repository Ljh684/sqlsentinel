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
/// A project-specific severity for one built-in rule.
pub(all) struct SeverityOverride {
  rule_id : String
  severity : Severity
} derive(Eq)

///|
pub extend SeverityOverride with Eq::{equal, not_equal}

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
/// SQL dialect profile used for dialect-sensitive checks.
pub(all) enum Dialect {
  Auto
  Postgres
  Mysql
  Sqlite
} derive(Eq)

///|
pub extend Dialect with Eq::{equal, not_equal}

///|
/// A structural database change discovered across a migration set.
pub(all) enum SchemaChangeKind {
  CreateTable
  DropTable
  AddColumn
  DropColumn
  AlterColumnType
  RenameTable
  RenameColumn
  CreateIndex
  AddForeignKey
} derive(Eq)

///|
pub extend SchemaChangeKind with Eq::{equal, not_equal}

///|
pub(all) struct MigrationInput {
  path : String
  source : String
}

///|
pub(all) struct SchemaChange {
  kind : SchemaChangeKind
  table_name : String
  column_name : String
  detail : String
  path : String
  line : Int
  statement_index : Int
}

///|
pub(all) struct MigrationFinding {
  path : String
  finding : Finding
}

///|
pub(all) struct MigrationAnalysis {
  changes : Array[SchemaChange]
  findings : Array[MigrationFinding]
  tables_before : Array[String]
  tables_after : Array[String]
  affected_tables : Array[String]
  breaking_changes : Int
  error_count : Int
  warning_count : Int
  info_count : Int
}

///|
pub(all) struct QueryReference {
  change_kind : SchemaChangeKind
  table_name : String
  column_name : String
  path : String
  line : Int
  statement_index : Int
  evidence : String
}

///|
pub(all) struct ImpactAnalysis {
  references : Array[QueryReference]
  findings : Array[MigrationFinding]
  impacted_tables : Array[String]
  impacted_files : Array[String]
  error_count : Int
  warning_count : Int
  info_count : Int
}

///|
/// A declared database column.
pub(all) struct SchemaColumn {
  name : String
  nullable : Bool
} derive(Eq)

///|
pub extend SchemaColumn with Eq::{equal, not_equal}

///|
/// A declared index and its ordered columns.
pub(all) struct SchemaIndex {
  name : String
  columns : Array[String]
  unique : Bool
} derive(Eq)

///|
pub extend SchemaIndex with Eq::{equal, not_equal}

///|
/// A declared foreign key relationship.
pub(all) struct SchemaForeignKey {
  name : String
  columns : Array[String]
  references_table : String
  references_columns : Array[String]
} derive(Eq)

///|
pub extend SchemaForeignKey with Eq::{equal, not_equal}

///|
/// A declared table and its review metadata.
pub(all) struct SchemaTable {
  name : String
  columns : Array[SchemaColumn]
  indexes : Array[SchemaIndex]
  foreign_keys : Array[SchemaForeignKey]
} derive(Eq)

///|
pub extend SchemaTable with Eq::{equal, not_equal}

///|
/// A local schema catalog used by schema-aware checks.
pub(all) struct SchemaCatalog {
  tables : Array[SchemaTable]
} derive(Eq)

///|
pub extend SchemaCatalog with Eq::{equal, not_equal}

///|
/// Policy controls for a scan.
pub(all) struct ScanOptions {
  allow_destructive : Bool
  style_checks : Bool
  ignored_rules : Array[String]
  dialect : Dialect
  schema : SchemaCatalog
  severity_overrides : Array[SeverityOverride]
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
  fingerprint : String
}

///|
/// Number of findings suppressed by one rule.
pub(all) struct SuppressedRule {
  rule_id : String
  count : Int
}

///|
/// Result of scanning one SQL source string.
pub(all) struct Report {
  statement_count : Int
  findings : Array[Finding]
  error_count : Int
  warning_count : Int
  info_count : Int
  suppressed_count : Int
  suppressions : Array[SuppressedRule]
  dialect : Dialect
  schema_enabled : Bool
  baseline_enabled : Bool
  baseline_suppressed_count : Int
  severity_overrides : Array[SeverityOverride]
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
/// Parse a rule severity from its command-line spelling.
pub fn Severity::parse(value : String) -> Severity? {
  match value.trim().to_lower() {
    "info" | "note" => Some(Info)
    "warning" | "warn" => Some(Warning)
    "error" => Some(Error)
    _ => None
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
/// Return a stable SQL dialect label.
pub fn Dialect::label(self : Dialect) -> String {
  match self {
    Auto => "auto"
    Postgres => "postgres"
    Mysql => "mysql"
    Sqlite => "sqlite"
  }
}

///|
/// Stable label for a migration-plan change.
pub fn SchemaChangeKind::label(self : SchemaChangeKind) -> String {
  match self {
    CreateTable => "create_table"
    DropTable => "drop_table"
    AddColumn => "add_column"
    DropColumn => "drop_column"
    AlterColumnType => "alter_column_type"
    RenameTable => "rename_table"
    RenameColumn => "rename_column"
    CreateIndex => "create_index"
    AddForeignKey => "add_foreign_key"
  }
}

///|
/// Whether a migration analysis contains a finding at or above a threshold.
pub fn MigrationAnalysis::should_fail(
  self : MigrationAnalysis,
  threshold : FailLevel,
) -> Bool {
  match threshold {
    Never => false
    Info => self.info_count + self.warning_count + self.error_count > 0
    Warning => self.warning_count + self.error_count > 0
    Error => self.error_count > 0
  }
}

///|
/// Whether an impact analysis contains a finding at or above a threshold.
pub fn ImpactAnalysis::should_fail(
  self : ImpactAnalysis,
  threshold : FailLevel,
) -> Bool {
  match threshold {
    Never => false
    Info => self.info_count + self.warning_count + self.error_count > 0
    Warning => self.warning_count + self.error_count > 0
    Error => self.error_count > 0
  }
}

///|
/// Parse a SQL dialect from its command-line spelling.
pub fn Dialect::parse(value : String) -> Dialect? {
  match value.trim() {
    "auto" => Some(Auto)
    "postgres" | "postgresql" | "pg" => Some(Postgres)
    "mysql" => Some(Mysql)
    "sqlite" | "sqlite3" => Some(Sqlite)
    _ => None
  }
}

///|
pub fn SchemaCatalog::empty() -> SchemaCatalog {
  { tables: [], }
}

///|
pub fn SchemaCatalog::find_table(
  self : SchemaCatalog,
  name : String,
) -> SchemaTable? {
  let target = name.to_lower()
  for table in self.tables {
    if table.name.to_lower() == target {
      return Some(table)
    }
  }
  None
}

///|
pub fn SchemaTable::has_column(self : SchemaTable, name : String) -> Bool {
  let target = name.to_lower()
  for column in self.columns {
    if column.name.to_lower() == target {
      return true
    }
  }
  false
}

///|
pub fn SchemaTable::column_is_protected(
  self : SchemaTable,
  name : String,
) -> Bool {
  let target = name.to_lower()
  for index in self.indexes {
    for column in index.columns {
      if column.to_lower() == target {
        return true
      }
    }
  }
  for foreign_key in self.foreign_keys {
    for column in foreign_key.columns {
      if column.to_lower() == target {
        return true
      }
    }
  }
  false
}

///|
/// Whether another table references this column through a foreign key.
pub fn SchemaCatalog::column_is_referenced(
  self : SchemaCatalog,
  table_name : String,
  column_name : String,
) -> Bool {
  let table_key = table_name.to_lower()
  let column_key = column_name.to_lower()
  for table in self.tables {
    for foreign_key in table.foreign_keys {
      if foreign_key.references_table.to_lower() == table_key &&
        foreign_key.references_columns.any(column => {
          column.to_lower() == column_key
        }) {
        return true
      }
    }
  }
  false
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
  {
    allow_destructive: false,
    style_checks: true,
    ignored_rules: [],
    dialect: Auto,
    schema: SchemaCatalog::empty(),
    severity_overrides: [],
  }
}

///|
/// Construct explicit scan options.
pub fn ScanOptions::new(
  allow_destructive? : Bool = false,
  style_checks? : Bool = true,
  ignored_rules? : Array[String] = [],
  dialect? : Dialect = Auto,
  schema? : SchemaCatalog = SchemaCatalog::empty(),
  severity_overrides? : Array[SeverityOverride] = [],
) -> ScanOptions {
  {
    allow_destructive,
    style_checks,
    ignored_rules,
    dialect,
    schema,
    severity_overrides,
  }
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
/// Build a report and derive severity counts from the active findings.
pub fn Report::from_parts(
  statement_count : Int,
  findings : Array[Finding],
  suppressed_count : Int,
  suppressions : Array[SuppressedRule],
  dialect : Dialect,
  schema_enabled : Bool,
  baseline_enabled? : Bool = false,
  baseline_suppressed_count? : Int = 0,
  severity_overrides? : Array[SeverityOverride] = [],
) -> Report {
  let mut error_count = 0
  let mut warning_count = 0
  let mut info_count = 0
  for finding in findings {
    match finding.severity {
      Error => error_count = error_count + 1
      Warning => warning_count = warning_count + 1
      Info => info_count = info_count + 1
    }
  }
  {
    statement_count,
    findings,
    error_count,
    warning_count,
    info_count,
    suppressed_count,
    suppressions,
    dialect,
    schema_enabled,
    baseline_enabled,
    baseline_suppressed_count,
    severity_overrides,
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
    {
      id: "SQL100",
      title: "Invalid SQLSentinel directive",
      severity: Warning,
      rationale: "A malformed or unreachable ignore directive can hide an intended review decision.",
      remediation: "Use `-- sqlsentinel: ignore SQL003,SQL004` immediately before a SQL statement and list known rule IDs.",
    },
    {
      id: "SQL201",
      title: "Destructive operation on referenced table",
      severity: Warning,
      rationale: "Deleting or removing a table that other tables reference through foreign keys can fail or trigger cascading data changes.",
      remediation: "Update dependent rows first, preserve a staged migration path, and review all inbound foreign-key relationships.",
    },
    {
      id: "SQL202",
      title: "Dropping schema-protected column",
      severity: Error,
      rationale: "A column used by an index or foreign key cannot be dropped without also changing or removing that database object.",
      remediation: "Drop dependent indexes and foreign keys in a reviewed order, or keep the column during an expand-and-contract migration.",
    },
    {
      id: "SQL301",
      title: "In-place column type change",
      severity: Warning,
      rationale: "Changing an existing column type can require a table rewrite and break clients that expect the previous width or type.",
      remediation: "Prefer an expand-and-contract migration with a new column, backfill, dual reads/writes, and a later cleanup.",
    },
    {
      id: "SQL302",
      title: "Migration references a missing schema object",
      severity: Error,
      rationale: "An ALTER or foreign-key statement that targets a missing table or column will fail or indicates migration order drift.",
      remediation: "Correct the object name or reorder migrations so prerequisites are applied first.",
    },
    {
      id: "SQL303",
      title: "Foreign key without a supporting index",
      severity: Warning,
      rationale: "A foreign key whose local columns are not the leading columns of an index can make checks and cascades expensive.",
      remediation: "Create an index whose leading columns match the foreign-key columns.",
    },
    {
      id: "SQL304",
      title: "Rename can break dependent callers",
      severity: Warning,
      rationale: "Renaming a table or column can break queries, views, and application code outside the reviewed migration set.",
      remediation: "Use a compatibility window with aliases or dual-write, update callers, and remove the old name later.",
    },
    {
      id: "SQL305",
      title: "Schema change may break downstream query",
      severity: Warning,
      rationale: "A query that references a dropped, renamed, or incompatible table or column can break when the migration is deployed.",
      remediation: "Update the query together with the migration or keep a compatibility window until all callers migrate.",
    },
  ]
}
