///|
fn json_string(value : String) -> Json {
  Json::string(value)
}

///|
fn json_int(value : Int) -> Json {
  Json::number(value.to_double(), repr=value.to_string())
}

///|
fn json_object(fields : Array[(String, Json)]) -> Json {
  Json::object(Map::from_array(fields))
}

///|
fn finding_json(finding : Finding) -> Json {
  json_object([
    ("rule_id", json_string(finding.rule_id)),
    ("title", json_string(finding.title)),
    ("severity", json_string(finding.severity.label())),
    ("statement", json_int(finding.statement_index)),
    ("line", json_int(finding.line)),
    ("column", json_int(finding.column)),
    ("message", json_string(finding.message)),
    ("suggestion", json_string(finding.suggestion)),
    ("evidence", json_string(finding.evidence)),
    ("fingerprint", json_string(finding.fingerprint)),
  ])
}

///|
fn suppressed_rule_json(rule : SuppressedRule) -> Json {
  json_object([
    ("rule_id", json_string(rule.rule_id)),
    ("count", json_int(rule.count)),
  ])
}

///|
fn severity_override_json(policy : SeverityOverride) -> Json {
  json_object([
    ("rule_id", json_string(policy.rule_id)),
    ("severity", json_string(policy.severity.label())),
  ])
}

///|
fn report_json(report : Report) -> Json {
  let highest = match report.highest_severity() {
    Some(severity) => json_string(severity.label())
    None => Json::null()
  }
  json_object([
    ("schema_version", json_string("1.0")),
    ("tool", json_string("SQLSentinel")),
    (
      "summary",
      json_object([
        ("statements", json_int(report.statement_count)),
        ("errors", json_int(report.error_count)),
        ("warnings", json_int(report.warning_count)),
        ("infos", json_int(report.info_count)),
        ("suppressed", json_int(report.suppressed_count)),
        ("dialect", json_string(report.dialect.label())),
        ("schema", Json::boolean(report.schema_enabled)),
        ("baseline", Json::boolean(report.baseline_enabled)),
        ("baseline_suppressed", json_int(report.baseline_suppressed_count)),
        ("highest_severity", highest),
        (
          "suppressions",
          Json::array(report.suppressions.map(suppressed_rule_json)),
        ),
        (
          "severity_overrides",
          Json::array(report.severity_overrides.map(severity_override_json)),
        ),
      ]),
    ),
    ("findings", Json::array(report.findings.map(finding_json))),
  ])
}

///|
/// Render a single report as stable, machine-readable JSON.
pub fn report_to_json(report : Report) -> String {
  report_json(report).stringify(indent=2)
}

///|
/// Render one or more file reports as a single JSON document.
pub fn files_to_json(files : Array[FileReport]) -> String {
  let mut statements = 0
  let mut errors = 0
  let mut warnings = 0
  let mut infos = 0
  let mut suppressed = 0
  let mut baseline_suppressed = 0
  let mut baseline_enabled = false
  let severity_overrides : Array[SeverityOverride] = []
  let file_values = []
  for file in files {
    statements = statements + file.report.statement_count
    errors = errors + file.report.error_count
    warnings = warnings + file.report.warning_count
    infos = infos + file.report.info_count
    suppressed = suppressed + file.report.suppressed_count
    baseline_suppressed = baseline_suppressed +
      file.report.baseline_suppressed_count
    baseline_enabled = baseline_enabled || file.report.baseline_enabled
    if severity_overrides.is_empty() {
      for policy in file.report.severity_overrides {
        severity_overrides.push(policy)
      }
    }
    file_values.push(
      json_object([
        ("path", json_string(file.path)),
        ("statements", json_int(file.report.statement_count)),
        ("errors", json_int(file.report.error_count)),
        ("warnings", json_int(file.report.warning_count)),
        ("infos", json_int(file.report.info_count)),
        ("suppressed", json_int(file.report.suppressed_count)),
        ("dialect", json_string(file.report.dialect.label())),
        ("schema", Json::boolean(file.report.schema_enabled)),
        ("baseline", Json::boolean(file.report.baseline_enabled)),
        ("baseline_suppressed", json_int(file.report.baseline_suppressed_count)),
        (
          "suppressions",
          Json::array(file.report.suppressions.map(suppressed_rule_json)),
        ),
        (
          "severity_overrides",
          Json::array(
            file.report.severity_overrides.map(severity_override_json),
          ),
        ),
        ("findings", Json::array(file.report.findings.map(finding_json))),
      ]),
    )
  }
  json_object([
    ("schema_version", json_string("1.0")),
    ("tool", json_string("SQLSentinel")),
    (
      "summary",
      json_object([
        ("files", json_int(files.length())),
        ("statements", json_int(statements)),
        ("errors", json_int(errors)),
        ("warnings", json_int(warnings)),
        ("infos", json_int(infos)),
        ("suppressed", json_int(suppressed)),
        ("baseline", Json::boolean(baseline_enabled)),
        ("baseline_suppressed", json_int(baseline_suppressed)),
        (
          "severity_overrides",
          Json::array(severity_overrides.map(severity_override_json)),
        ),
      ]),
    ),
    ("files", Json::array(file_values)),
  ]).stringify(indent=2)
}

