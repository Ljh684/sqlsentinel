///|
priv struct MigrationForeignKeyState {
  columns : Array[String]
  references_table : String
  references_columns : Array[String]
}

///|
priv struct MigrationTableState {
  name : String
  columns : Map[String, String]
  indexes : Array[Array[String]]
  foreign_keys : Array[MigrationForeignKeyState]
}

///|
priv struct MigrationState {
  tables : Map[String, MigrationTableState]
  changes : Array[SchemaChange]
  findings : Array[MigrationFinding]
  traces : Array[StatementTrace]
}

///|
fn migration_put_table(
  state : MigrationState,
  table : MigrationTableState,
) -> Unit {
  state.tables[table.name.to_lower()] = table
}

///|
fn migration_severity(
  options : ScanOptions,
  rule_id : String,
  default : Severity,
) -> Severity {
  for policy in options.severity_overrides {
    if policy.rule_id == rule_id {
      return policy.severity
    }
  }
  default
}

///|
fn migration_add_finding(
  state : MigrationState,
  options : ScanOptions,
  path : String,
  tokens : Array[Token],
  statement_index : Int,
  token_index : Int,
  rule_id : String,
  title : String,
  default_severity : Severity,
  message : String,
  suggestion : String,
) -> Unit {
  if options.ignored_rules.contains(rule_id) {
    return
  }
  let token = tokens[token_index]
  state.findings.push({
    path,
    finding: {
      rule_id,
      title,
      severity: migration_severity(options, rule_id, default_severity),
      message,
      suggestion,
      statement_index,
      line: token.line,
      column: token.column,
      evidence: statement_evidence(tokens),
      fingerprint: statement_fingerprint(tokens),
    },
  })
}

///|
fn migration_add_change(
  state : MigrationState,
  kind : SchemaChangeKind,
  table_name : String,
  column_name : String,
  detail : String,
  path : String,
  token : Token,
  statement_index : Int,
) -> Unit {
  state.changes.push({
    kind,
    table_name,
    column_name,
    detail,
    path,
    line: token.line,
    statement_index,
  })
}

///|
fn migration_find_symbol(
  tokens : Array[Token],
  start : Int,
  symbol : String,
) -> Int? {
  for i in start..<tokens.length() {
    if token_is_symbol(tokens[i], symbol) {
      return Some(i)
    }
  }
  None
}

///|
fn migration_matching_paren(tokens : Array[Token], open : Int) -> Int? {
  if !token_is_symbol(tokens[open], "(") {
    return None
  }
  let mut depth = 1
  for i in (open + 1)..<tokens.length() {
    if token_is_symbol(tokens[i], "(") {
      depth = depth + 1
    } else if token_is_symbol(tokens[i], ")") {
      depth = depth - 1
      if depth == 0 {
        return Some(i)
      }
    }
  }
  None
}

///|
fn migration_comma_segments(
  tokens : Array[Token],
  start : Int,
  end : Int,
) -> Array[Array[Token]] {
  let segments : Array[Array[Token]] = []
  let mut current : Array[Token] = []
  let mut depth = 0
  for i in start..<end {
    let token = tokens[i]
    if token_is_symbol(token, "(") {
      depth = depth + 1
    } else if token_is_symbol(token, ")") {
      if depth > 0 {
        depth = depth - 1
      }
    }
    if depth == 0 && token_is_symbol(token, ",") {
      if !current.is_empty() {
        segments.push(current)
        current = []
      }
    } else {
      current.push(token)
    }
  }
  if !current.is_empty() {
    segments.push(current)
  }
  segments
}

///|
fn migration_is_column_constraint(word : String) -> Bool {
  match word {
    "CONSTRAINT" | "PRIMARY" | "FOREIGN" | "UNIQUE" | "CHECK" | "EXCLUDE" =>
      true
    _ => false
  }
}

///|
priv struct ParsedColumnDefinition {
  name : String
  column_type : String
  indexed : Bool
}

///|
fn migration_parse_column_definition(
  tokens : Array[Token],
) -> ParsedColumnDefinition? {
  if tokens.is_empty() {
    return None
  }
  let first = tokens[0]
  if !(first.kind == Word || first.kind == QuotedIdentifier) {
    return None
  }
  if first.kind == Word && migration_is_column_constraint(first.value) {
    return None
  }
  let type_parts = []
  let mut indexed = false
  let mut i = 1
  while i < tokens.length() {
    let token = tokens[i]
    if token.kind == Word &&
      (
        token.value == "NOT" ||
        token.value == "NULL" ||
        token.value == "DEFAULT" ||
        token.value == "PRIMARY" ||
        token.value == "UNIQUE" ||
        token.value == "REFERENCES" ||
        token.value == "CHECK" ||
        token.value == "GENERATED" ||
        token.value == "COLLATE" ||
        token.value == "CONSTRAINT"
      ) {
      if token.value == "PRIMARY" &&
        i + 1 < tokens.length() &&
        token_is_word(tokens[i + 1], "KEY") {
        indexed = true
      }
      if token.value == "UNIQUE" {
        indexed = true
      }
      break
    }
    type_parts.push(token.text)
    i = i + 1
  }
  Some({
    name: first.value.to_lower(),
    column_type: type_parts.join(" ").to_lower(),
    indexed,
  })
}

