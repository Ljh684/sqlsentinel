# Competition acceptance guide

This guide maps the project to the official MoonBit Hackathon requirements and
quarterly scoring dimensions published at:

- <https://moonbitlang.github.io/Hackathon2026/#requirements>
- <https://moonbitlang.github.io/Hackathon2026/#quarterly-scoring>

Checked against the public event page on 2026-11-17.

## Official acceptance requirements

| Requirement | Evidence in SQLSentinel |
| --- | --- |
| MoonBit is the primary language | Core parser, schema reducer, rules, reports, browser bindings, tests, and CLI are MoonBit. Native I/O uses the official `moonbitlang/x` package. |
| Public repository and traceable development | Public Apache-2.0 repository with continuous commits, versioned releases, CI history, changelog, and documented review iterations. |
| Runnable project | README quick start, deterministic examples, native CLI, browser Playground, GitHub Action, and `scripts/acceptance.ps1` / `.sh`. |
| README, examples, tests | Architecture docs, schema/migration/impact examples, 80 native and 76 wasm-gc tests, browser smoke tests, and CI integration checks. |
| Substantial work in this period | Multi-file schema simulation, SQL301–SQL305 semantic rules, downstream query impact, unified review packets, baselines, severity policy, and bounded analysis-model reporting. |
| Open-source compliance | Apache-2.0, dependency declaration, `NOTICE`, and `docs/PROVENANCE.md`. No vendored third-party source. |
| AI is explainable | Runtime behavior is deterministic and uses no model/network API. AI assistance remains optional and every result is backed by named code, tests, and limitations in `docs/AI_USAGE.md`. |

The official page explicitly excludes duplicate submissions, project splitting,
and superficial modifications. The current work is an integrated extension of
the same project rather than a renamed duplicate.

## Quarterly scoring alignment

### 1. Engineering depth and implementation strength

SQLSentinel implements a complete pipeline rather than a local prototype:
context-aware lexing, statement splitting, structural DDL parsing, evolving
schema state, query impact correlation, policy evaluation, and multiple report
formats. The supported scope and fallback behavior are explicit.

### 2. Technical contribution and problem solving

The primary technical contribution is moving from independent SQL text checks to
an ordered, testable schema-state model plus downstream query impact. The
project does not present incomplete syntax as full semantic support; it exposes
precision and unsupported layers through `--capabilities` and `analysis_model`.

### 3. Ecosystem increment

Existing MoonBit packages include schema-diff planners, data-contract
governance, SQL parsers, drivers, and ORMs. SQLSentinel occupies a complementary
space: migration-source safety, evolving schema state, affected-query analysis,
policy/baseline behavior, and a unified review artifact. See
[Ecosystem positioning](ECOSYSTEM.md) for an explicit comparison.

### 4. Development and validation capability

The repository uses native and wasm-gc tests, browser module smoke tests,
CI examples, static build verification, release packaging, GitHub Actions, and a
single acceptance harness. The harness checks formatting, type-checking,
multi-backend tests, package creation, positive/negative examples, plan/impact/
review reports, and browser output.

An optional deterministic benchmark harness is available through
`scripts/benchmark.ps1` (or `.sh`). It generates 5,000 query statements, runs the
native CLI, and records elapsed time and report size under `_build/benchmark/`.
The benchmark is informational rather than a flaky wall-clock CI threshold.

## Known limits

- No complete SQL AST, query planner, database execution, or live introspection.
- No procedural-language or dynamic SQL semantics.
- Query impact is source-level and conservative; full alias/CTE/expression
  resolution is outside the current model.
- Lock, data-volume, and query-plan risks require external database evidence.

These limits are deliberate and visible in the UI, CLI, JSON metadata, docs, and
application materials.

## One-command verification

Windows:

```powershell
.\scripts\acceptance.ps1
```

Linux/macOS:

```bash
bash scripts/acceptance.sh
```

Reports are written under `_build/acceptance/`.
