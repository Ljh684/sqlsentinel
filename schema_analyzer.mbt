///|
fn skip_optional_word(tokens : Array[Token], start : Int, word : String) -> Int {
  if start < tokens.length() && token_is_word(tokens[start], word) {
    start + 1
  } else {
    start
  }
}

///|
fn qualified_name_at(tokens : Array[Token], start : Int) -> (Int, Int, String)? {
  guard start < tokens.length() else { return None }
  let first = tokens[start]
  guard first.kind == Word || first.kind == QuotedIdentifier else {
    return None
  }
  let mut i = start + 1
  let mut name = first.value.to_lower()
  while i + 1 < tokens.length() &&
        token_is_symbol(tokens[i], ".") &&
        (tokens[i + 1].kind == Word || tokens[i + 1].kind == QuotedIdentifier) {
    name = tokens[i + 1].value.to_lower()
    i = i + 2
  }
  Some((i, start, name))
}

///|
fn skip_table_modifiers(tokens : Array[Token], start : Int) -> Int {
  let mut i = skip_optional_word(tokens, start, "TABLE")
  i = skip_optional_word(tokens, i, "IF")
  i = skip_optional_word(tokens, i, "NOT")
  i = skip_optional_word(tokens, i, "EXISTS")
  i
}

///|
fn destructive_target(
  tokens : Array[Token],
  main_index : Int,
  keyword : String,
) -> (Int, Int, String)? {
  if keyword == "DELETE" {
    match top_level_word(tokens, main_index + 1, "FROM") {
      Some(from_index) => qualified_name_at(tokens, from_index + 1)
      None => None
    }
  } else if keyword == "DROP" || keyword == "TRUNCATE" {
    qualified_name_at(tokens, skip_table_modifiers(tokens, main_index + 1))
  } else {
    None
  }
}

///|
fn inbound_foreign_key_sources(
  schema : SchemaCatalog,
  target_table : String,
) -> Array[String] {
  let sources = []
  let target = target_table.to_lower()
  for table in schema.tables {
    for foreign_key in table.foreign_keys {
      if foreign_key.references_table.to_lower() == target &&
        !sources.contains(table.name) {
        sources.push(table.name)
      }
    }
  }
  sources
}

///|
fn check_schema_referenced_table(
  tokens : Array[Token],
  statement_index : Int,
  findings : Array[Finding],
  schema : SchemaCatalog,
) -> Unit {
  let main = main_keyword_index(tokens)
  guard main is Some(main_index) else { return }
  let keyword = tokens[main_index].value
  match destructive_target(tokens, main_index, keyword) {
    None => ()
    Some((_, table_index, table_name)) =>
      match schema.find_table(table_name) {
        None => ()
        Some(table) => {
          let sources = inbound_foreign_key_sources(schema, table.name)
          if !sources.is_empty() {
            add_finding(
              findings,
              tokens,
              statement_index,
              table_index,
              "SQL201",
              "Destructive operation on referenced table",
              Warning,
              "Table '\{table.name}' is referenced by foreign keys from: \{sources.join(", ")}.",
              "Review dependent rows and foreign-key actions before deleting or removing this table.",
            )
          }
        }
      }
  }
}

///|
fn dropped_column(
  tokens : Array[Token],
  main_index : Int,
) -> (Int, Int, String, String)? {
  let table_start = skip_table_modifiers(tokens, main_index + 1)
  match qualified_name_at(tokens, table_start) {
    None => None
    Some((after_table, table_index, table_name)) =>
      match top_level_word(tokens, after_table, "DROP") {
        None => None
        Some(drop_index) => {
          let after_drop = skip_optional_word(tokens, drop_index + 1, "COLUMN")
          match qualified_name_at(tokens, after_drop) {
            Some((_, column_index, column_name)) =>
              Some((table_index, column_index, table_name, column_name))
            None => None
          }
        }
      }
  }
}

///|
fn check_schema_protected_column(
  tokens : Array[Token],
  statement_index : Int,
  findings : Array[Finding],
  schema : SchemaCatalog,
) -> Unit {
  let main = main_keyword_index(tokens)
  guard main is Some(main_index) && tokens[main_index].value == "ALTER" else {
    return
  }
  match dropped_column(tokens, main_index) {
    None => ()
    Some((table_index, column_index, table_name, column_name)) => {
      ignore(table_index)
      match schema.find_table(table_name) {
        None => ()
        Some(table) =>
          if table.has_column(column_name) &&
            (
              table.column_is_protected(column_name) ||
              schema.column_is_referenced(table.name, column_name)
            ) {
            add_finding(
              findings,
              tokens,
              statement_index,
              column_index,
              "SQL202",
              "Dropping schema-protected column",
              Error,
              "Column '\{table.name}.\{column_name}' is used by an index or a foreign-key relationship.",
              "Remove or replace dependent indexes and foreign keys before dropping the column.",
            )
          }
      }
    }
  }
}

///|
fn check_schema_rules(
  tokens : Array[Token],
  statement_index : Int,
  findings : Array[Finding],
  schema : SchemaCatalog,
) -> Unit {
  if schema.tables.is_empty() {
    return
  }
  check_schema_referenced_table(tokens, statement_index, findings, schema)
  check_schema_protected_column(tokens, statement_index, findings, schema)
}