///|
/// Render one report as a compact terminal review.
pub fn report_to_text(report : Report, path? : String = "<sql>") -> String {
  let builder = StringBuilder()
  builder.write_string("SQLSentinel  \{path}\n")
  builder.write_string(
    "Dialect: \{report.dialect.label()}  Schema: \{if report.schema_enabled { "on" } else { "off" }}  Statements: \{report.statement_count}  Errors: \{report.error_count}  Warnings: \{report.warning_count}  Info: \{report.info_count}\n",
  )
  builder.write_string(
    "Baseline: \{if report.baseline_enabled { "on" } else { "off" }}  Baseline suppressed: \{report.baseline_suppressed_count}\n",
  )
  if !report.severity_overrides.is_empty() {
    builder.write_string("Overrides:")
    for policy in report.severity_overrides {
      builder.write_string("  \{policy.rule_id}=\{policy.severity.label()}")
    }
    builder.write_string("\n")
  }
  if report.suppressed_count > 0 {
    builder.write_string("Suppressed: \{report.suppressed_count} finding(s)")
    for rule in report.suppressions {
      builder.write_string("  \{rule.rule_id} x\{rule.count}")
    }
    builder.write_string("\n")
  }
  if report.findings.is_empty() {
    if report.suppressed_count > 0 {
      builder.write_string("PASS  No unsuppressed policy findings.\n")
    } else {
      builder.write_string("PASS  No policy findings.\n")
    }
  } else {
    for finding in report.findings {
      builder.write_string(
        "\n\{path}:\{finding.line}:\{finding.column}  \{finding.severity.label().to_upper()}  \{finding.rule_id}  \{finding.title}\n",
      )
      builder.write_string("  \{finding.message}\n")
      builder.write_string("  Evidence: \{finding.evidence}\n")
      builder.write_string("  Fix: \{finding.suggestion}\n")
    }
  }
  builder.to_string()
}

///|
fn markdown_cell(value : String) -> String {
  value.replace_all(old="|", new="\\|").replace_all(old="\n", new=" ")
}

