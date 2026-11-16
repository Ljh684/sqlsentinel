///|
test "capability report explains bounded semantic model" {
  let text = analysis_capabilities_markdown()
  assert_true(text.contains("# SQLSentinel analysis model"))
  assert_true(text.contains("bounded semant"))
  assert_true(text.contains("Not modeled"))
  assert_true(text.contains("Unsupported constructs are ignored"))
  let analysis = analyze_migrations(
    [MigrationInput::{ path: "db/001.sql", source: "SELECT 1;", }],
    ScanOptions::default(),
  )
  let json = migration_analysis_to_json(analysis)
  assert_true(json.contains("\"mode\": \"bounded_semantic\""))
  assert_true(json.contains("\"confidence\": \"conservative\""))
  assert_true(json.contains("\"procedural_blocks\""))
}