///|
fn migration_columns_from_paren(
  tokens : Array[Token],
  open : Int,
) -> (Int, Array[String])? {
  let close = match migration_matching_paren(tokens, open) {
    Some(close) => close
    None => return None
  }
  let columns = []
  for segment in migration_comma_segments(tokens, open + 1, close) {
    if !segment.is_empty() &&
      (segment[0].kind == Word || segment[0].kind == QuotedIdentifier) {
      columns.push(segment[0].value.to_lower())
    }
  }
  if columns.is_empty() {
    None
  } else {
    Some((close, columns))
  }
}

///|
fn migration_add_index(
  table : MigrationTableState,
  columns : Array[String],
) -> Unit {
  if !table.indexes.any(existing => existing == columns) {
    table.indexes.push(columns)
  }
}

///|
fn migration_create_table(
  state : MigrationState,
  _options : ScanOptions,
  path : String,
  tokens : Array[Token],
  statement_index : Int,
  create_index : Int,
) -> Unit {
  let table_index = match top_level_word(tokens, create_index + 1, "TABLE") {
    Some(index) => index
    None => return
  }
  let mut name_index = skip_table_modifiers(tokens, table_index + 1)
  match qualified_name_at(tokens, name_index) {
    None => ()
    Some((after_name, table_token, table_name)) => {
      let columns : Map[String, String] = Map([])
      let indexes : Array[Array[String]] = []
      name_index = table_token
      match migration_find_symbol(tokens, after_name, "(") {
        Some(open) =>
          match migration_matching_paren(tokens, open) {
            Some(close) =>
              for segment in migration_comma_segments(tokens, open + 1, close) {
                match migration_parse_column_definition(segment) {
                  Some(column) => {
                    columns[column.name] = column.column_type
                    if column.indexed {
                      indexes.push([column.name])
                    }
                  }
                  None =>
                    if !segment.is_empty() &&
                      token_is_word(segment[0], "PRIMARY") {
                      match migration_find_symbol(segment, 0, "(") {
                        Some(primary_open) =>
                          match
                            migration_columns_from_paren(segment, primary_open) {
                            Some((_, primary_columns)) =>
                              indexes.push(primary_columns)
                            None => ()
                          }
                        None => ()
                      }
                    }
                }
              }
            None => ()
          }
        None => ()
      }
      let table : MigrationTableState = {
        name: table_name,
        columns,
        indexes,
        foreign_keys: [],
      }
      migration_put_table(state, table)
      migration_add_change(
        state,
        CreateTable,
        table_name,
        "",
        "created with \{columns.length()} column(s)",
        path,
        tokens[name_index],
        statement_index,
      )
    }
  }
}

///|
fn migration_create_index(
  state : MigrationState,
  options : ScanOptions,
  path : String,
  tokens : Array[Token],
  statement_index : Int,
  create_index : Int,
) -> Unit {
  let index_keyword = match top_level_word(tokens, create_index + 1, "INDEX") {
    Some(index) => index
    None => return
  }
  let (_, _, _) = match qualified_name_at(tokens, index_keyword + 1) {
    Some(value) => value
    None => return
  }
  let on_index = match top_level_word(tokens, index_keyword + 1, "ON") {
    Some(index) => index
    None => return
  }
  match qualified_name_at(tokens, on_index + 1) {
    None => ()
    Some((after_table, table_index, table_name)) =>
      match migration_find_symbol(tokens, after_table, "(") {
        Some(open) =>
          match migration_columns_from_paren(tokens, open) {
            Some((_, columns)) =>
              match state.tables.get(table_name) {
                Some(table) => {
                  migration_add_index(table, columns)
                  migration_put_table(state, table)
                  migration_add_change(
                    state,
                    CreateIndex,
                    table_name,
                    columns.join(","),
                    "indexed column prefix",
                    path,
                    tokens[table_index],
                    statement_index,
                  )
                }
                None =>
                  if !options.schema.tables.is_empty() ||
                    !state.tables.is_empty() {
                    migration_add_finding(
                      state,
                      options,
                      path,
                      tokens,
                      statement_index,
                      table_index,
                      "SQL302",
                      "Migration references a missing schema object",
                      Error,
                      "CREATE INDEX targets unknown table '\{table_name}'.",
                      "Create the table first or correct the migration order.",
                    )
                  }
              }
            None => ()
          }
        None => ()
      }
  }
}

