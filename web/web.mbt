///|
fn web_options(dialect_name : String) -> @lib.ScanOptions {
  let dialect = match @lib.Dialect::parse(dialect_name) {
    Some(dialect) => dialect
    None => @lib.Dialect::Auto
  }
  @lib.ScanOptions::new(dialect~)
}

///|
fn web_options_with_schema(
  dialect_name : String,
  schema : @lib.SchemaCatalog,
) -> @lib.ScanOptions {
  let dialect = match @lib.Dialect::parse(dialect_name) {
    Some(dialect) => dialect
    None => @lib.Dialect::Auto
  }
  @lib.ScanOptions::new(dialect~, schema~)
}

///|
fn web_json_string(value : String) -> String {
  let escaped = value
    .replace_all(old="\\", new="\\\\")
    .replace_all(old="\"", new="\\\"")
    .replace_all(old="\r", new="\\r")
    .replace_all(old="\n", new="\\n")
    .replace_all(old="\t", new="\\t")
  "\"\{escaped}\""
}

///|
fn web_error_json(message : String) -> String {
  "{\"ok\":false,\"error\":\{web_json_string(message)}}"
}

///|
/// Export a stable JSON result for the browser playground.
#export_name("scanSqlJson")
pub fn scan_sql_json(sql : String, dialect_name : String) -> String {
  let report = @lib.scan_sql_with(sql, web_options(dialect_name))
  @lib.report_to_json(report)
}

///|
/// Export a Markdown review packet for copy/download in the browser.
#export_name("scanSqlMarkdown")
pub fn scan_sql_markdown(sql : String, dialect_name : String) -> String {
  let report = @lib.scan_sql_with(sql, web_options(dialect_name))
  @lib.report_to_markdown(report, path="playground.sql")
}

///|
/// Run one browser scan and return the report plus its Markdown review packet.
/// An empty schema string keeps schema-aware checks disabled.
#export_name("scanSqlBundle")
pub fn scan_sql_bundle(
  sql : String,
  dialect_name : String,
  schema_json : String,
) -> String {
  let options = if schema_json.trim().is_empty() {
    web_options(dialect_name)
  } else {
    match @schema.parse_schema_json(schema_json, "playground-schema.json") {
      Err(message) => return web_error_json(message)
      Ok(schema) => web_options_with_schema(dialect_name, schema)
    }
  }
  let report = @lib.scan_sql_with(sql, options)
  let report_json = @lib.report_to_json(report)
  let markdown = @lib.report_to_markdown(report, path="playground.sql")
  "{\"ok\":true,\"report\":\{report_json},\"markdown\":\{web_json_string(markdown)}}"
}
