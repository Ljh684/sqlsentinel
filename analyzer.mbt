///|
fn statement_evidence(tokens : Array[Token]) -> String {
  let builder = StringBuilder()
  let limit = if tokens.length() < 18 { tokens.length() } else { 18 }
  for i in 0..<limit {
    if i > 0 {
      builder.write_char(' ')
    }
    builder.write_string(tokens[i].text)
  }
  if limit < tokens.length() {
    builder.write_string(" ...")
  }
  let result = builder.to_string()
  if result.char_length() > 160 {
    result[0:160].to_owned() + "..."
  } else {
    result
  }
}

///|
fn top_level_word(tokens : Array[Token], start : Int, word : String) -> Int? {
  let mut depth = 0
  for i in start..<tokens.length() {
    let token = tokens[i]
    if token_is_symbol(token, "(") {
      depth = depth + 1
    } else if token_is_symbol(token, ")") {
      if depth > 0 {
        depth = depth - 1
      }
    } else if depth == 0 && token_is_word(token, word) {
      return Some(i)
    }
  }
  None
}

///|
fn main_keyword_index(tokens : Array[Token]) -> Int? {
  let mut depth = 0
  let mut i = 0
  while i < tokens.length() {
    let token = tokens[i]
    if token_is_symbol(token, "(") {
      depth = depth + 1
    } else if token_is_symbol(token, ")") {
      if depth > 0 {
        depth = depth - 1
      }
    } else if depth == 0 &&
      token.kind == Word &&
      (
        token.value == "SELECT" ||
        token.value == "INSERT" ||
        token.value == "UPDATE" ||
        token.value == "DELETE" ||
        token.value == "ALTER" ||
        token.value == "DROP" ||
        token.value == "TRUNCATE" ||
        token.value == "CREATE" ||
        token.value == "GRANT" ||
        token.value == "REVOKE" ||
        token.value == "MERGE"
      ) {
      return Some(i)
    }
    i = i + 1
  }
  None
}

///|
fn has_top_level_word(
  tokens : Array[Token],
  start : Int,
  word : String,
) -> Bool {
  top_level_word(tokens, start, word) is Some(_)
}

///|
fn trivial_where(tokens : Array[Token], where_index : Int) -> Bool {
  let parts = []
  let mut depth = 0
  for i in (where_index + 1)..<tokens.length() {
    let token = tokens[i]
    if token_is_symbol(token, "(") {
      depth = depth + 1
    } else if token_is_symbol(token, ")") {
      if depth > 0 {
        depth = depth - 1
      }
    }
    if depth == 0 &&
      (
        token_is_word(token, "ORDER") ||
        token_is_word(token, "GROUP") ||
        token_is_word(token, "LIMIT") ||
        token_is_word(token, "RETURNING")
      ) {
      break
    }
    if depth == 0 &&
      !token_is_symbol(token, "(") &&
      !token_is_symbol(token, ")") {
      parts.push(token.value)
    }
  }
  match parts {
    ["TRUE"] => true
    ["1", "=", "1"] => true
    ["0", "=", "0"] => true
    ["'<literal>'", "=", "'<literal>'"] => true
    _ => false
  }
}

///|
fn add_finding(
  findings : Array[Finding],
  tokens : Array[Token],
  statement_index : Int,
  token_index : Int,
  rule_id : String,
  title : String,
  severity : Severity,
  message : String,
  suggestion : String,
) -> Unit {
  let token = tokens[token_index]
  findings.push({
    rule_id,
    title,
    severity,
    message,
    suggestion,
    statement_index,
    line: token.line,
    column: token.column,
    evidence: statement_evidence(tokens),
  })
}