///|
fn migration_rename_table(
  state : MigrationState,
  options : ScanOptions,
  path : String,
  tokens : Array[Token],
  statement_index : Int,
  table_name : String,
  target_index : Int,
) -> Unit {
  match state.tables.get(table_name) {
    None =>
      migration_add_finding(
        state,
        options,
        path,
        tokens,
        statement_index,
        target_index,
        "SQL302",
        "Migration references a missing schema object",
        Error,
        "Cannot rename unknown table '\{table_name}'.",
        "Correct the table name or apply its CREATE statement first.",
      )
    Some(table) => {
      state.tables.remove(table_name)
      let old_name = table.name
      let renamed = { ..table, name: tokens[target_index].value.to_lower(), }
      migration_put_table(state, renamed)
      for _, other in state.tables {
        for i in 0..<other.foreign_keys.length() {
          if other.foreign_keys[i].references_table == table_name {
            other.foreign_keys[i] = {
              ..other.foreign_keys[i],
              references_table: renamed.name,
            }
          }
        }
      }
      migration_add_change(
        state,
        RenameTable,
        old_name,
        "",
        "renamed to \{renamed.name}",
        path,
        tokens[target_index],
        statement_index,
      )
      migration_add_finding(
        state,
        options,
        path,
        tokens,
        statement_index,
        target_index,
        "SQL304",
        "Rename can break dependent callers",
        Warning,
        "Table '\{old_name}' was renamed to '\{renamed.name}'.",
        "Update dependent callers and keep a compatibility path during rollout.",
      )
    }
  }
}

///|
fn migration_rename_column(
  state : MigrationState,
  options : ScanOptions,
  path : String,
  tokens : Array[Token],
  statement_index : Int,
  table_name : String,
  old_name : String,
  new_name : String,
  target_index : Int,
) -> Unit {
  match state.tables.get(table_name) {
    None =>
      migration_add_finding(
        state,
        options,
        path,
        tokens,
        statement_index,
        target_index,
        "SQL302",
        "Migration references a missing schema object",
        Error,
        "Cannot rename a column on unknown table '\{table_name}'.",
        "Correct the table name or apply its CREATE statement first.",
      )
    Some(table) =>
      match table.columns.get(old_name) {
        None =>
          migration_add_finding(
            state,
            options,
            path,
            tokens,
            statement_index,
            target_index,
            "SQL302",
            "Migration references a missing schema object",
            Error,
            "Cannot rename unknown column '\{table_name}.\{old_name}'.",
            "Correct the column name or reorder prerequisite migrations.",
          )
        Some(column_type) => {
          state.tables.remove(table_name)
          table.columns.remove(old_name)
          table.columns[new_name] = column_type
          for index in table.indexes {
            for i in 0..<index.length() {
              if index[i] == old_name {
                index[i] = new_name
              }
            }
          }
          for foreign_key in table.foreign_keys {
            for i in 0..<foreign_key.columns.length() {
              if foreign_key.columns[i] == old_name {
                foreign_key.columns[i] = new_name
              }
            }
          }
          migration_put_table(state, table)
          for _, other in state.tables {
            for foreign_key in other.foreign_keys {
              if foreign_key.references_table == table_name {
                for i in 0..<foreign_key.references_columns.length() {
                  if foreign_key.references_columns[i] == old_name {
                    foreign_key.references_columns[i] = new_name
                  }
                }
              }
            }
          }
          migration_add_change(
            state,
            RenameColumn,
            table_name,
            old_name,
            "renamed to \{new_name}",
            path,
            tokens[target_index],
            statement_index,
          )
          migration_add_finding(
            state,
            options,
            path,
            tokens,
            statement_index,
            target_index,
            "SQL304",
            "Rename can break dependent callers",
            Warning,
            "Column '\{table_name}.\{old_name}' was renamed to '\{new_name}'.",
            "Update dependent callers and keep a compatibility path during rollout.",
          )
        }
      }
  }
}

///|
fn migration_index_supports_foreign_key(
  table : MigrationTableState,
  columns : Array[String],
) -> Bool {
  for index in table.indexes {
    if index.length() >= columns.length() {
      let mut matches = true
      for i in 0..<columns.length() {
        if index[i] != columns[i] {
          matches = false
          break
        }
      }
      if matches {
        return true
      }
    }
  }
  false
}

