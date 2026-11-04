///|
test "schema parser extracts destructive table target" {
  let tokens = split_statements(tokenize("DELETE FROM users WHERE id = 1;"))[0]
  let main = main_keyword_index(tokens).unwrap()
  match destructive_target(tokens, main, "DELETE") {
    Some((_, _, name)) => assert_eq(name, "users")
    None => fail("expected table target")
  }
}

///|
test "schema parser extracts dropped column" {
  let tokens = split_statements(
      tokenize("ALTER TABLE users DROP COLUMN email;"),
    )[0]
  let main = main_keyword_index(tokens).unwrap()
  match dropped_column(tokens, main) {
    Some((_, column_index, table, column)) => {
      assert_eq(table, "users")
      assert_eq(column, "email")
      assert_eq(tokens[column_index].value.to_lower(), "email")
    }
    None => fail("expected dropped column")
  }
}