///|
fn check_mutation_without_where(
  tokens : Array[Token],
  statement_index : Int,
  findings : Array[Finding],
  options : ScanOptions,
) -> Unit {
  let main = main_keyword_index(tokens)
  guard main is Some(index) else { return }
  let keyword = tokens[index].value
  guard keyword == "UPDATE" || keyword == "DELETE" else { return }
  let where_index = top_level_word(tokens, index + 1, "WHERE")
  if where_index is None || (where_index is Some(w) && trivial_where(tokens, w)) {
    let severity = if options.allow_destructive {
      Severity::Warning
    } else {
      Severity::Error
    }
    let message = if where_index is None {
      "\{keyword} has no top-level WHERE clause and may affect every row."
    } else {
      "\{keyword} uses a predicate that is always true and may affect every row."
    }
    add_finding(
      findings, tokens, statement_index, index, "SQL001", "Unbounded data mutation",
      severity, message, "Add a selective WHERE clause, or explicitly approve a full-table maintenance operation.",
    )
  }
}

///|
fn check_destructive_ddl(
  tokens : Array[Token],
  statement_index : Int,
  findings : Array[Finding],
  options : ScanOptions,
) -> Unit {
  let main = main_keyword_index(tokens)
  guard main is Some(index) else { return }
  let keyword = tokens[index].value
  let next = if index + 1 < tokens.length() {
    Some(tokens[index + 1].value)
  } else {
    None
  }
  let mut dangerous = false
  let mut description = ""
  if keyword == "TRUNCATE" {
    dangerous = true
    description = "TRUNCATE erases all rows from the target table."
  } else if keyword == "DROP" {
    match next {
      Some("TABLE") | Some("DATABASE") | Some("SCHEMA") | Some("OWNED") => {
        dangerous = true
        description = "The statement removes a persistent schema object."
      }
      _ => ()
    }
  } else if keyword == "ALTER" {
    let drop_index = top_level_word(tokens, index + 1, "DROP")
    if drop_index is Some(drop_pos) {
      let afterward = []
      for i in (drop_pos + 1)..<tokens.length() {
        afterward.push(tokens[i].value)
      }
      if afterward.contains("COLUMN") || afterward.contains("TABLE") {
        dangerous = true
        description = "ALTER ... DROP removes an existing column or table object."
      }
    }
  }
  if dangerous {
    let severity = if options.allow_destructive {
      Severity::Warning
    } else {
      Severity::Error
    }
    add_finding(
      findings, tokens, statement_index, index, "SQL002", "Destructive schema change",
      severity, description, "Back up affected data, use expand-and-contract migration, and require explicit review.",
    )
  }
}

///|
fn check_wildcard_select(
  tokens : Array[Token],
  statement_index : Int,
  findings : Array[Finding],
) -> Unit {
  for i in 0..<tokens.length() {
    if !token_is_word(tokens[i], "SELECT") {
      continue
    }
    let mut depth = 0
    let mut j = i + 1
    while j < tokens.length() {
      let token = tokens[j]
      if token_is_symbol(token, "(") {
        depth = depth + 1
      } else if token_is_symbol(token, ")") {
        if depth == 0 {
          break
        }
        depth = depth - 1
      } else if depth == 0 && token_is_word(token, "FROM") {
        break
      } else if depth == 0 && token_is_symbol(token, "*") {
        add_finding(
          findings,
          tokens,
          statement_index,
          j,
          "SQL003",
          "Wildcard projection",
          Warning,
          "SELECT * couples the result to every current and future column.",
          "List only the columns that the application actually consumes.",
        )
      }
      j = j + 1
    }
  }
}

///|
fn check_limit_without_order(
  tokens : Array[Token],
  statement_index : Int,
  findings : Array[Finding],
) -> Unit {
  let main = main_keyword_index(tokens)
  guard main is Some(index) && tokens[index].value == "SELECT" else { return }
  match top_level_word(tokens, index + 1, "LIMIT") {
    Some(limit_index) =>
      if !has_top_level_word(tokens, index + 1, "ORDER") {
        add_finding(
          findings,
          tokens,
          statement_index,
          limit_index,
          "SQL004",
          "Non-deterministic pagination",
          Warning,
          "LIMIT is present without an ORDER BY clause, so row selection is not stable.",
          "Add a stable ORDER BY, preferably using a unique or indexed key.",
        )
      }
    None => ()
  }
}

