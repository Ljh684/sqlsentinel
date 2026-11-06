const moduleUrl = new URL("../web/dist/web.js", import.meta.url);
const scanner = await import(moduleUrl);

const report = JSON.parse(
  scanner.scanSqlJson("DELETE FROM users;", "postgres"),
);
if (report.summary.errors !== 1) {
  throw new Error("expected one error");
}
if (
  !scanner
    .scanSqlMarkdown("SELECT 1;", "sqlite")
    .includes("# SQLSentinel review")
) {
  throw new Error("markdown export failed");
}

const schema = JSON.stringify({
  tables: [
    {
      name: "users",
      columns: [{ name: "id" }, { name: "email" }],
      indexes: [
        { name: "users_email", columns: ["email"], unique: true },
      ],
    },
    {
      name: "orders",
      columns: [{ name: "id" }, { name: "user_id" }],
      foreignKeys: [
        {
          columns: ["user_id"],
          references: { table: "users", columns: ["id"] },
        },
      ],
    },
  ],
});

const bundle = JSON.parse(
  scanner.scanSqlBundle(
    "DELETE FROM users WHERE id = 1; ALTER TABLE users DROP COLUMN email;",
    "postgres",
    schema,
  ),
);
const ruleIds = bundle.report.findings.map((finding) => finding.rule_id);

if (!bundle.ok || !bundle.report.summary.schema) {
  throw new Error("schema bundle did not enable schema checks");
}
if (!ruleIds.includes("SQL201") || !ruleIds.includes("SQL202")) {
  throw new Error("schema bundle missed SQL201 or SQL202");
}
if (!bundle.markdown.includes("SQL201")) {
  throw new Error("schema Markdown export failed");
}

const invalid = JSON.parse(
  scanner.scanSqlBundle(
    "SELECT 1;",
    "auto",
    JSON.stringify({ tables: [] }),
  ),
);
if (invalid.ok || !invalid.error.includes("cannot be empty")) {
  throw new Error("invalid schema error was not surfaced");
}

console.log("browser playground exports verified");
