///|
priv struct ReviewCounts {
  files : Int
  statements : Int
  errors : Int
  warnings : Int
  infos : Int
  suppressed : Int
}

///|
fn review_counts(
  files : Array[FileReport],
  migration : MigrationAnalysis,
  impact : ImpactAnalysis?,
) -> ReviewCounts {
  let mut statements = 0
  let mut errors = migration.error_count
  let mut warnings = migration.warning_count
  let mut infos = migration.info_count
  let mut suppressed = 0
  for file in files {
    statements = statements + file.report.statement_count
    errors = errors + file.report.error_count
    warnings = warnings + file.report.warning_count
    infos = infos + file.report.info_count
    suppressed = suppressed + file.report.suppressed_count
  }
  match impact {
    Some(impact) => {
      errors = errors + impact.error_count
      warnings = warnings + impact.warning_count
      infos = infos + impact.info_count
    }
    None => ()
  }
  { files: files.length(), statements, errors, warnings, infos, suppressed, }
}

///|
fn review_verdict(counts : ReviewCounts) -> String {
  if counts.errors > 0 {
    "block"
  } else if counts.warnings > 0 {
    "review"
  } else {
    "pass"
  }
}

///|
fn review_file_json(file : FileReport) -> Json {
  json_object([
    ("path", json_string(file.path)),
    ("statements", json_int(file.report.statement_count)),
    ("errors", json_int(file.report.error_count)),
    ("warnings", json_int(file.report.warning_count)),
    ("infos", json_int(file.report.info_count)),
    ("suppressed", json_int(file.report.suppressed_count)),
    ("findings", Json::array(file.report.findings.map(finding_json))),
  ])
}

///|
/// Render a unified review packet as JSON.
pub fn review_packet_to_json(
  files : Array[FileReport],
  migration : MigrationAnalysis,
  impact : ImpactAnalysis?,
) -> String {
  let counts = review_counts(files, migration, impact)
  json_object([
    ("schema_version", json_string("1.0")),
    ("tool", json_string("SQLSentinel review packet")),
    ("verdict", json_string(review_verdict(counts))),
    (
      "summary",
      json_object([
        ("files", json_int(counts.files)),
        ("statements", json_int(counts.statements)),
        ("errors", json_int(counts.errors)),
        ("warnings", json_int(counts.warnings)),
        ("infos", json_int(counts.infos)),
        ("suppressed", json_int(counts.suppressed)),
        ("schema_changes", json_int(migration.changes.length())),
        ("breaking_changes", json_int(migration.breaking_changes)),
        (
          "impacted_query_files",
          json_int(
            match impact {
              Some(analysis) => analysis.impacted_files.length()
              None => 0
            },
          ),
        ),
      ]),
    ),
    ("scan", json_object([("files", Json::array(files.map(review_file_json)))])),
    ("migration", migration_analysis_json(migration)),
    (
      "impact",
      match impact {
        Some(analysis) => impact_analysis_json(analysis)
        None => Json::null()
      },
    ),
  ]).stringify(indent=2)
}