///|
fn migration_add_foreign_key(
  state : MigrationState,
  options : ScanOptions,
  path : String,
  tokens : Array[Token],
  statement_index : Int,
  table_name : String,
  search_start : Int,
  target_index : Int,
) -> Unit {
  let foreign_index = match top_level_word(tokens, search_start, "FOREIGN") {
    Some(index) => index
    None => return
  }
  let key_index = match top_level_word(tokens, foreign_index + 1, "KEY") {
    Some(index) => index
    None => return
  }
  let local_open = match migration_find_symbol(tokens, key_index + 1, "(") {
    Some(index) => index
    None => return
  }
  let (_, local_columns) = match
    migration_columns_from_paren(tokens, local_open) {
    Some(value) => value
    None => return
  }
  let references_index = match
    top_level_word(tokens, local_open, "REFERENCES") {
    Some(index) => index
    None => return
  }
  let (after_ref, ref_table_index, ref_table) = match
    qualified_name_at(tokens, references_index + 1) {
    Some(value) => value
    None => return
  }
  let ref_open = match migration_find_symbol(tokens, after_ref, "(") {
    Some(index) => index
    None => return
  }
  let (_, ref_columns) = match migration_columns_from_paren(tokens, ref_open) {
    Some(value) => value
    None => return
  }
  match state.tables.get(table_name) {
    None =>
      migration_add_finding(
        state,
        options,
        path,
        tokens,
        statement_index,
        target_index,
        "SQL302",
        "Migration references a missing schema object",
        Error,
        "Foreign key targets unknown local table '\{table_name}'.",
        "Correct the table name or reorder the migration.",
      )
    Some(table) => {
      let mut valid = true
      for column in local_columns {
        if !table.columns.contains(column) {
          valid = false
          migration_add_finding(
            state,
            options,
            path,
            tokens,
            statement_index,
            target_index,
            "SQL302",
            "Migration references a missing schema object",
            Error,
            "Foreign key references missing local column '\{table_name}.\{column}'.",
            "Add the local column before creating the foreign key.",
          )
        }
      }
      match state.tables.get(ref_table) {
        None => {
          valid = false
          migration_add_finding(
            state,
            options,
            path,
            tokens,
            statement_index,
            ref_table_index,
            "SQL302",
            "Migration references a missing schema object",
            Error,
            "Foreign key references unknown table '\{ref_table}'.",
            "Create the referenced table or correct migration order.",
          )
        }
        Some(referenced) =>
          for column in ref_columns {
            if !referenced.columns.contains(column) {
              valid = false
              migration_add_finding(
                state,
                options,
                path,
                tokens,
                statement_index,
                ref_table_index,
                "SQL302",
                "Migration references a missing schema object",
                Error,
                "Foreign key references missing column '\{ref_table}.\{column}'.",
                "Correct the referenced column or reorder prerequisites.",
              )
            }
          }
      }
      if valid {
        table.foreign_keys.push({
          columns: local_columns,
          references_table: ref_table,
          references_columns: ref_columns,
        })
        migration_put_table(state, table)
        migration_add_change(
          state,
          AddForeignKey,
          table_name,
          local_columns.join(","),
          "references \{ref_table}(\{ref_columns.join(",")})",
          path,
          tokens[target_index],
          statement_index,
        )
        if !migration_index_supports_foreign_key(table, local_columns) {
          migration_add_finding(
            state,
            options,
            path,
            tokens,
            statement_index,
            target_index,
            "SQL303",
            "Foreign key without a supporting index",
            Warning,
            "Foreign key columns '\{table_name}(\{local_columns.join(",")})' have no matching index prefix.",
            "Create an index whose leading columns match the foreign-key columns.",
          )
        }
      }
    }
  }
}

