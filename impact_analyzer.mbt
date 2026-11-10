///|
fn impact_change_is_relevant(kind : SchemaChangeKind) -> Bool {
  match kind {
    DropTable | DropColumn | AlterColumnType | RenameTable | RenameColumn =>
      true
    _ => false
  }
}

///|
fn impact_default_severity(kind : SchemaChangeKind) -> Severity {
  match kind {
    DropTable | DropColumn => Error
    _ => Warning
  }
}

///|
fn impact_effective_severity(
  options : ScanOptions,
  kind : SchemaChangeKind,
) -> Severity {
  migration_severity(options, "SQL305", impact_default_severity(kind))
}

///|
fn impact_query_tables(tokens : Array[Token]) -> Array[(String, Int)] {
  let tables : Array[(String, Int)] = []
  for i in 0..<tokens.length() {
    let token = tokens[i]
    if token.kind == Word &&
      (
        token.value == "FROM" ||
        token.value == "JOIN" ||
        token.value == "UPDATE" ||
        token.value == "INTO"
      ) {
      let start = i + 1
      if start < tokens.length() &&
        (tokens[start].kind == Word || tokens[start].kind == QuotedIdentifier) &&
        !(tokens[start].kind == Word &&
        (
          tokens[start].value == "SELECT" ||
          tokens[start].value == "LATERAL" ||
          tokens[start].value == "ONLY"
        )) {
        match qualified_name_at(tokens, start) {
          Some((_, name_index, name)) =>
            if !tables.any(entry => entry.0 == name) {
              tables.push((name, name_index))
            }
          None => ()
        }
      }
    }
  }
  tables
}

///|
fn impact_find_table(
  tables : Array[(String, Int)],
  table_name : String,
) -> (String, Int)? {
  for entry in tables {
    if entry.0 == table_name {
      return Some(entry)
    }
  }
  None
}

///|
fn impact_query_has_column(tokens : Array[Token], column : String) -> Bool {
  let target = column.to_lower()
  tokens.any(token => {
    (token.kind == Word || token.kind == QuotedIdentifier) &&
    token.value.to_lower() == target
  })
}

///|
fn impact_reference_key(reference : QueryReference) -> String {
  "\{reference.path.to_lower()}\u001f\{reference.change_kind.label()}\u001f\{reference.table_name}\u001f\{reference.column_name}"
}

///|
fn impact_unique_strings(values : Array[String]) -> Array[String] {
  let unique = []
  for value in values {
    if !unique.contains(value) {
      unique.push(value)
    }
  }
  unique.sort()
  unique
}

///|
fn impact_count_findings(
  findings : Array[MigrationFinding],
  severity : Severity,
) -> Int {
  let mut count = 0
  for entry in findings {
    if entry.finding.severity == severity {
      count = count + 1
    }
  }
  count
}

///|
fn impact_add_finding(
  findings : Array[MigrationFinding],
  options : ScanOptions,
  path : String,
  tokens : Array[Token],
  statement_index : Int,
  token_index : Int,
  change : SchemaChange,
) -> Unit {
  if options.ignored_rules.contains("SQL305") {
    return
  }
  let target = if change.column_name.is_empty() {
    change.table_name
  } else {
    "\{change.table_name}.\{change.column_name}"
  }
  let token = tokens[token_index]
  findings.push({
    path,
    finding: {
      rule_id: "SQL305",
      title: "Schema change may break downstream query",
      severity: impact_effective_severity(options, change.kind),
      message: "Query references '\{target}', which is affected by \{change.kind.label()} in the migration set.",
      suggestion: "Update this query together with the migration or keep a compatibility window until all callers move.",
      statement_index,
      line: token.line,
      column: token.column,
      evidence: statement_evidence(tokens),
      fingerprint: statement_fingerprint(tokens),
    },
  })
}

///|
/// Cross-reference migration changes with downstream query sources.
pub fn analyze_change_impact(
  migrations : Array[MigrationInput],
  queries : Array[MigrationInput],
  options : ScanOptions,
) -> ImpactAnalysis {
  let migration_analysis = analyze_migrations(migrations, options)
  let references : Array[QueryReference] = []
  let findings : Array[MigrationFinding] = []
  let seen : Map[String, Bool] = Map([])
  for query in queries {
    let tokens = tokenize(query.source)
    let statements = split_statements(tokens)
    let mut index = 0
    for statement in statements {
      let statement_index = index + 1
      let tables = impact_query_tables(statement)
      for change in migration_analysis.changes {
        guard impact_change_is_relevant(change.kind) else { continue }
        let table_ref = impact_find_table(tables, change.table_name)
        guard table_ref is Some((_, table_index)) else { continue }
        if !change.column_name.is_empty() &&
          !impact_query_has_column(statement, change.column_name) {
          continue
        }
        let reference : QueryReference = {
          change_kind: change.kind,
          table_name: change.table_name,
          column_name: change.column_name,
          path: query.path,
          line: statement[table_index].line,
          statement_index,
          evidence: statement_evidence(statement),
        }
        let key = impact_reference_key(reference)
        if !seen.contains(key) {
          seen[key] = true
          references.push(reference)
          impact_add_finding(
            findings,
            options,
            query.path,
            statement,
            statement_index,
            table_index,
            change,
          )
        }
      }
      index = index + 1
    }
  }
  let impacted_tables = impact_unique_strings(
    references.map(reference => reference.table_name),
  )
  let impacted_files = impact_unique_strings(
    references.map(reference => reference.path),
  )
  {
    references,
    findings,
    impacted_tables,
    impacted_files,
    error_count: impact_count_findings(findings, Error),
    warning_count: impact_count_findings(findings, Warning),
    info_count: impact_count_findings(findings, Info),
  }
}
