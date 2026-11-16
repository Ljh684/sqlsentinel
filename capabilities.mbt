///|
/// Describe the analysis stages and their intentional semantic boundaries.
pub fn analysis_capabilities_markdown() -> String {
  (
    #|# SQLSentinel analysis model
    #|
    #|SQLSentinel uses a bounded semantic model. It does not claim a complete SQL
    #|parser or a live database schema engine. Rules operate on typed intermediate
    #|state, not regular expressions over the raw source.
    #|
    #|## Pipeline
    #|
    #|1. **Lexer**: strings, quoted identifiers, comments, dollar-quoted bodies,
    #|   directives, and symbols become typed tokens.
    #|2. **Statement splitter**: only top-level semicolons separate statements.
    #|3. **Structural DDL parser**: recognizes the documented table, column, index,
    #|   foreign-key, type-change, and rename grammar.
    #|4. **Schema reducer**: applies recognized DDL to an ordered in-memory schema
    #|   state with explicit before/after transitions.
    #|5. **Reference analyzer**: correlates changed tables and columns with query
    #|   source references using conservative table/column matching.
    #|6. **Policy engine**: applies suppression, baselines, severity overrides, and
    #|   fail thresholds to typed findings.
    #|
    #|## Coverage
    #|
    #|Supported:
    #|
    #|- CREATE/DROP TABLE;
    #|- ADD/DROP COLUMN;
    #|- ALTER COLUMN type;
    #|- RENAME TABLE/COLUMN;
    #|- CREATE INDEX;
    #|- ADD FOREIGN KEY;
    #|- top-level SELECT/UPDATE/DELETE/INSERT table references.
    #|
    #|Conservative:
    #|
    #|- query aliases and nested queries;
    #|- quoted/case-insensitive identifiers;
    #|- schema initialization from an external JSON catalog.
    #|
    #|Not modeled:
    #|
    #|- procedural blocks and dynamic SQL;
    #|- arbitrary expressions and query-plan semantics;
    #|- database execution, locks, data volume, or live introspection;
    #|- schema objects outside the documented DDL subset.
    #|
    #|Unsupported constructs are ignored rather than guessed. This keeps false
    #|confidence low and makes every claimed transition explainable.
  )
}