///|
/// Render one report as a Markdown review packet suitable for a pull request
/// comment or an AI code-review prompt.
pub fn report_to_markdown(report : Report, path? : String = "<sql>") -> String {
  let builder = StringBuilder()
  builder.write_string("# SQLSentinel review: \{path}\n\n")
  builder.write_string(
    "Dialect: `\{report.dialect.label()}` · Schema: `\{if report.schema_enabled { "enabled" } else { "disabled" }}` · Baseline: `\{if report.baseline_enabled { "enabled" } else { "disabled" }}` with **\{report.baseline_suppressed_count}** baseline suppression(s). Scanned **\{report.statement_count}** statements and found **\{report.error_count} errors**, **\{report.warning_count} warnings**, and **\{report.info_count} info** findings.\n\n",
  )
  if report.suppressed_count > 0 {
    builder.write_string(
      "**Suppressed:** \{report.suppressed_count} finding(s) -",
    )
    for rule in report.suppressions {
      builder.write_string(" `\{rule.rule_id}` x\{rule.count}")
    }
    builder.write_string("\n\n")
  }
  if !report.severity_overrides.is_empty() {
    builder.write_string("**Policy overrides:**")
    for policy in report.severity_overrides {
      builder.write_string(" `\{policy.rule_id}=\{policy.severity.label()}`")
    }
    builder.write_string("\n\n")
  }
  if report.findings.is_empty() {
    if report.suppressed_count > 0 {
      builder.write_string(
        "No unsuppressed policy findings. The SQL passed this review.\n",
      )
    } else {
      builder.write_string("No policy findings. The SQL passed this review.\n")
    }
    return builder.to_string()
  }
  builder.write_string("| Location | Severity | Rule | Finding |\n")
  builder.write_string("| --- | --- | --- | --- |\n")
  for finding in report.findings {
    builder.write_string(
      "| L\{finding.line}:\{finding.column} | \{finding.severity.label()} | \{finding.rule_id} | \{markdown_cell(finding.title)} |\n",
    )
  }
  builder.write_string("\n## Review details\n")
  for finding in report.findings {
    builder.write_string("\n### \{finding.rule_id} · \{finding.title}\n\n")
    builder.write_string(
      "- **Location:** statement \{finding.statement_index}, line \{finding.line}, column \{finding.column}\n",
    )
    builder.write_string("- **Risk:** \{finding.message}\n")
    builder.write_string(
      "- **Evidence:** `\{finding.evidence.replace_all(old="`", new="'")}`\n",
    )
    builder.write_string("- **Suggested action:** \{finding.suggestion}\n")
  }
  builder.to_string()
}

///|
fn github_escape_data(value : String) -> String {
  value
  .replace_all(old="%", new="%25")
  .replace_all(old="\r", new="%0D")
  .replace_all(old="\n", new="%0A")
}

///|
fn github_escape_property(value : String) -> String {
  github_escape_data(value)
  .replace_all(old=":", new="%3A")
  .replace_all(old=",", new="%2C")
}

///|
fn github_annotation_level(severity : Severity) -> String {
  match severity {
    Error => "error"
    Warning => "warning"
    Info => "notice"
  }
}

///|
/// Render one report as GitHub Actions workflow annotations.
pub fn report_to_github(report : Report, path? : String = "<sql>") -> String {
  let builder = StringBuilder()
  let github_path = path.replace_all(old="\\", new="/")
  for finding in report.findings {
    let title = github_escape_property("\{finding.rule_id} \{finding.title}")
    let message = github_escape_data(
      "\{finding.message} Evidence: \{finding.evidence} Fix: \{finding.suggestion}",
    )
    builder.write_string(
      "::\{github_annotation_level(finding.severity)} file=\{github_escape_property(github_path)},line=\{finding.line},col=\{finding.column},title=\{title}::\{message}\n",
    )
  }
  builder.write_string(
    "SQLSentinel [\{report.dialect.label()}]: \{report.statement_count} statement(s), \{report.error_count} error(s), \{report.warning_count} warning(s), \{report.info_count} info finding(s), \{report.suppressed_count} suppressed (\{report.baseline_suppressed_count} baseline), schema \{if report.schema_enabled { "on" } else { "off" }}, baseline \{if report.baseline_enabled { "on" } else { "off" }}.\n",
  )
  if !report.severity_overrides.is_empty() {
    builder.write_string("SQLSentinel policy overrides:")
    for policy in report.severity_overrides {
      builder.write_string(" \{policy.rule_id}=\{policy.severity.label()}")
    }
    builder.write_string("\n")
  }
  builder.to_string()
}

///|
/// Render file reports as GitHub Actions workflow annotations.
pub fn files_to_github(files : Array[FileReport]) -> String {
  let builder = StringBuilder()
  let mut statements = 0
  let mut errors = 0
  let mut warnings = 0
  let mut infos = 0
  let mut suppressed = 0
  let mut baseline_suppressed = 0
  let mut baseline_enabled = false
  for file in files {
    builder.write_string(report_to_github(file.report, path=file.path))
    statements = statements + file.report.statement_count
    errors = errors + file.report.error_count
    warnings = warnings + file.report.warning_count
    infos = infos + file.report.info_count
    suppressed = suppressed + file.report.suppressed_count
    baseline_suppressed = baseline_suppressed +
      file.report.baseline_suppressed_count
    baseline_enabled = baseline_enabled || file.report.baseline_enabled
  }
  builder.write_string(
    "SQLSentinel total: \{files.length()} file(s), \{statements} statement(s), \{errors} error(s), \{warnings} warning(s), \{infos} info finding(s), \{suppressed} suppressed (\{baseline_suppressed} baseline), baseline \{if baseline_enabled { "on" } else { "off" }}.\n",
  )
  builder.to_string()
}

