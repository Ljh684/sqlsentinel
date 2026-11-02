///|
test "git comparison refs allow revisions and ranges but reject shell syntax" {
  assert_true(valid_git_ref("HEAD"))
  assert_true(valid_git_ref("origin/main...HEAD"))
  assert_true(valid_git_ref("v1.2.3^"))
  assert_true(valid_git_ref("abc123"))
  assert_false(valid_git_ref(""))
  assert_false(valid_git_ref("HEAD; whoami"))
  assert_false(valid_git_ref("HEAD --output=x"))
  assert_false(valid_git_ref("$(whoami)"))
  assert_false(valid_git_ref("--output=/tmp/pwned"))
}

///|
#cfg(target="native")
test "changed-file output keeps existing SQL paths only" {
  let sql_path = "_build/sqlsentinel_changed_filter.SQL"
  let text_path = "_build/sqlsentinel_changed_filter.txt"
  @fs.write_string_to_file(sql_path, "SELECT 1;")
  @fs.write_string_to_file(text_path, "not SQL")
  let paths = sql_paths_from_diff("\{sql_path}\r\n\{text_path}\nmissing.sql\n")
  assert_eq(paths.length(), 1)
  assert_eq(paths[0], sql_path)
  @fs.remove_file(sql_path)
  @fs.remove_file(text_path)
}
