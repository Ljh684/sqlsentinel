///|
priv suberror SchemaLoadError {
  SchemaLoadError(String)
}

///|
fn schema_error(path : String, message : String) -> String {
  "invalid schema '\{path}': \{message}"
}

///|
fn[T] fail_schema(path : String, message : String) -> T raise SchemaLoadError {
  raise SchemaLoadError(schema_error(path, message))
}

///|
fn schema_required_string(
  object : Map[String, Json],
  key : String,
  path : String,
) -> String raise SchemaLoadError {
  match object.get(key) {
    Some(Json::String(value)) =>
      if value.trim().is_empty() {
        fail_schema(path, "'\{key}' cannot be empty")
      } else {
        value
      }
    Some(_) => fail_schema(path, "'\{key}' must be a string")
    None => fail_schema(path, "missing required field '\{key}'")
  }
}

///|
fn schema_optional_string(
  object : Map[String, Json],
  key : String,
  path : String,
) -> String? raise SchemaLoadError {
  match object.get(key) {
    Some(Json::String(value)) => Some(value)
    Some(_) => fail_schema(path, "'\{key}' must be a string")
    None => None
  }
}

///|
fn schema_optional_bool(
  object : Map[String, Json],
  key : String,
  default : Bool,
  path : String,
) -> Bool raise SchemaLoadError {
  match object.get(key) {
    Some(Json::True) => true
    Some(Json::False) => false
    Some(_) => fail_schema(path, "'\{key}' must be a boolean")
    None => default
  }
}

///|
fn schema_string_array(
  object : Map[String, Json],
  key : String,
  path : String,
) -> Array[String] raise SchemaLoadError {
  match object.get(key) {
    Some(Json::Array(items)) =>
      if items.is_empty() {
        fail_schema(path, "'\{key}' cannot be empty")
      } else {
        let values = []
        for item in items {
          match item {
            Json::String(value) =>
              if value.trim().is_empty() {
                fail_schema(path, "'\{key}' contains an empty name")
              } else {
                values.push(value)
              }
            _ => fail_schema(path, "'\{key}' must contain strings")
          }
        }
        values
      }
    Some(_) => fail_schema(path, "'\{key}' must be an array")
    None => fail_schema(path, "missing required field '\{key}'")
  }
}

///|
fn schema_object(
  value : Json,
  context : String,
  path : String,
) -> Map[String, Json] raise SchemaLoadError {
  match value {
    Json::Object(object) => object
    _ => fail_schema(path, "\{context} must be an object")
  }
}

///|
fn schema_array(
  object : Map[String, Json],
  key : String,
  required : Bool,
  path : String,
) -> Array[Json] raise SchemaLoadError {
  match object.get(key) {
    Some(Json::Array(items)) => items
    Some(_) => fail_schema(path, "'\{key}' must be an array")
    None =>
      if required {
        fail_schema(path, "missing required field '\{key}'")
      } else {
        []
      }
  }
}

///|
fn parse_schema_column(
  value : Json,
  path : String,
) -> @lib.SchemaColumn raise SchemaLoadError {
  let object = schema_object(value, "column", path)
  let name = schema_required_string(object, "name", path)
  let nullable = schema_optional_bool(object, "nullable", false, path)
  { name, nullable, }
}

///|
fn parse_schema_index(
  value : Json,
  table_name : String,
  index : Int,
  path : String,
) -> @lib.SchemaIndex raise SchemaLoadError {
  let object = schema_object(value, "index", path)
  let name = match schema_optional_string(object, "name", path) {
    Some(name) => name
    None => "idx_\{table_name}_\{index}"
  }
  let columns = schema_string_array(object, "columns", path)
  let unique = schema_optional_bool(object, "unique", false, path)
  { name, columns, unique, }
}

///|
fn parse_schema_foreign_key(
  value : Json,
  table_name : String,
  index : Int,
  path : String,
) -> @lib.SchemaForeignKey raise SchemaLoadError {
  let object = schema_object(value, "foreign key", path)
  let name = match schema_optional_string(object, "name", path) {
    Some(name) => name
    None => "fk_\{table_name}_\{index}"
  }
  let columns = schema_string_array(object, "columns", path)
  let references = match object.get("references") {
    Some(value) => schema_object(value, "foreign-key references", path)
    None => fail_schema(path, "foreign key is missing 'references'")
  }
  let references_table = schema_required_string(references, "table", path)
  let references_columns = schema_string_array(references, "columns", path)
  { name, columns, references_table, references_columns, }
}