///|
/// Render multiple reports as a Markdown document.
pub fn files_to_markdown(files : Array[FileReport]) -> String {
  let builder = StringBuilder()
  builder.write_string("# SQLSentinel report\n\n")
  if files.is_empty() {
    builder.write_string("No SQL files were scanned.\n")
    return builder.to_string()
  }
  for file in files {
    builder.write_string("\n---\n\n")
    builder.write_string(report_to_markdown(file.report, path=file.path))
  }
  builder.to_string()
}

///|
fn sarif_level(severity : Severity) -> String {
  match severity {
    Error => "error"
    Warning => "warning"
    Info => "note"
  }
}

///|
fn sarif_rule_json(rule : RuleDefinition) -> Json {
  json_object([
    ("id", json_string(rule.id)),
    ("name", json_string(rule.title)),
    ("shortDescription", json_object([("text", json_string(rule.title))])),
    ("fullDescription", json_object([("text", json_string(rule.rationale))])),
    (
      "help",
      json_object([
        ("text", json_string(rule.remediation)),
        ("markdown", json_string(rule.remediation)),
      ]),
    ),
    (
      "defaultConfiguration",
      json_object([("level", json_string(sarif_level(rule.severity)))]),
    ),
  ])
}

///|
fn sarif_result_json(path : String, finding : Finding) -> Json {
  json_object([
    ("ruleId", json_string(finding.rule_id)),
    ("level", json_string(sarif_level(finding.severity))),
    ("message", json_object([("text", json_string(finding.message))])),
    (
      "locations",
      Json::array([
        json_object([
          (
            "physicalLocation",
            json_object([
              (
                "artifactLocation",
                json_object([
                  ("uri", json_string(path.replace_all(old="\\", new="/"))),
                ]),
              ),
              (
                "region",
                json_object([
                  ("startLine", json_int(finding.line)),
                  ("startColumn", json_int(finding.column)),
                ]),
              ),
            ]),
          ),
        ]),
      ]),
    ),
    (
      "properties",
      json_object([
        ("statement", json_int(finding.statement_index)),
        ("evidence", json_string(finding.evidence)),
        ("fingerprint", json_string(finding.fingerprint)),
        ("suggestion", json_string(finding.suggestion)),
      ]),
    ),
  ])
}

///|
/// Render reports as SARIF 2.1.0 for GitHub code scanning and other
/// Static Analysis Results Interchange Format consumers.
pub fn files_to_sarif(files : Array[FileReport]) -> String {
  let results = []
  let mut suppressed = 0
  let mut dialect = "auto"
  let mut schema_enabled = false
  let mut baseline_suppressed = 0
  let mut baseline_enabled = false
  let severity_overrides : Array[SeverityOverride] = []
  for file in files {
    suppressed = suppressed + file.report.suppressed_count
    baseline_suppressed = baseline_suppressed +
      file.report.baseline_suppressed_count
    dialect = file.report.dialect.label()
    schema_enabled = schema_enabled || file.report.schema_enabled
    baseline_enabled = baseline_enabled || file.report.baseline_enabled
    if severity_overrides.is_empty() {
      for policy in file.report.severity_overrides {
        severity_overrides.push(policy)
      }
    }
    for finding in file.report.findings {
      results.push(sarif_result_json(file.path, finding))
    }
  }
  json_object([
    ("$schema", json_string("https://json.schemastore.org/sarif-2.1.0.json")),
    ("version", json_string("2.1.0")),
    (
      "runs",
      Json::array([
        json_object([
          (
            "tool",
            json_object([
              (
                "driver",
                json_object([
                  ("name", json_string("SQLSentinel")),
                  ("version", json_string("0.10.0")),
                  (
                    "informationUri",
                    json_string(
                      "https://mooncakes.io/docs/#/Ljh684/sqlsentinel",
                    ),
                  ),
                  ("rules", Json::array(rule_catalog().map(sarif_rule_json))),
                ]),
              ),
            ]),
          ),
          ("results", Json::array(results)),
          (
            "properties",
            json_object([
              ("suppressed", json_int(suppressed)),
              ("dialect", json_string(dialect)),
              ("schema", Json::boolean(schema_enabled)),
              ("baseline", Json::boolean(baseline_enabled)),
              ("baseline_suppressed", json_int(baseline_suppressed)),
              (
                "severity_overrides",
                Json::array(severity_overrides.map(severity_override_json)),
              ),
            ]),
          ),
        ]),
      ]),
    ),
  ]).stringify(indent=2)
}

