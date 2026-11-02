///|
test "lexer handles quoted identifiers and escaped strings" {
  let tokens = tokenize("SELECT \"select\", `x;y`, [a b], 'it''s;ok';")
  assert_eq(tokens.length(), 9)
  assert_eq(tokens[1].value, "select")
  assert_eq(tokens[3].value, "x;y")
  assert_eq(tokens[5].value, "a b")
  assert_eq(tokens[7].value, "it's;ok")
}

///|
test "statement splitter ignores semicolon-like punctuation in strings" {
  let statements = split_statements(
    tokenize("SELECT ';'; SELECT \"a;b\"; SELECT 1;"),
  )
  assert_eq(statements.length(), 3)
}

///|
test "postgres json path operator is not treated as a hash comment" {
  let tokens = tokenize("SELECT data #>> '{profile,name}' FROM events;")
  assert_true(tokens.any(token => token.text == "#>"))
  assert_eq(split_statements(tokens).length(), 1)
}
