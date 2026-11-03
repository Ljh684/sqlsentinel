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
fn contains_glob_pattern(path : String) -> Bool {
  path.any(ch => ch == '*' || ch == '?')
}

///|
fn normalize_glob_path(path : String) -> String {
  path.replace_all(old="\\", new="/")
}

///|
fn split_glob_segments(path : String) -> Array[String] {
  let segments = []
  let current = StringBuilder()
  for ch in path {
    if ch == '/' {
      if !current.is_empty() {
        segments.push(current.to_string())
        current.reset()
      }
    } else {
      current.write_char(ch)
    }
  }
  if !current.is_empty() {
    segments.push(current.to_string())
  }
  segments
}

///|
fn match_glob_segment(
  pattern : Array[Char],
  value : Array[Char],
  pattern_start : Int,
  value_start : Int,
) -> Bool {
  let mut pattern_index = pattern_start
  let mut value_index = value_start
  while pattern_index < pattern.length() {
    match pattern[pattern_index] {
      '*' => {
        if match_glob_segment(pattern, value, pattern_index + 1, value_index) {
          return true
        }
        if value_index >= value.length() {
          return false
        }
        value_index = value_index + 1
      }
      '?' =>
        if value_index >= value.length() {
          return false
        } else {
          pattern_index = pattern_index + 1
          value_index = value_index + 1
        }
      expected =>
        if value_index >= value.length() || value[value_index] != expected {
          return false
        } else {
          pattern_index = pattern_index + 1
          value_index = value_index + 1
        }
    }
  }
  value_index == value.length()
}

///|
fn match_glob_segments(
  pattern : Array[String],
  value : Array[String],
  pattern_index : Int,
  value_index : Int,
) -> Bool {
  if pattern_index == pattern.length() {
    return value_index == value.length()
  }
  if pattern[pattern_index] == "**" {
    if pattern_index + 1 == pattern.length() {
      return true
    }
    for next in value_index..<=value.length() {
      if match_glob_segments(pattern, value, pattern_index + 1, next) {
        return true
      }
    }
    return false
  }
  if value_index == value.length() {
    return false
  }
  if !match_glob_segment(
      pattern[pattern_index].to_lower().to_array(),
      value[value_index].to_lower().to_array(),
      0,
      0,
    ) {
    return false
  }
  match_glob_segments(pattern, value, pattern_index + 1, value_index + 1)
}

///|
fn glob_path_matches(pattern : String, path : String) -> Bool {
  let normalized_pattern = split_glob_segments(
    normalize_glob_path(pattern).to_lower(),
  )
  let normalized_path = split_glob_segments(
    normalize_glob_path(path).to_lower(),
  )
  match_glob_segments(normalized_pattern, normalized_path, 0, 0)
}

///|
fn absolute_glob_pattern(pattern : String) -> String {
  if @path.Path(pattern).is_absolute() {
    normalize_glob_path(pattern)
  } else {
    normalize_glob_path(
      @path.Path(".").resolve().join(@path.Path(pattern)).to_string(),
    )
  }
}

///|
fn glob_search_root(pattern : String) -> String {
  let normalized = absolute_glob_pattern(pattern)
  let chars = normalized.to_array()
  let mut first_glob = chars.length()
  for i in 0..<chars.length() {
    if chars[i] == '*' || chars[i] == '?' {
      first_glob = i
      break
    }
  }
  let mut last_separator = 0
  for i in 0..<first_glob {
    if chars[i] == '/' {
      last_separator = i
    }
  }
  @path.Path(String::from_array(chars[0:last_separator + 1]))
  .resolve()
  .to_string()
}

///|
fn glob_display_path(candidate : String, pattern : String) -> String {
  if @path.Path(pattern).is_absolute() {
    candidate
  } else {
    @path.Path(candidate).relative(base=@path.Path(".").resolve()).to_string()
  }
}

///|
fn discover_glob(
  pattern : String,
  files : Array[String],
  errors : Array[String],
) -> Unit {
  let root = glob_search_root(pattern)
  let error_count = errors.length()
  if !@fs.path_exists(root) {
    errors.push("glob search root does not exist: \{root}")
    return
  }
  let candidates = []
  let ignored_directories = []
  ignore(discover_directory(root, candidates, errors, ignored_directories))
  let absolute_pattern = absolute_glob_pattern(pattern)
  let mut match_count = 0
  for candidate in candidates {
    if glob_path_matches(
        absolute_pattern,
        @path.Path(candidate).resolve().to_string(),
      ) {
      files.push(glob_display_path(candidate, pattern))
      match_count = match_count + 1
    }
  }
  if match_count == 0 && errors.length() == error_count {
    errors.push("glob matched no SQL files: \{pattern}")
  }
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
  if contains_glob_pattern(path) {
    discover_glob(path, files, errors)
    return
  }
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