///|
fn check_leading_like(
  tokens : Array[Token],
  statement_index : Int,
  findings : Array[Finding],
) -> Unit {
  for i in 0..<tokens.length() {
    if !(token_is_word(tokens[i], "LIKE") || token_is_word(tokens[i], "ILIKE")) {
      continue
    }
    if i + 1 < tokens.length() && tokens[i + 1].kind == StringLiteral {
      let value = tokens[i + 1].value
      let trimmed = value.trim_start()
      if (trimmed.has_prefix("%") && !trimmed.has_prefix("\\%")) ||
        (trimmed.has_prefix("_") && !trimmed.has_prefix("\\_")) {
        add_finding(
          findings,
          tokens,
          statement_index,
          i,
          "SQL005",
          "Leading-wildcard LIKE",
          Warning,
          "The LIKE pattern starts with a wildcard and may force a broad scan.",
          "Prefer a prefix search or add a trigram/full-text index for contains-style matching.",
        )
      }
    }
  }
}

///|
fn check_comma_join(
  tokens : Array[Token],
  statement_index : Int,
  findings : Array[Finding],
) -> Unit {
  let main = main_keyword_index(tokens)
  guard main is Some(index) && tokens[index].value == "SELECT" else { return }
  match top_level_word(tokens, index + 1, "FROM") {
    None => ()
    Some(from_index) => {
      let mut depth = 0
      let mut has_join = false
      let mut comma_index = None
      let mut j = from_index + 1
      while j < tokens.length() {
        let token = tokens[j]
        if token_is_symbol(token, "(") {
          depth = depth + 1
        } else if token_is_symbol(token, ")") {
          if depth > 0 {
            depth = depth - 1
          }
        } else if depth == 0 &&
          (
            token_is_word(token, "WHERE") ||
            token_is_word(token, "GROUP") ||
            token_is_word(token, "ORDER") ||
            token_is_word(token, "LIMIT") ||
            token_is_word(token, "RETURNING")
          ) {
          break
        } else if depth == 0 && token_is_word(token, "JOIN") {
          has_join = true
        } else if depth == 0 &&
          token_is_symbol(token, ",") &&
          comma_index is None {
          comma_index = Some(j)
        }
        j = j + 1
      }
      if !has_join && comma_index is Some(comma) {
        add_finding(
          findings,
          tokens,
          statement_index,
          comma,
          "SQL006",
          "Comma join",
          Warning,
          "The FROM clause uses a comma-separated table list without an explicit JOIN.",
          "Use explicit JOIN syntax and place relationship predicates in ON.",
        )
      }
    }
  }
}

///|
fn check_insert_columns(
  tokens : Array[Token],
  statement_index : Int,
  findings : Array[Finding],
) -> Unit {
  let main = main_keyword_index(tokens)
  guard main is Some(index) && tokens[index].value == "INSERT" else { return }
  match top_level_word(tokens, index + 1, "INTO") {
    None => ()
    Some(into_index) => {
      let mut depth = 0
      let mut saw_column_list = false
      let mut saw_values = None
      let mut saw_default = false
      let mut j = into_index + 1
      while j < tokens.length() {
        let token = tokens[j]
        if token_is_symbol(token, "(") {
          if depth == 0 {
            saw_column_list = true
          }
          depth = depth + 1
        } else if token_is_symbol(token, ")") {
          if depth > 0 {
            depth = depth - 1
          }
        } else if depth == 0 && token_is_word(token, "DEFAULT") {
          saw_default = true
        } else if depth == 0 &&
          (token_is_word(token, "VALUES") || token_is_word(token, "SELECT")) {
          saw_values = Some(j)
          break
        }
        j = j + 1
      }
      match saw_values {
        Some(values_index) =>
          if !saw_column_list && !saw_default {
            add_finding(
              findings,
              tokens,
              statement_index,
              values_index,
              "SQL007",
              "INSERT without a column list",
              Warning,
              "The INSERT relies on physical column order and will break when the table shape changes.",
              "Name every target column explicitly in the INSERT statement.",
            )
          }
        None => ()
      }
    }
  }
}