///|
fn migration_alter_table(
  state : MigrationState,
  options : ScanOptions,
  path : String,
  tokens : Array[Token],
  statement_index : Int,
  alter_index : Int,
) -> Unit {
  let table_start = skip_table_modifiers(tokens, alter_index + 1)
  let (after_table, table_index, table_name) = match
    qualified_name_at(tokens, table_start) {
    Some(value) => value
    None => return
  }
  let table = state.tables.get(table_name)
  let schema_known = !options.schema.tables.is_empty() ||
    !state.tables.is_empty()
  if table is None {
    if schema_known {
      migration_add_finding(
        state,
        options,
        path,
        tokens,
        statement_index,
        table_index,
        "SQL302",
        "Migration references a missing schema object",
        Error,
        "ALTER TABLE targets unknown table '\{table_name}'.",
        "Correct the table name or reorder prerequisite migrations.",
      )
    }
    return
  }
  match top_level_word(tokens, after_table, "ADD") {
    Some(add_index) => {
      let after_add = skip_optional_word(tokens, add_index + 1, "COLUMN")
      if has_top_level_word(tokens, add_index + 1, "CONSTRAINT") ||
        has_top_level_word(tokens, add_index + 1, "FOREIGN") {
        migration_add_foreign_key(
          state,
          options,
          path,
          tokens,
          statement_index,
          table_name,
          add_index + 1,
          table_index,
        )
      } else {
        let definition_end = match
          top_level_word(tokens, after_add, "CASCADE") {
          Some(index) => index
          None => tokens.length()
        }
        match
          migration_parse_column_definition(
            tokens[after_add:definition_end].to_owned(),
          ) {
          Some(column) =>
            match state.tables.get(table_name) {
              Some(table) => {
                state.tables.remove(table_name)
                table.columns[column.name] = column.column_type
                if column.indexed {
                  migration_add_index(table, [column.name])
                }
                migration_put_table(state, table)
                migration_add_change(
                  state,
                  AddColumn,
                  table_name,
                  column.name,
                  column.column_type,
                  path,
                  tokens[after_add],
                  statement_index,
                )
              }
              None =>
                if schema_known {
                  migration_add_finding(
                    state,
                    options,
                    path,
                    tokens,
                    statement_index,
                    after_add,
                    "SQL302",
                    "Migration references a missing schema object",
                    Error,
                    "Cannot add a column to unknown table '\{table_name}'.",
                    "Correct the table name or reorder prerequisite migrations.",
                  )
                }
            }
          None => ()
        }
      }
    }
    None => ()
  }
  match top_level_word(tokens, after_table, "DROP") {
    Some(drop_index) =>
      if has_top_level_word(tokens, drop_index + 1, "CONSTRAINT") {
        ()
      } else {
        let column_index = skip_optional_word(tokens, drop_index + 1, "COLUMN")
        match qualified_name_at(tokens, column_index) {
          Some((_, column_token, column_name)) =>
            match state.tables.get(table_name) {
              Some(table) =>
                if table.columns.contains(column_name) {
                  state.tables.remove(table_name)
                  table.columns.remove(column_name)
                  migration_put_table(state, table)
                  migration_add_change(
                    state,
                    DropColumn,
                    table_name,
                    column_name,
                    "column removed",
                    path,
                    tokens[column_token],
                    statement_index,
                  )
                } else {
                  migration_add_finding(
                    state,
                    options,
                    path,
                    tokens,
                    statement_index,
                    column_token,
                    "SQL302",
                    "Migration references a missing schema object",
                    Error,
                    "Cannot drop unknown column '\{table_name}.\{column_name}'.",
                    "Correct the column name or reorder prerequisite migrations.",
                  )
                }
              None => ()
            }
          None => ()
        }
      }
    None => ()
  }
  match top_level_word(tokens, after_table, "ALTER") {
    Some(alter_column_index) => {
      let column_index = skip_optional_word(
        tokens,
        alter_column_index + 1,
        "COLUMN",
      )
      match qualified_name_at(tokens, column_index) {
        Some((after_column, column_token, column_name)) =>
          match state.tables.get(table_name) {
            Some(table) =>
              match table.columns.get(column_name) {
                Some(old_type) => {
                  let type_start = if has_top_level_word(
                      tokens, after_column, "TYPE",
                    ) {
                    match top_level_word(tokens, after_column, "TYPE") {
                      Some(index) => index + 1
                      None => after_column
                    }
                  } else {
                    let data_index = match
                      top_level_word(tokens, after_column, "DATA") {
                      Some(index) => index
                      None => after_column
                    }
                    if data_index + 1 < tokens.length() &&
                      token_is_word(tokens[data_index + 1], "TYPE") {
                      data_index + 2
                    } else {
                      after_column
                    }
                  }
                  let type_parts = []
                  for i in type_start..<tokens.length() {
                    if token_is_word(tokens[i], "USING") ||
                      token_is_word(tokens[i], "DEFAULT") ||
                      token_is_word(tokens[i], "NOT") {
                      break
                    }
                    type_parts.push(tokens[i].text)
                  }
                  let new_type = type_parts.join(" ").to_lower()
                  if !new_type.is_empty() && new_type != old_type {
                    state.tables.remove(table_name)
                    table.columns[column_name] = new_type
                    migration_put_table(state, table)
                    migration_add_change(
                      state,
                      AlterColumnType,
                      table_name,
                      column_name,
                      "from '\{if old_type.is_empty() { "unknown" } else { old_type }}' to '\{new_type}'",
                      path,
                      tokens[column_token],
                      statement_index,
                    )
                    migration_add_finding(
                      state,
                      options,
                      path,
                      tokens,
                      statement_index,
                      column_token,
                      "SQL301",
                      "In-place column type change",
                      Warning,
                      "Column '\{table_name}.\{column_name}' changes type in place.",
                      "Prefer a new column, backfill, dual-write, and a staged cleanup.",
                    )
                  }
                }
                None =>
                  migration_add_finding(
                    state,
                    options,
                    path,
                    tokens,
                    statement_index,
                    column_token,
                    "SQL302",
                    "Migration references a missing schema object",
                    Error,
                    "ALTER COLUMN targets unknown column '\{table_name}.\{column_name}'.",
                    "Correct the column name or reorder prerequisites.",
                  )
              }
            None => ()
          }
        None => ()
      }
    }
    None => ()
  }
  match top_level_word(tokens, after_table, "RENAME") {
    Some(rename_index) =>
      if rename_index + 1 < tokens.length() &&
        token_is_word(tokens[rename_index + 1], "TO") {
        match tokens.length() {
          _ =>
            if rename_index + 2 < tokens.length() {
              migration_rename_table(
                state,
                options,
                path,
                tokens,
                statement_index,
                table_name,
                rename_index + 2,
              )
            }
        }
      } else {
        let old_start = skip_optional_word(tokens, rename_index + 1, "COLUMN")
        match qualified_name_at(tokens, old_start) {
          Some((after_old, _old_token, old_name)) =>
            match top_level_word(tokens, after_old, "TO") {
              Some(to_index) =>
                match qualified_name_at(tokens, to_index + 1) {
                  Some((_, new_token, new_name)) =>
                    migration_rename_column(
                      state, options, path, tokens, statement_index, table_name,
                      old_name, new_name, new_token,
                    )
                  None => ()
                }
              None => ()
            }
          None => ()
        }
      }
    None => ()
  }
}