///|
fn parse_schema_table(
  value : Json,
  path : String,
) -> @lib.SchemaTable raise SchemaLoadError {
  let object = schema_object(value, "table", path)
  let name = schema_required_string(object, "name", path)
  let columns_json = schema_array(object, "columns", true, path)
  let columns = []
  for column in columns_json {
    columns.push(parse_schema_column(column, path))
  }
  let indexes_json = schema_array(object, "indexes", false, path)
  let indexes = []
  for index, value in indexes_json {
    indexes.push(parse_schema_index(value, name, index + 1, path))
  }
  let foreign_keys_json = schema_array(object, "foreignKeys", false, path)
  let foreign_keys = []
  for index, value in foreign_keys_json {
    foreign_keys.push(parse_schema_foreign_key(value, name, index + 1, path))
  }
  { name, columns, indexes, foreign_keys, }
}

///|
fn validate_schema(
  catalog : @lib.SchemaCatalog,
  path : String,
) -> @lib.SchemaCatalog raise SchemaLoadError {
  if catalog.tables.is_empty() {
    fail_schema(path, "'tables' cannot be empty")
  }
  let table_names = []
  for table in catalog.tables {
    let table_key = table.name.to_lower()
    if table_names.contains(table_key) {
      fail_schema(path, "duplicate table '\{table.name}'")
    }
    table_names.push(table_key)
    if table.columns.is_empty() {
      fail_schema(
        path,
        "table '\{table.name}' must declare at least one column",
      )
    }
    let column_names = []
    for column in table.columns {
      let column_key = column.name.to_lower()
      if column_names.contains(column_key) {
        fail_schema(path, "duplicate column '\{table.name}.\{column.name}'")
      }
      column_names.push(column_key)
    }
    let index_names = []
    for index in table.indexes {
      let index_key = index.name.to_lower()
      if index_names.contains(index_key) {
        fail_schema(path, "duplicate index '\{table.name}.\{index.name}'")
      }
      index_names.push(index_key)
      let indexed_columns = []
      for column in index.columns {
        if !table.has_column(column) {
          fail_schema(
            path,
            "index '\{index.name}' references unknown column '\{table.name}.\{column}'",
          )
        }
        let column_key = column.to_lower()
        if indexed_columns.contains(column_key) {
          fail_schema(
            path,
            "index '\{index.name}' repeats column '\{table.name}.\{column}'",
          )
        }
        indexed_columns.push(column_key)
      }
    }
    let foreign_key_names = []
    for foreign_key in table.foreign_keys {
      let foreign_key_key = foreign_key.name.to_lower()
      if foreign_key_names.contains(foreign_key_key) {
        fail_schema(
          path,
          "duplicate foreign key '\{table.name}.\{foreign_key.name}'",
        )
      }
      foreign_key_names.push(foreign_key_key)
      for column in foreign_key.columns {
        if !table.has_column(column) {
          fail_schema(
            path,
            "foreign key '\{foreign_key.name}' references unknown column '\{table.name}.\{column}'",
          )
        }
      }
      if foreign_key.columns.length() != foreign_key.references_columns.length() {
        fail_schema(
          path,
          "foreign key '\{foreign_key.name}' must have the same number of local and referenced columns",
        )
      }
    }
  }
  for table in catalog.tables {
    for foreign_key in table.foreign_keys {
      match catalog.find_table(foreign_key.references_table) {
        None =>
          fail_schema(
            path,
            "foreign key '\{foreign_key.name}' references unknown table '\{foreign_key.references_table}'",
          )
        Some(target) =>
          for column in foreign_key.references_columns {
            if !target.has_column(column) {
              fail_schema(
                path,
                "foreign key '\{foreign_key.name}' references unknown column '\{target.name}.\{column}'",
              )
            }
          }
      }
    }
  }
  catalog
}

///|
fn parse_schema_json(
  text : String,
  path : String,
) -> Result[@lib.SchemaCatalog, String] {
  let parsed = @json.parse(text) catch {
    error => return Err(schema_error(path, "JSON parse error: \{error}"))
  }
  try {
    let root = schema_object(parsed, "top-level value", path)
    let tables_json = schema_array(root, "tables", true, path)
    let tables = []
    for table in tables_json {
      tables.push(parse_schema_table(table, path))
    }
    Ok(validate_schema(@lib.SchemaCatalog::{ tables, }, path))
  } catch {
    SchemaLoadError(message) => Err(message)
  }
}

///|
fn load_schema(path : String) -> Result[@lib.SchemaCatalog, String] {
  let text = @fs.read_file_to_string(path) catch {
    @fs.IOError(message) =>
      return Err("cannot read schema '\{path}': \{message}")
  }
  parse_schema_json(text, path)
}
