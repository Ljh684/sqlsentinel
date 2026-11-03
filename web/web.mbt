///|
fn web_options(dialect_name : String) -> @lib.ScanOptions {
  let dialect = match @lib.Dialect::parse(dialect_name) {
    Some(dialect) => dialect
    None => @lib.Dialect::Auto
  }
  @lib.ScanOptions::new(dialect~)
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
