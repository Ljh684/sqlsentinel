///|
priv enum InputKind {
  Directory
  File
  Other
  Failed(String)
}

///|
priv struct DiscoveryResult {
  files : Array[String]
  errors : Array[String]
}

///|
fn input_kind(path : String) -> InputKind {
  if !@fs.path_exists(path) {
    return Other
  }
  let is_directory = @fs.is_dir(path) catch {
    @fs.IOError(message) => return Failed(message)
  }
  if is_directory {
    return Directory
  }
  let is_file = @fs.is_file(path) catch {
    @fs.IOError(message) => return Failed(message)
  }
  if is_file {
    File
  } else {
    Other
  }
}

///|
fn is_sql_file(path : String) -> Bool {
  @path.Path(path).extname().to_lower() == ".sql"
}

///|
fn should_skip_directory(name : String) -> Bool {
  match name.to_lower() {
    ".git" | "_build" | ".mooncakes" | "node_modules" | "target" => true
    _ => false
  }
}

///|
fn directory_key(path : String) -> String {
  @path.Path(path).resolve().normalize().to_string().to_lower()
}

///|
fn compare_paths(a : String, b : String) -> Int {
  let shared_length = if a.length() < b.length() {
    a.length()
  } else {
    b.length()
  }
  for i in 0..<shared_length {
    let order = a.unsafe_get(i).compare(b.unsafe_get(i))
    if order != 0 {
      return order
    }
  }
  a.length().compare(b.length())
}

///|
fn discover_directory(
  directory : String,
  files : Array[String],
  errors : Array[String],
  seen_directories : Array[String],
) -> Int {
  let key = directory_key(directory)
  if seen_directories.contains(key) {
    return 0
  }
  seen_directories.push(key)

  let entries = @fs.read_dir(directory) catch {
    @fs.IOError(message) => {
      errors.push("cannot read directory \{directory}: \{message}")
      return 0
    }
  }
  let sorted_entries = entries.to_owned()
  sorted_entries.sort_by(compare_paths)
  let mut count = 0
  for name in sorted_entries {
    let full_path = @path.Path(directory).join(@path.Path(name)).to_string()
    match input_kind(full_path) {
      Directory =>
        if !should_skip_directory(name) {
          count = count +
            discover_directory(full_path, files, errors, seen_directories)
        }
      File =>
        if is_sql_file(full_path) {
          files.push(full_path)
          count = count + 1
        }
      Other => ()
      Failed(message) =>
        errors.push("cannot inspect '\{full_path}': \{message}")
    }
  }
  count
}

///|
fn discover_input(
  path : String,
  files : Array[String],
  errors : Array[String],
  seen_directories : Array[String],
) -> Unit {
  match input_kind(path) {
    Directory => {
      if seen_directories.contains(directory_key(path)) {
        return
      }
      let count = discover_directory(path, files, errors, seen_directories)
      if count == 0 {
        errors.push("no .sql files found under directory '\{path}'")
      }
    }
    File => files.push(path)
    Other =>
      errors.push(
        "input path does not exist or is not a file/directory: \{path}",
      )
    Failed(message) => errors.push("cannot inspect '\{path}': \{message}")
  }
}

///|
fn discover_inputs(paths : Array[String]) -> DiscoveryResult {
  let candidates = []
  let errors = []
  let seen_directories = []
  for path in paths {
    discover_input(path, candidates, errors, seen_directories)
  }
  candidates.sort_by(compare_paths)

  let files = []
  let seen_files = []
  for path in candidates {
    let key = @path.Path(path).normalize().to_string().to_lower()
    if !seen_files.contains(key) {
      seen_files.push(key)
      files.push(path)
    }
  }
  { files, errors, }
}