///|
fn migration_drop_table(
  state : MigrationState,
  options : ScanOptions,
  path : String,
  tokens : Array[Token],
  statement_index : Int,
  drop_index : Int,
) -> Unit {
  let table_index = match top_level_word(tokens, drop_index + 1, "TABLE") {
    Some(index) => index
    None => return
  }
  match
    qualified_name_at(tokens, skip_table_modifiers(tokens, table_index + 1)) {
    Some((_, target_index, table_name)) =>
      match state.tables.get(table_name) {
        Some(_table) => {
          state.tables.remove(table_name)
          migration_add_change(
            state,
            DropTable,
            table_name,
            "",
            "table removed",
            path,
            tokens[target_index],
            statement_index,
          )
        }
        None =>
          if !options.schema.tables.is_empty() || !state.tables.is_empty() {
            migration_add_finding(
              state,
              options,
              path,
              tokens,
              statement_index,
              target_index,
              "SQL302",
              "Migration references a missing schema object",
              Error,
              "DROP TABLE targets unknown table '\{table_name}'.",
              "Correct the table name or migration order.",
            )
          }
      }
    None => ()
  }
}

///|
fn migration_create_table_is_modeled(tokens : Array[Token], main : Int) -> Bool {
  let table_index = match top_level_word(tokens, main + 1, "TABLE") {
    Some(index) => index
    None => return false
  }
  let name_index = skip_table_modifiers(tokens, table_index + 1)
  let after_name = match qualified_name_at(tokens, name_index) {
    Some((after_name, _, _)) => after_name
    None => return false
  }
  let open = match migration_find_symbol(tokens, after_name, "(") {
    Some(index) => index
    None => return false
  }
  match migration_matching_paren(tokens, open) {
    Some(_) => true
    None => false
  }
}

///|
fn migration_create_index_is_modeled(tokens : Array[Token], main : Int) -> Bool {
  let index_keyword = match top_level_word(tokens, main + 1, "INDEX") {
    Some(index) => index
    None => return false
  }
  let after_name = match qualified_name_at(tokens, index_keyword + 1) {
    Some((after_name, _, _)) => after_name
    None => return false
  }
  let on_index = match top_level_word(tokens, after_name, "ON") {
    Some(index) => index
    None => return false
  }
  let after_table = match qualified_name_at(tokens, on_index + 1) {
    Some((after_table, _, _)) => after_table
    None => return false
  }
  let open = match migration_find_symbol(tokens, after_table, "(") {
    Some(index) => index
    None => return false
  }
  match migration_columns_from_paren(tokens, open) {
    Some(_) => true
    None => false
  }
}

///|
fn migration_foreign_key_shape_is_modeled(
  tokens : Array[Token],
  search_start : Int,
) -> Bool {
  let foreign_index = match top_level_word(tokens, search_start, "FOREIGN") {
    Some(index) => index
    None => return false
  }
  let key_index = match top_level_word(tokens, foreign_index + 1, "KEY") {
    Some(index) => index
    None => return false
  }
  let local_open = match migration_find_symbol(tokens, key_index + 1, "(") {
    Some(index) => index
    None => return false
  }
  let local_close = match migration_columns_from_paren(tokens, local_open) {
    Some((close, _)) => close
    None => return false
  }
  let references_index = match
    top_level_word(tokens, local_close + 1, "REFERENCES") {
    Some(index) => index
    None => return false
  }
  let after_table = match qualified_name_at(tokens, references_index + 1) {
    Some((after_table, _, _)) => after_table
    None => return false
  }
  let referenced_open = match migration_find_symbol(tokens, after_table, "(") {
    Some(index) => index
    None => return false
  }
  match migration_columns_from_paren(tokens, referenced_open) {
    Some(_) => true
    None => false
  }
}

///|
fn migration_alter_operation(
  tokens : Array[Token],
  start : Int,
) -> (Int, String)? {
  let mut depth = 0
  for i in start..<tokens.length() {
    let token = tokens[i]
    if token_is_symbol(token, "(") {
      depth = depth + 1
    } else if token_is_symbol(token, ")") {
      if depth > 0 {
        depth = depth - 1
      }
    } else if depth == 0 && token.kind == Word {
      if token.value == "ADD" ||
        token.value == "DROP" ||
        token.value == "ALTER" ||
        token.value == "RENAME" {
        return Some((i, token.value))
      }
    }
  }
  None
}

