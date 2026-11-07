# SQLSentinel GitHub Action

The repository root is a composite GitHub Action. Add it after checking out the
consumer repository:

```yaml
name: SQL review

on:
  pull_request:
  push:
    branches: [main]

permissions:
  contents: read

jobs:
  sqlsentinel:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: Ljh684/sqlsentinel@v0.8.0
        with:
          paths: |
            db/**/*.sql
            queries/**
          fail-on: error
```

For pull request changes:

```yaml
jobs:
  sqlsentinel:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: Ljh684/sqlsentinel@v0.8.0
        with:
          changed: "true"
          base: origin/${{ github.base_ref }}...HEAD
          fail-on: warning
```

Inputs:

| Input | Default | Description |
| --- | --- | --- |
| `paths` | `.` | Newline-delimited files, directories, or globs |
| `config` | empty | Explicit `.sqlsentinel.json` path |
| `changed` | `false` | Review only SQL changed from a Git base |
| `base` | `HEAD` | Git revision or range used by `changed` |
| `fail-on` | config/default | `never`, `info`, `warning`, or `error` |
| `dialect` | config/default | `auto`, `postgres`, `mysql`, or `sqlite` |
| `schema` | config/default | Optional JSON table/index/foreign-key catalog |
| `disable-schema` | `false` | Disable a schema selected by project config |
| `baseline` | config/default | Optional JSON baseline of reviewed findings |
| `disable-baseline` | `false` | Disable a baseline selected by project config |
| `severity-overrides` | config/default | Comma-separated `RULE=LEVEL` overrides |
| `format` | `github` | `github`, `text`, `json`, `markdown`, or `sarif` |
| `allow-destructive` | config/default | Boolean policy override |
| `style-checks` | config/default | Boolean style-check override |
| `ignore` | config/default | Comma-separated rule IDs |

The action supports Linux, macOS, and Windows runners. It builds the native
SQLSentinel CLI with the pinned MoonBit toolchain and then runs it from the
consumer repository directory, so configured relative paths refer to the
consumer checkout. The default `github` format emits workflow annotations,
placing findings on the matching files and lines in the Pull Request.

For schema-aware review, commit a catalog such as `.sqlsentinel/schema.json` and
select it in the workflow:

```yaml
      - uses: Ljh684/sqlsentinel@v0.8.0
        with:
          paths: db/migrations
          schema: .sqlsentinel/schema.json
          fail-on: error
```

The catalog format and SQL201/SQL202 behavior are documented in the README.

For gradual adoption, commit a reviewed baseline and block only new findings:

```yaml
      - uses: Ljh684/sqlsentinel@v0.8.0
        with:
          paths: db/migrations
          schema: .sqlsentinel/schema.json
          baseline: .sqlsentinel/baseline.json
          fail-on: error
```

Baseline creation and matching semantics are documented in
[Finding baselines](BASELINE.md).

Rule policy can be adjusted without changing the checked-out config:

```yaml
      - uses: Ljh684/sqlsentinel@v0.8.0
        with:
          paths: db/migrations
          severity-overrides: SQL008=error,SQL003=info
          fail-on: error
```

See [Severity overrides](SEVERITY.md) for supported levels and precedence.