///|
/// Render multiple reports as compact terminal output.
pub fn files_to_text(files : Array[FileReport]) -> String {
  let builder = StringBuilder()
  let mut statements = 0
  let mut errors = 0
  let mut warnings = 0
  let mut infos = 0
  let mut suppressed = 0
  let mut baseline_suppressed = 0
  let mut baseline_enabled = false
  for file in files {
    builder.write_string(report_to_text(file.report, path=file.path))
    builder.write_string("\n")
    statements = statements + file.report.statement_count
    errors = errors + file.report.error_count
    warnings = warnings + file.report.warning_count
    infos = infos + file.report.info_count
    suppressed = suppressed + file.report.suppressed_count
    baseline_suppressed = baseline_suppressed +
      file.report.baseline_suppressed_count
    baseline_enabled = baseline_enabled || file.report.baseline_enabled
  }
  builder.write_string(
    "Overall: \{files.length()} file(s), \{statements} statement(s), \{errors} error(s), \{warnings} warning(s), \{infos} info finding(s), \{suppressed} suppressed (\{baseline_suppressed} baseline), baseline \{if baseline_enabled { "on" } else { "off" }}.\n",
  )
  builder.to_string()
}

///|
fn schema_change_json(change : SchemaChange) -> Json {
  json_object([
    ("kind", json_string(change.kind.label())),
    ("table", json_string(change.table_name)),
    ("column", json_string(change.column_name)),
    ("detail", json_string(change.detail)),
    ("path", json_string(change.path)),
    ("line", json_int(change.line)),
    ("statement", json_int(change.statement_index)),
  ])
}

///|
fn migration_finding_json(entry : MigrationFinding) -> Json {
  let finding = entry.finding
  json_object([
    ("path", json_string(entry.path)),
    ("rule_id", json_string(finding.rule_id)),
    ("title", json_string(finding.title)),
    ("severity", json_string(finding.severity.label())),
    ("statement", json_int(finding.statement_index)),
    ("line", json_int(finding.line)),
    ("column", json_int(finding.column)),
    ("message", json_string(finding.message)),
    ("suggestion", json_string(finding.suggestion)),
    ("evidence", json_string(finding.evidence)),
    ("fingerprint", json_string(finding.fingerprint)),
  ])
}

///|
/// Render a project-level migration analysis as stable JSON.
pub fn migration_analysis_to_json(analysis : MigrationAnalysis) -> String {
  json_object([
    ("schema_version", json_string("1.0")),
    ("tool", json_string("SQLSentinel migration plan")),
    (
      "summary",
      json_object([
        ("tables_before", json_int(analysis.tables_before.length())),
        ("tables_after", json_int(analysis.tables_after.length())),
        ("affected_tables", json_int(analysis.affected_tables.length())),
        ("changes", json_int(analysis.changes.length())),
        ("breaking_changes", json_int(analysis.breaking_changes)),
        ("errors", json_int(analysis.error_count)),
        ("warnings", json_int(analysis.warning_count)),
        ("infos", json_int(analysis.info_count)),
      ]),
    ),
    (
      "tables",
      json_object([
        ("before", Json::array(analysis.tables_before.map(json_string))),
        ("after", Json::array(analysis.tables_after.map(json_string))),
        ("affected", Json::array(analysis.affected_tables.map(json_string))),
      ]),
    ),
    ("changes", Json::array(analysis.changes.map(schema_change_json))),
    ("findings", Json::array(analysis.findings.map(migration_finding_json))),
  ]).stringify(indent=2)
}