///|
fn check_add_not_null(
  tokens : Array[Token],
  statement_index : Int,
  findings : Array[Finding],
) -> Unit {
  let main = main_keyword_index(tokens)
  guard main is Some(index) && tokens[index].value == "ALTER" else { return }
  let add_index = top_level_word(tokens, index + 1, "ADD")
  guard add_index is Some(add_pos) else { return }
  let mut has_not_null = false
  let mut has_default = false
  let mut depth = 0
  for i in (add_pos + 1)..<tokens.length() {
    let token = tokens[i]
    if token_is_symbol(token, "(") {
      depth = depth + 1
    } else if token_is_symbol(token, ")") {
      if depth > 0 {
        depth = depth - 1
      }
    } else if depth == 0 && token_is_symbol(token, ",") {
      break
    } else if depth == 0 && token_is_word(token, "DEFAULT") {
      has_default = true
    } else if depth == 0 && token_is_word(token, "NOT") {
      if i + 1 < tokens.length() && token_is_word(tokens[i + 1], "NULL") {
        has_not_null = true
      }
    }
  }
  if has_not_null && !has_default {
    add_finding(
      findings,
      tokens,
      statement_index,
      add_pos,
      "SQL008",
      "NOT NULL column without a default",
      Warning,
      "Adding a NOT NULL column without a default can fail existing rows or force a table rewrite.",
      "Add a nullable/defaulted column, backfill it, then enforce NOT NULL in a later migration.",
    )
  }
}

///|
fn compare_findings(a : Finding, b : Finding) -> Int {
  if a.line < b.line {
    -1
  } else if a.line > b.line {
    1
  } else if a.column < b.column {
    -1
  } else if a.column > b.column {
    1
  } else if a.severity.rank() > b.severity.rank() {
    -1
  } else if a.severity.rank() < b.severity.rank() {
    1
  } else {
    a.rule_id.compare(b.rule_id)
  }
}

///|
fn count_findings(findings : Array[Finding], severity : Severity) -> Int {
  let mut count = 0
  for finding in findings {
    if finding.severity == severity {
      count = count + 1
    }
  }
  count
}

///|
fn scan_sql_with_options(source : String, options : ScanOptions) -> Report {
  let statements = split_statements(tokenize(source))
  let findings = []
  let mut index = 0
  for tokens in statements {
    let statement_index = index + 1
    check_mutation_without_where(tokens, statement_index, findings, options)
    check_destructive_ddl(tokens, statement_index, findings, options)
    if options.style_checks {
      check_wildcard_select(tokens, statement_index, findings)
      check_limit_without_order(tokens, statement_index, findings)
      check_leading_like(tokens, statement_index, findings)
      check_comma_join(tokens, statement_index, findings)
      check_insert_columns(tokens, statement_index, findings)
      check_add_not_null(tokens, statement_index, findings)
    }
    index = index + 1
  }
  findings.sort_by(compare_findings)
  let active_findings = findings.filter(finding => {
    !options.ignored_rules.contains(finding.rule_id)
  })
  {
    statement_count: index,
    findings: active_findings,
    error_count: count_findings(active_findings, Error),
    warning_count: count_findings(active_findings, Warning),
    info_count: count_findings(active_findings, Info),
  }
}

///|
/// Scan SQL text using the default policy.
pub fn scan_sql(source : String) -> Report {
  scan_sql_with_options(source, ScanOptions::default())
}

///|
/// Scan SQL text with explicit policy controls.
pub fn scan_sql_with(source : String, options : ScanOptions) -> Report {
  scan_sql_with_options(source, options)
}