///|
fn migration_alter_trace_kind(
  tokens : Array[Token],
  main : Int,
) -> (String, Bool, String) {
  let table_index = match top_level_word(tokens, main + 1, "TABLE") {
    Some(index) => index
    None =>
      return (
        "unmodeled", false, "ALTER without TABLE is outside the migration grammar",
      )
  }
  let after_table = match
    qualified_name_at(tokens, skip_table_modifiers(tokens, table_index + 1)) {
    Some((after_table, _, _)) => after_table
    None => return ("unmodeled", false, "ALTER TABLE has no target table")
  }
  let (operation_index, operation) = match
    migration_alter_operation(tokens, after_table) {
    Some(value) => value
    None => return ("unmodeled", false, "ALTER TABLE has no modeled operation")
  }
  match operation {
    "ADD" => {
      let after_add = skip_optional_word(tokens, operation_index + 1, "COLUMN")
      if has_top_level_word(tokens, operation_index + 1, "CONSTRAINT") ||
        has_top_level_word(tokens, operation_index + 1, "FOREIGN") {
        if migration_foreign_key_shape_is_modeled(tokens, operation_index + 1) {
          ("add_foreign_key", true, "ADD FOREIGN KEY grammar matched")
        } else {
          (
            "unmodeled", false, "ADD foreign-key clause does not match the supported grammar",
          )
        }
      } else {
        let definition_end = match
          top_level_word(tokens, after_add, "CASCADE") {
          Some(index) => index
          None => tokens.length()
        }
        match
          migration_parse_column_definition(
            tokens[after_add:definition_end].to_owned(),
          ) {
          Some(_) =>
            ("add_column", true, "ADD COLUMN definition grammar matched")
          None =>
            (
              "unmodeled", false, "ALTER TABLE ADD does not match a column or foreign-key grammar",
            )
        }
      }
    }
    "DROP" =>
      if top_level_word(tokens, operation_index + 1, "CONSTRAINT") is Some(_) {
        (
          "unmodeled", false, "DROP CONSTRAINT is outside the supported migration grammar",
        )
      } else {
        let column_start = skip_optional_word(
          tokens,
          operation_index + 1,
          "COLUMN",
        )
        match qualified_name_at(tokens, column_start) {
          Some(_) => ("drop_column", true, "DROP COLUMN grammar matched")
          None =>
            (
              "unmodeled", false, "ALTER TABLE DROP has no modeled column target",
            )
        }
      }
    "ALTER" => {
      let column_start = skip_optional_word(
        tokens,
        operation_index + 1,
        "COLUMN",
      )
      let after_column = match qualified_name_at(tokens, column_start) {
        Some((after_column, _, _)) => after_column
        None => return ("unmodeled", false, "ALTER COLUMN has no target column")
      }
      let has_type = has_top_level_word(tokens, after_column, "TYPE")
      let has_data_type = has_top_level_word(tokens, after_column, "DATA") &&
        has_top_level_word(tokens, after_column, "TYPE")
      if has_type || has_data_type {
        ("alter_column_type", true, "ALTER COLUMN TYPE grammar matched")
      } else {
        (
          "unmodeled", false, "ALTER COLUMN without TYPE is outside the supported grammar",
        )
      }
    }
    "RENAME" =>
      if operation_index + 1 < tokens.length() &&
        token_is_word(tokens[operation_index + 1], "TO") {
        if operation_index + 2 < tokens.length() {
          ("rename_table", true, "RENAME TABLE TO grammar matched")
        } else {
          ("unmodeled", false, "RENAME TABLE has no new table name")
        }
      } else {
        let old_start = skip_optional_word(
          tokens,
          operation_index + 1,
          "COLUMN",
        )
        let after_old = match qualified_name_at(tokens, old_start) {
          Some((after_old, _, _)) => after_old
          None =>
            return ("unmodeled", false, "RENAME COLUMN has no old column name")
        }
        match top_level_word(tokens, after_old, "TO") {
          Some(to_index) =>
            match qualified_name_at(tokens, to_index + 1) {
              Some(_) =>
                (
                  "rename_column", true, "RENAME COLUMN old TO new grammar matched",
                )
              None =>
                ("unmodeled", false, "RENAME COLUMN has no new column name")
            }
          None =>
            (
              "unmodeled", false, "ALTER TABLE RENAME does not match a supported rename form",
            )
        }
      }
    _ => ("unmodeled", false, "unknown ALTER TABLE operation")
  }
}

///|
fn migration_statement_trace_kind(
  tokens : Array[Token],
) -> (String, Bool, String) {
  let main = match main_keyword_index(tokens) {
    Some(index) => index
    None =>
      return (
        tokens[0].value.to_lower(),
        false,
        "statement root '\{tokens[0].value}' is outside the supported migration grammar",
      )
  }
  match tokens[main].value {
    "CREATE" =>
      if has_top_level_word(tokens, main + 1, "TABLE") {
        if migration_create_table_is_modeled(tokens, main) {
          ("create_table", true, "CREATE TABLE grammar matched")
        } else {
          (
            "unmodeled", false, "CREATE TABLE does not match the supported grammar",
          )
        }
      } else if has_top_level_word(tokens, main + 1, "INDEX") {
        if migration_create_index_is_modeled(tokens, main) {
          ("create_index", true, "CREATE INDEX grammar matched")
        } else {
          (
            "unmodeled", false, "CREATE INDEX does not match the supported grammar",
          )
        }
      } else {
        (
          "unmodeled", false, "CREATE statement is outside the supported migration grammar",
        )
      }
    "ALTER" => migration_alter_trace_kind(tokens, main)
    "DROP" =>
      match top_level_word(tokens, main + 1, "TABLE") {
        Some(table_index) =>
          match
            qualified_name_at(
              tokens,
              skip_table_modifiers(tokens, table_index + 1),
            ) {
            Some(_) => ("drop_table", true, "DROP TABLE grammar matched")
            None => ("unmodeled", false, "DROP TABLE has no target table")
          }
        None =>
          (
            "unmodeled", false, "DROP statement is outside the supported migration grammar",
          )
      }
    _ =>
      (
        "unmodeled", false, "statement root is outside the supported migration grammar",
      )
  }
}

