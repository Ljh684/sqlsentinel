# Analysis model and semantic boundaries

## Direct answer

SQLSentinel does **not** implement a complete SQL grammar, SQL planner, or live
database schema engine. It uses a **bounded semantic model**:

- lexical context is parsed rather than regex-matched;
- supported DDL is converted into typed operations;
- those operations are applied to an ordered in-memory schema state;
- rules inspect the resulting state transitions and typed findings;
- unsupported syntax is ignored rather than guessed.

The keyword vocabulary in the DDL parser is part of the supported grammar. It is
not a collection of project-specific string workarounds.

## Pipeline

```text
source
  -> context-aware lexer
  -> top-level statement splitter
  -> structural DDL/query parser
  -> typed schema transitions + query references
  -> policy evaluation
  -> text / JSON / Markdown / SARIF / review packet
```

### 1. Lexer

The lexer distinguishes words, numbers, symbols, string literals, quoted
identifiers, directives, line comments, nested block comments, and PostgreSQL
dollar-quoted bodies. Semicolons and keywords inside these regions do not become
statements.

### 2. Statement parser

Statements are split only at top-level semicolons. DDL handlers use token order,
bracket depth, qualified names, and bounded comma-separated segments. They do
not scan the raw source with regular expressions.

Supported DDL:

- `CREATE TABLE`, `DROP TABLE`;
- `ADD/DROP COLUMN`;
- `ALTER COLUMN ... TYPE` / `SET DATA TYPE`;
- MySQL `MODIFY COLUMN` / `CHANGE COLUMN`;
- `RENAME TABLE/COLUMN`;
- `CREATE INDEX`;
- `ADD FOREIGN KEY`.

### 3. Schema reducer

The reducer starts from an optional JSON schema catalog. Recognized DDL updates
table, column-type, index, foreign-key, and rename state in order. Findings are
emitted from state transitions or failed lookups, for example:

- type change on a known column -> SQL301;
- unknown table/column reference -> SQL302;
- foreign key without a matching index prefix -> SQL303;
- rename of an existing object -> SQL304.

Every consumed statement also receives a `StatementTrace`. It records the
source span, token count, matched grammar branch, and either `analyzed` or
`ignored` with a reason. This makes parser coverage observable and prevents
unsupported syntax from disappearing without notice. Plan, impact, and review
JSON are machine-readable evidence for the same traces.

### 4. Query reference analysis

Query files are tokenized with the same lexer. Table references after
`FROM/JOIN/UPDATE/INTO` are correlated with migration changes. Column-sensitive
changes additionally require the changed column identifier. This layer is
deliberately conservative and does not claim full alias/CTE/expression
resolution.

### 5. Policy

Only after typed findings exist do baselines, suppression, severity overrides,
failure thresholds, and report rendering run.

## Precision levels

| Layer | Claim |
| --- | --- |
| Lexical context | exact within supported lexical forms |
| Statement splitting | exact for top-level semicolons |
| Supported DDL transitions | exact within the documented grammar |
| Query impact references | conservative, source-level |
| Full SQL semantics | not claimed |

## Unsupported behavior

Procedural blocks, dynamic SQL, arbitrary expression semantics, live database
introspection, lock behavior, and query plans are not modeled. Unsupported
constructs do not produce invented schema claims.

`--require-full-coverage` turns any ignored migration statement into a failing
CI result for plan, impact, or review output. Teams can therefore choose between
transparent partial coverage and a strict supported-grammar boundary.

Run:

```bash
moon run --target native cmd/main -- --capabilities
```

Machine-readable plan, impact, and review outputs also include an
`analysis_model` object with mode, confidence, pipeline, and unsupported layers.