///|
/// Render a migration analysis for terminal review.
pub fn migration_analysis_to_text(analysis : MigrationAnalysis) -> String {
  let builder = StringBuilder()
  builder.write_string("SQLSentinel migration plan\n")
  builder.write_string(
    "Tables: \{analysis.tables_before.length()} -> \{analysis.tables_after.length()}  Changes: \{analysis.changes.length()}  Breaking: \{analysis.breaking_changes}  Errors: \{analysis.error_count}  Warnings: \{analysis.warning_count}\n",
  )
  if !analysis.affected_tables.is_empty() {
    builder.write_string(
      "Affected tables: \{analysis.affected_tables.join(", ")}\n",
    )
  }
  for change in analysis.changes {
    let target = if change.column_name.is_empty() {
      change.table_name
    } else {
      "\{change.table_name}.\{change.column_name}"
    }
    builder.write_string(
      "\n\{change.kind.label()}  \{target}  \{change.detail}\n  \{change.path}:\{change.line}\n",
    )
  }
  if analysis.findings.is_empty() {
    builder.write_string("\nPASS  No migration-plan findings.\n")
  } else {
    for entry in analysis.findings {
      let finding = entry.finding
      builder.write_string(
        "\n\{entry.path}:\{finding.line}:\{finding.column}  \{finding.severity.label().to_upper()}  \{finding.rule_id}  \{finding.title}\n  \{finding.message}\n  Fix: \{finding.suggestion}\n",
      )
    }
  }
  builder.to_string()
}

///|
/// Render a migration analysis as a Markdown review document.
pub fn migration_analysis_to_markdown(analysis : MigrationAnalysis) -> String {
  let builder = StringBuilder()
  builder.write_string("# SQLSentinel migration plan\n\n")
  builder.write_string(
    "Tables: **\{analysis.tables_before.length()} -> \{analysis.tables_after.length()}** · Changes: **\{analysis.changes.length()}** · Breaking: **\{analysis.breaking_changes}** · Errors: **\{analysis.error_count}** · Warnings: **\{analysis.warning_count}**\n\n",
  )
  if !analysis.affected_tables.is_empty() {
    builder.write_string(
      "Affected tables: \{analysis.affected_tables.map(table => "`\{table}`").join(", ")}\n\n",
    )
  }
  builder.write_string("## Schema changes\n\n")
  builder.write_string("| Kind | Target | Detail | Location |\n")
  builder.write_string("| --- | --- | --- | --- |\n")
  for change in analysis.changes {
    let target = if change.column_name.is_empty() {
      change.table_name
    } else {
      "\{change.table_name}.\{change.column_name}"
    }
    builder.write_string(
      "| \{change.kind.label()} | \{target} | \{markdown_cell(change.detail)} | \{change.path}:\{change.line} |\n",
    )
  }
  builder.write_string("\n## Findings\n\n")
  if analysis.findings.is_empty() {
    builder.write_string("No migration-plan findings.\n")
  } else {
    for entry in analysis.findings {
      let finding = entry.finding
      builder.write_string(
        "### \{finding.rule_id} · \{finding.title}\n\n- **Location:** \{entry.path}:\{finding.line}:\{finding.column}\n- **Risk:** \{finding.message}\n- **Evidence:** `\{finding.evidence.replace_all(old="`", new="'")}`\n- **Suggested action:** \{finding.suggestion}\n\n",
      )
    }
  }
  builder.to_string()
}

///|
fn query_reference_json(reference : QueryReference) -> Json {
  json_object([
    ("change_kind", json_string(reference.change_kind.label())),
    ("table", json_string(reference.table_name)),
    ("column", json_string(reference.column_name)),
    ("path", json_string(reference.path)),
    ("line", json_int(reference.line)),
    ("statement", json_int(reference.statement_index)),
    ("evidence", json_string(reference.evidence)),
  ])
}

///|
/// Render cross-migration query impact as stable JSON.
pub fn impact_analysis_to_json(analysis : ImpactAnalysis) -> String {
  json_object([
    ("schema_version", json_string("1.0")),
    ("tool", json_string("SQLSentinel impact analysis")),
    (
      "summary",
      json_object([
        ("references", json_int(analysis.references.length())),
        ("impacted_tables", json_int(analysis.impacted_tables.length())),
        ("impacted_files", json_int(analysis.impacted_files.length())),
        ("errors", json_int(analysis.error_count)),
        ("warnings", json_int(analysis.warning_count)),
        ("infos", json_int(analysis.info_count)),
      ]),
    ),
    (
      "impacted",
      json_object([
        ("tables", Json::array(analysis.impacted_tables.map(json_string))),
        ("files", Json::array(analysis.impacted_files.map(json_string))),
      ]),
    ),
    ("references", Json::array(analysis.references.map(query_reference_json))),
    ("findings", Json::array(analysis.findings.map(migration_finding_json))),
  ]).stringify(indent=2)
}