///|
/// Render a unified review packet as Markdown.
pub fn review_packet_to_markdown(
  files : Array[FileReport],
  migration : MigrationAnalysis,
  impact : ImpactAnalysis?,
) -> String {
  let counts = review_counts(files, migration, impact)
  let builder = StringBuilder()
  builder.write_string("# SQLSentinel unified review\n\n")
  builder.write_string(
    "**Verdict: \{review_verdict(counts).to_upper()}** · **\{counts.errors} errors** · **\{counts.warnings} warnings** · **\{counts.infos} info** · **\{counts.suppressed} suppressed**\n\n",
  )
  builder.write_string(
    "Scanned \{counts.statements} statements across \{counts.files} file(s); analyzed \{migration.changes.length()} schema change(s), including \{migration.breaking_changes} breaking change(s).",
  )
  match impact {
    Some(analysis) =>
      builder.write_string(
        " Downstream impact: \{analysis.impacted_files.length()} query file(s) and \{analysis.impacted_tables.length()} table(s).\n\n",
      )
    None => builder.write_string("\n\n")
  }

  builder.write_string("## Statement findings\n\n")
  let statement_findings = []
  for file in files {
    for finding in file.report.findings {
      statement_findings.push((file.path, finding))
    }
  }
  if statement_findings.is_empty() {
    builder.write_string("No statement-level findings.\n\n")
  } else {
    builder.write_string("| File | Rule | Severity | Finding |\n")
    builder.write_string("| --- | --- | --- | --- |\n")
    for entry in statement_findings {
      builder.write_string(
        "| \{entry.0}:\{entry.1.line} | \{entry.1.rule_id} | \{entry.1.severity.label()} | \{markdown_cell(entry.1.title)} |\n",
      )
    }
    builder.write_string("\n")
  }

  builder.write_string("## Migration plan\n\n")
  builder.write_string(
    "Tables **\{migration.tables_before.length()} → \{migration.tables_after.length()}** · **\{migration.changes.length()}** changes · **\{migration.breaking_changes}** breaking\n\n",
  )
  if migration.changes.is_empty() {
    builder.write_string("No DDL schema changes detected.\n\n")
  } else {
    builder.write_string("| Change | Target | Detail | Location |\n")
    builder.write_string("| --- | --- | --- | --- |\n")
    for change in migration.changes {
      let target = if change.column_name.is_empty() {
        change.table_name
      } else {
        "\{change.table_name}.\{change.column_name}"
      }
      builder.write_string(
        "| \{change.kind.label()} | \{target} | \{markdown_cell(change.detail)} | \{change.path}:\{change.line} |\n",
      )
    }
    builder.write_string("\n")
  }

  builder.write_string("## Downstream query impact\n\n")
  match impact {
    None => builder.write_string("No query sources were supplied.\n\n")
    Some(analysis) =>
      if analysis.references.is_empty() {
        builder.write_string(
          "No downstream references matched changed objects.\n\n",
        )
      } else {
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
        builder.write_string("\n")
      }
  }

  builder.write_string("## Suggested actions\n\n")
  let mut actions = 0
  for file in files {
    for finding in file.report.findings {
      builder.write_string("- **\{finding.rule_id}** \{finding.suggestion}\n")
      actions = actions + 1
    }
  }
  for entry in migration.findings {
    builder.write_string(
      "- **\{entry.finding.rule_id}** \{entry.finding.suggestion}\n",
    )
    actions = actions + 1
  }
  match impact {
    Some(analysis) =>
      for entry in analysis.findings {
        builder.write_string(
          "- **\{entry.finding.rule_id}** \{entry.finding.suggestion}\n",
        )
        actions = actions + 1
      }
    None => ()
  }
  if actions == 0 {
    builder.write_string("No remediation required by the current policy.\n")
  }
  builder.to_string()
}

///|
/// Render a unified review packet for terminal output.
pub fn review_packet_to_text(
  files : Array[FileReport],
  migration : MigrationAnalysis,
  impact : ImpactAnalysis?,
) -> String {
  let counts = review_counts(files, migration, impact)
  let builder = StringBuilder()
  builder.write_string("SQLSentinel unified review\n")
  builder.write_string(
    "Verdict: \{review_verdict(counts).to_upper()}  Errors: \{counts.errors}  Warnings: \{counts.warnings}  Schema changes: \{migration.changes.length()}  Breaking: \{migration.breaking_changes}\n",
  )
  builder.write_string(files_to_text(files))
  builder.write_string("\n")
  builder.write_string(migration_analysis_to_text(migration))
  match impact {
    Some(analysis) => {
      builder.write_string("\n")
      builder.write_string(impact_analysis_to_text(analysis))
    }
    None => ()
  }
  builder.to_string()
}