///|
fn migration_statement_trace(
  path : String,
  statement_index : Int,
  tokens : Array[Token],
) -> StatementTrace {
  let (kind, analyzed, reason) = migration_statement_trace_kind(tokens)
  let first = tokens[0]
  let last = tokens[tokens.length() - 1]
  {
    path,
    statement_index,
    line: first.line,
    end_line: last.line,
    token_count: tokens.length(),
    kind,
    status: if analyzed {
      Analyzed
    } else {
      Ignored
    },
    reason,
  }
}

///|
fn migration_sorted_names(
  tables : Map[String, MigrationTableState],
) -> Array[String] {
  let names = []
  for _, table in tables {
    names.push(table.name)
  }
  names.sort()
  names
}

///|
fn migration_affected_tables(changes : Array[SchemaChange]) -> Array[String] {
  let tables = []
  for change in changes {
    if !tables.contains(change.table_name) {
      tables.push(change.table_name)
    }
  }
  tables.sort()
  tables
}

///|
fn migration_breaking_changes(changes : Array[SchemaChange]) -> Int {
  let mut count = 0
  for change in changes {
    match change.kind {
      DropTable | DropColumn | AlterColumnType | RenameTable | RenameColumn =>
        count = count + 1
      _ => ()
    }
  }
  count
}

///|
fn migration_count_findings(
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
/// Analyze an ordered SQL migration set while maintaining an evolving schema.
pub fn analyze_migrations(
  inputs : Array[MigrationInput],
  options : ScanOptions,
) -> MigrationAnalysis {
  let tables : Map[String, MigrationTableState] = Map([])
  for table in options.schema.tables {
    let columns : Map[String, String] = Map([])
    for column in table.columns {
      columns[column.name.to_lower()] = ""
    }
    let indexes = []
    for index in table.indexes {
      indexes.push(index.columns.map(column => column.to_lower()))
    }
    let foreign_keys = []
    for foreign_key in table.foreign_keys {
      foreign_keys.push({
        columns: foreign_key.columns.map(column => column.to_lower()),
        references_table: foreign_key.references_table.to_lower(),
        references_columns: foreign_key.references_columns.map(column => {
          column.to_lower()
        }),
      })
    }
    tables[table.name.to_lower()] = {
      name: table.name.to_lower(),
      columns,
      indexes,
      foreign_keys,
    }
  }
  let tables_before = migration_sorted_names(tables)
  let state = { tables, changes: [], findings: [], traces: [], }
  for input in inputs {
    let tokens = tokenize(input.source)
    let statements = split_statements(tokens)
    let mut index = 0
    for statement in statements {
      let statement_index = index + 1
      let trace = migration_statement_trace(
        input.path,
        statement_index,
        statement,
      )
      state.traces.push(trace)
      if trace.status == Analyzed {
        match main_keyword_index(statement) {
          Some(main_index) =>
            match statement[main_index].value {
              "CREATE" =>
                if has_top_level_word(statement, main_index + 1, "TABLE") {
                  migration_create_table(
                    state,
                    options,
                    input.path,
                    statement,
                    statement_index,
                    main_index,
                  )
                } else if has_top_level_word(statement, main_index + 1, "INDEX") {
                  migration_create_index(
                    state,
                    options,
                    input.path,
                    statement,
                    statement_index,
                    main_index,
                  )
                }
              "ALTER" =>
                migration_alter_table(
                  state,
                  options,
                  input.path,
                  statement,
                  statement_index,
                  main_index,
                )
              "DROP" =>
                migration_drop_table(
                  state,
                  options,
                  input.path,
                  statement,
                  statement_index,
                  main_index,
                )
              _ => ()
            }
          None => ()
        }
      }
      index = index + 1
    }
  }
  let tables_after = migration_sorted_names(state.tables)
  let changes = state.changes.copy()
  let findings = state.findings.copy()
  let traces = state.traces.copy()
  let analyzed_count = traces.filter(trace => trace.status == Analyzed).length()
  let ignored_count = traces.length() - analyzed_count
  {
    changes,
    findings,
    tables_before,
    tables_after,
    affected_tables: migration_affected_tables(changes),
    breaking_changes: migration_breaking_changes(changes),
    error_count: migration_count_findings(findings, Error),
    warning_count: migration_count_findings(findings, Warning),
    info_count: migration_count_findings(findings, Info),
    coverage: {
      statement_count: traces.length(),
      analyzed_count,
      ignored_count,
      traces,
    },
  }
}