///|
/// Render query impact for terminal review.
pub fn impact_analysis_to_text(analysis : ImpactAnalysis) -> String {
  let builder = StringBuilder()
  builder.write_string("SQLSentinel impact analysis\n")
  builder.write_string(
    "References: \{analysis.references.length()}  Impacted tables: \{analysis.impacted_tables.length()}  Impacted files: \{analysis.impacted_files.length()}  Errors: \{analysis.error_count}  Warnings: \{analysis.warning_count}\n",
  )
  if !analysis.impacted_tables.is_empty() {
    builder.write_string("Tables: \{analysis.impacted_tables.join(", ")}\n")
  }
  for reference in analysis.references {
    let target = if reference.column_name.is_empty() {
      reference.table_name
    } else {
      "\{reference.table_name}.\{reference.column_name}"
    }
    builder.write_string(
      "\n\{reference.path}:\{reference.line}  \{reference.change_kind.label()}  \{target}\n  \{reference.evidence}\n",
    )
  }
  if analysis.findings.is_empty() {
    builder.write_string("\nPASS  No downstream query impact found.\n")
  } else {
    for entry in analysis.findings {
      let finding = entry.finding
      builder.write_string(
        "\n\{entry.path}:\{finding.line}:\{finding.column}  \{finding.severity.label().to_upper()}  \{finding.rule_id}  \{finding.message}\n",
      )
    }
  }
  builder.to_string()
}

///|
/// Render query impact as Markdown.
pub fn impact_analysis_to_markdown(analysis : ImpactAnalysis) -> String {
  let builder = StringBuilder()
  builder.write_string("# SQLSentinel change impact\n\n")
  builder.write_string(
    "References: **\{analysis.references.length()}** · Impacted tables: **\{analysis.impacted_tables.length()}** · Impacted files: **\{analysis.impacted_files.length()}** · Errors: **\{analysis.error_count}** · Warnings: **\{analysis.warning_count}**\n\n",
  )
  if !analysis.impacted_tables.is_empty() {
    builder.write_string(
      "Impacted tables: \{analysis.impacted_tables.map(table => "`\{table}`").join(", ")}\n\n",
    )
  }
  builder.write_string("| Query | Change | Target | Evidence |\n")
  builder.write_string("| --- | --- | --- | --- |\n")
  for reference in analysis.references {
    let target = if reference.column_name.is_empty() {
      reference.table_name
    } else {
      "\{reference.table_name}.\{reference.column_name}"
    }
    builder.write_string(
      "| \{reference.path}:\{reference.line} | \{reference.change_kind.label()} | \{target} | `\{reference.evidence.replace_all(old="`", new="'")}` |\n",
    )
  }
  builder.write_string("\n## Findings\n\n")
  if analysis.findings.is_empty() {
    builder.write_string("No downstream query impact found.\n")
  } else {
    for entry in analysis.findings {
      let finding = entry.finding
      builder.write_string(
        "- **\{finding.severity.label()} \{finding.rule_id}** \{entry.path}:\{finding.line} — \{finding.message}\n",
      )
    }
  }
  builder.to_string()
}

///|
/// Render the rule catalog as a Markdown reference.
pub fn rule_catalog_markdown() -> String {
  let builder = StringBuilder()
  builder.write_string("# SQLSentinel rules\n\n")
  builder.write_string(
    "| ID | Default severity | Rule | Rationale | Remediation |\n",
  )
  builder.write_string("| --- | --- | --- | --- | --- |\n")
  for rule in rule_catalog() {
    builder.write_string(
      "| \{rule.id} | \{rule.severity.label()} | \{markdown_cell(rule.title)} | \{markdown_cell(rule.rationale)} | \{markdown_cell(rule.remediation)} |\n",
    )
  }
  builder.to_string()
}
