///|
test "shared schema parser handles tables, indexes, and foreign keys" {
  let text =
    #|{
    #|  "tables": [
    #|    {
    #|      "name": "users",
    #|      "columns": [
    #|        {"name": "id", "nullable": false},
    #|        {"name": "email", "nullable": false}
    #|      ],
    #|      "indexes": [
    #|        {"name": "users_email", "columns": ["email"], "unique": true}
    #|      ]
    #|    },
    #|    {
    #|      "name": "orders",
    #|      "columns": [
    #|        {"name": "id", "nullable": false},
    #|        {"name": "user_id", "nullable": false}
    #|      ],
    #|      "foreignKeys": [
    #|        {
    #|          "columns": ["user_id"],
    #|          "references": {"table": "users", "columns": ["id"]}
    #|        }
    #|      ]
    #|    }
    #|  ]
    #|}
  match parse_schema_json(text, "schema.json") {
    Ok(schema) => {
      assert_eq(schema.tables.length(), 2)
      let users = schema.find_table("USERS").unwrap()
      assert_eq(users.indexes.length(), 1)
      let orders = schema.find_table("orders").unwrap()
      assert_eq(orders.foreign_keys[0].references_table, "users")
    }
    Err(message) => fail(message)
  }
}

///|
test "schema JSON rejects broken foreign-key references" {
  let text =
    #|{
    #|  "tables": [
    #|    {
    #|      "name": "orders",
    #|      "columns": [{"name": "user_id"}],
    #|      "foreignKeys": [
    #|        {
    #|          "columns": ["user_id"],
    #|          "references": {"table": "users", "columns": ["id"]}
    #|        }
    #|      ]
    #|    }
    #|  ]
    #|}
  match parse_schema_json(text, "schema.json") {
    Ok(_) => fail("expected unknown referenced table")
    Err(message) => assert_true(message.contains("unknown table 'users'"))
  }
}

///|
test "schema JSON rejects empty catalogs and tables" {
  match parse_schema_json("{\"tables\": []}", "schema.json") {
    Ok(_) => fail("expected an empty-catalog error")
    Err(message) => assert_true(message.contains("'tables' cannot be empty"))
  }
  let empty_table =
    #|{"tables": [{"name": "users", "columns": []}]}
  match parse_schema_json(empty_table, "schema.json") {
    Ok(_) => fail("expected an empty-table error")
    Err(message) =>
      assert_true(message.contains("must declare at least one column"))
  }
}

///|
test "schema JSON validates composite foreign-key shape" {
  let text =
    #|{
    #|  "tables": [
    #|    {
    #|      "name": "accounts",
    #|      "columns": [
    #|        {"name": "tenant_id"},
    #|        {"name": "id"}
    #|      ]
    #|    },
    #|    {
    #|      "name": "ledger",
    #|      "columns": [
    #|        {"name": "tenant_id"},
    #|        {"name": "account_id"}
    #|      ],
    #|      "foreignKeys": [
    #|        {
    #|          "columns": ["tenant_id", "account_id"],
    #|          "references": {"table": "accounts", "columns": ["id"]}
    #|        }
    #|      ]
    #|    }
    #|  ]
    #|}
  match parse_schema_json(text, "schema.json") {
    Ok(_) => fail("expected a composite foreign-key error")
    Err(message) =>
      assert_true(
        message.contains("same number of local and referenced columns"),
      )
  }
}

///|
test "schema JSON rejects duplicate object names" {
  let text =
    #|{
    #|  "tables": [
    #|    {
    #|      "name": "users",
    #|      "columns": [{"name": "email"}],
    #|      "indexes": [
    #|        {"name": "email_idx", "columns": ["email"]},
    #|        {"name": "EMAIL_IDX", "columns": ["email"]}
    #|      ]
    #|    }
    #|  ]
    #|}
  match parse_schema_json(text, "schema.json") {
    Ok(_) => fail("expected a duplicate-index error")
    Err(message) => assert_true(message.contains("duplicate index"))
  }
}
