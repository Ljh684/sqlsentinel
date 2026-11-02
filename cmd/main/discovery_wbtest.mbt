///|
#cfg(target="native")
fn test_join(base : String, child : String) -> String {
  @path.Path(base).join(@path.Path(child)).to_string()
}

///|
#cfg(target="native")
fn remove_test_file(path : String) -> Unit {
  @fs.remove_file(path) catch {
    @fs.IOError(_) => ()
  }
}

///|
#cfg(target="native")
fn remove_test_directory(path : String) -> Unit {
  @fs.remove_dir(path) catch {
    @fs.IOError(_) => ()
  }
}

///|
test "sql extension and skipped directories are classified case insensitively" {
  assert_true(is_sql_file("schema.SQL"))
  assert_true(is_sql_file("migration.sql"))
  assert_false(is_sql_file("schema.sqlx"))
  assert_true(should_skip_directory("_BUILD"))
  assert_true(should_skip_directory(".Git"))
  assert_false(should_skip_directory("migrations"))
}

///|
#cfg(target="native")
test "directory discovery is recursive, sorted, filtered, and deduplicated" {
  let root = "_build/sqlsentinel_discovery_fixture"
  let nested = test_join(root, "nested")
  let deeper = test_join(nested, "deeper")
  let build_dir = test_join(root, "_build")
  let modules_dir = test_join(root, "node_modules")
  let root_sql = test_join(root, "root.sql")
  let nested_sql = test_join(nested, "002.SQL")
  let nested_other = test_join(nested, "notes.txt")
  let deeper_sql = test_join(deeper, "001.sql")
  let skipped_build_sql = test_join(build_dir, "skip.sql")
  let skipped_modules_sql = test_join(modules_dir, "vendor.sql")

  remove_test_file(root_sql)
  remove_test_file(nested_sql)
  remove_test_file(nested_other)
  remove_test_file(deeper_sql)
  remove_test_file(skipped_build_sql)
  remove_test_file(skipped_modules_sql)
  remove_test_directory(deeper)
  remove_test_directory(build_dir)
  remove_test_directory(modules_dir)
  remove_test_directory(nested)
  remove_test_directory(root)

  @fs.create_dir(root)
  @fs.create_dir(nested)
  @fs.create_dir(deeper)
  @fs.create_dir(build_dir)
  @fs.create_dir(modules_dir)
  @fs.write_string_to_file(root_sql, "SELECT 1;")
  @fs.write_string_to_file(nested_sql, "SELECT 2;")
  @fs.write_string_to_file(nested_other, "not SQL")
  @fs.write_string_to_file(deeper_sql, "SELECT 3;")
  @fs.write_string_to_file(skipped_build_sql, "DELETE FROM users;")
  @fs.write_string_to_file(skipped_modules_sql, "DELETE FROM users;")

  let result = discover_inputs([root, root, root_sql])
  assert_eq(result.errors.length(), 0)
  assert_eq(result.files.length(), 3)
  assert_eq(@path.Path(result.files[0]).basename(), "002.SQL")
  assert_eq(@path.Path(result.files[1]).basename(), "001.sql")
  assert_eq(@path.Path(result.files[2]).basename(), "root.sql")

  remove_test_file(root_sql)
  remove_test_file(nested_sql)
  remove_test_file(nested_other)
  remove_test_file(deeper_sql)
  remove_test_file(skipped_build_sql)
  remove_test_file(skipped_modules_sql)
  remove_test_directory(deeper)
  remove_test_directory(build_dir)
  remove_test_directory(modules_dir)
  remove_test_directory(nested)
  remove_test_directory(root)
}

///|
#cfg(target="native")
test "empty directory reports a discovery error" {
  let root = "_build/sqlsentinel_empty_fixture"
  remove_test_directory(root)
  @fs.create_dir(root)
  let result = discover_inputs([root])
  assert_eq(result.files.length(), 0)
  assert_eq(result.errors.length(), 1)
  assert_true(result.errors[0].contains("no .sql files"))
  remove_test_directory(root)
}
