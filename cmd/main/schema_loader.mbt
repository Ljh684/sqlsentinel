///|
fn load_schema(path : String) -> Result[@lib.SchemaCatalog, String] {
  let text = @fs.read_file_to_string(path) catch {
    @fs.IOError(message) =>
      return Err("cannot read schema '\{path}': \{message}")
  }
  @schema.parse_schema_json(text, path)
}
