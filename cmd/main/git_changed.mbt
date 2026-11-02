///|
fn null_terminated_utf8(value : String) -> Bytes {
  @unicode.to_utf8_bytes(value) + Bytes::make(1, (0).to_byte())
}

///|
fn valid_git_ref(value : String) -> Bool {
  if value.is_empty() {
    return false
  }
  let first = value.get_char(0).unwrap()
  if !(first.is_ascii_alphabetic() || first.is_ascii_digit()) {
    return false
  }
  for ch in value {
    let allowed = ch.is_ascii_alphabetic() ||
      ch.is_ascii_digit() ||
      ch == '_' ||
      ch == '-' ||
      ch == '.' ||
      ch == '/' ||
      ch == '~' ||
      ch == '^' ||
      ch == ':' ||
      ch == '@'
    if !allowed {
      return false
    }
  }
  true
}

///|
fn sql_paths_from_diff(output : String) -> Array[String] {
  let paths = []
  for raw_line in output.split("\n") {
    let path = raw_line.trim().to_owned()
    if path.is_empty() || !is_sql_file(path) {
      continue
    }
    match input_kind(path) {
      File => paths.push(path)
      _ => ()
    }
  }
  paths
}

///|
fn remove_changed_temp_file(path : String) -> Unit {
  @fs.remove_file(path) catch {
    @fs.IOError(_) => ()
  }
}

///|
fn discover_changed_inputs(base : String) -> Result[DiscoveryResult, String] {
  if !valid_git_ref(base) {
    return Err(
      "invalid Git comparison base '\{base}'; only refs, revisions, and ranges are allowed",
    )
  }
  let output_path = ".sqlsentinel-git-diff-\{@env.now()}.txt"
  let status = run_git_diff_command(
    null_terminated_utf8(base),
    null_terminated_utf8(output_path),
  )
  if status != 0 {
    remove_changed_temp_file(output_path)
    return Err(
      "git diff failed for base '\{base}'; ensure Git is installed and this is a Git repository",
    )
  }
  let output = @fs.read_file_to_string(output_path) catch {
    @fs.IOError(message) => {
      remove_changed_temp_file(output_path)
      return Err("cannot read changed-file list: \{message}")
    }
  }
  remove_changed_temp_file(output_path)
  let paths = sql_paths_from_diff(output)
  Ok(discover_inputs(paths))
}
