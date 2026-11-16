# Source and dependency provenance

SQLSentinel is an original implementation maintained by Ljh684.

- No SQL parser implementation is vendored from another project.
- The project does not copy driver, ORM, or schema-diff source code.
- SQL grammar support was implemented against public SQL behavior and exercised
  with project-owned fixtures and tests.
- The official dependency `moonbitlang/x@0.5.5` is used for CLI I/O/path/sys
  support and is licensed under Apache-2.0.
- Git changed-file discovery uses a project-owned minimal C FFI.
- The browser Playground and GitHub workflows are project-owned assets.

External projects mentioned in the ecosystem comparison are references for
positioning only; their source is not incorporated into this repository.

If future code is ported or vendored, the source URL, upstream license, and
modification notice must be recorded here and in `NOTICE` before merge.
