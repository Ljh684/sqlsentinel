import { scanSqlBundle } from "./web.js";

const dangerousSql = `-- Risky migration: review every destructive operation
ALTER TABLE users
  ADD COLUMN risk_level INTEGER NOT NULL;

UPDATE users
SET risk_level = 0;

INSERT INTO audit_events
VALUES (now(), 'migration');

DROP TABLE legacy_sessions;`;

const safeSql = `-- Reviewed query with stable pagination
SELECT id, email, created_at
FROM users
WHERE tenant_id = 42
  AND email LIKE 'alice%'
ORDER BY id
LIMIT 20;`;

const schemaRiskSql = `-- users is referenced by orders; email is indexed
DELETE FROM users WHERE id = 42;
ALTER TABLE users DROP COLUMN email;`;

const planSql = `-- Schema evolution plus semantic policy findings
CREATE TABLE ledger (
  id INT PRIMARY KEY,
  user_id INT
);

ALTER TABLE users
  ALTER COLUMN email SET DATA TYPE VARCHAR(320);

ALTER TABLE ledger
  ADD CONSTRAINT ledger_users_fk
  FOREIGN KEY (user_id) REFERENCES users(id);`;

const schemaExample = {
  tables: [
    {
      name: "accounts",
      columns: [
        { name: "id", nullable: false },
        { name: "name", nullable: false },
      ],
      indexes: [
        { name: "accounts_pk", columns: ["id"], unique: true },
      ],
    },
    {
      name: "users",
      columns: [
        { name: "id", nullable: false },
        { name: "email", nullable: false },
        { name: "account_id", nullable: false },
      ],
      indexes: [
        { name: "users_pk", columns: ["id"], unique: true },
        { name: "users_email", columns: ["email"], unique: true },
      ],
      foreignKeys: [
        {
          name: "users_account_fk",
          columns: ["account_id"],
          references: { table: "accounts", columns: ["id"] },
        },
      ],
    },
    {
      name: "orders",
      columns: [
        { name: "id", nullable: false },
        { name: "user_id", nullable: false },
      ],
      indexes: [
        { name: "orders_user_idx", columns: ["user_id"], unique: false },
      ],
      foreignKeys: [
        {
          name: "orders_user_fk",
          columns: ["user_id"],
          references: { table: "users", columns: ["id"] },
        },
      ],
    },
  ],
};

const sqlInput = document.querySelector("#sql");
const dialectInput = document.querySelector("#dialect");
const schemaInput = document.querySelector("#schema");
const schemaEnabledInput = document.querySelector("#schema-enabled");
const schemaFileInput = document.querySelector("#schema-file");
const schemaStatus = document.querySelector("#schema-status");
const schemaBadge = document.querySelector("#schema-badge");
const findingsEl = document.querySelector("#findings");
const summaryEl = document.querySelector("#summary");
const suppressionEl = document.querySelector("#suppression-detail");
const dialectBadge = document.querySelector("#dialect-badge");
const errorCount = document.querySelector("#error-count");
const warningCount = document.querySelector("#warning-count");
const suppressedCount = document.querySelector("#suppressed-count");
const planBadge = document.querySelector("#plan-badge");
const planSummary = document.querySelector("#plan-summary");
const planChanges = document.querySelector("#plan-changes");
const planFindings = document.querySelector("#plan-findings");

let latestReport = null;
let latestMarkdown = "";
let latestPlan = null;

function renderPlan(plan) {
  latestPlan = plan;
  const summary = plan.summary;
  planBadge.textContent =
    summary.errors + summary.warnings === 0 ? "plan clean" : "plan review";
  planSummary.textContent =
    `Tables ${summary.tables_before} → ${summary.tables_after}; ` +
    `${summary.changes} change(s), ${summary.breaking_changes} breaking, ` +
    `${summary.errors} error(s), ${summary.warnings} warning(s).`;
  planChanges.replaceChildren();
  planFindings.replaceChildren();

  if (plan.changes.length === 0) {
    const empty = document.createElement("p");
    empty.className = "plan-empty";
    empty.textContent =
      "No DDL schema changes detected in this SQL input.";
    planChanges.append(empty);
  } else {
    for (const change of plan.changes) {
      const row = document.createElement("div");
      row.className = "plan-change";
      const kind = document.createElement("span");
      kind.className = "plan-kind";
      kind.textContent = change.kind.replaceAll("_", " ");
      const target = document.createElement("strong");
      target.textContent = change.column
        ? `${change.table}.${change.column}`
        : change.table;
      const detail = document.createElement("span");
      detail.className = "plan-detail";
      detail.textContent = change.detail;
      const location = document.createElement("code");
      location.textContent = `L${change.line}`;
      row.append(kind, target, detail, location);
      planChanges.append(row);
    }
  }

  for (const entry of plan.findings) {
    const finding = entry.finding;
    const row = document.createElement("div");
    row.className = `plan-finding ${finding.severity}`;
    const rule = document.createElement("span");
    rule.className = "rule";
    rule.textContent = `${finding.rule_id} · L${finding.line}`;
    const message = document.createElement("span");
    message.textContent = finding.message;
    row.append(rule, message);
    planFindings.append(row);
  }
}

function clearPlan() {
  latestPlan = null;
  planBadge.textContent = "plan unavailable";
  planSummary.textContent = "Migration plan could not be generated.";
  planChanges.replaceChildren();
  planFindings.replaceChildren();
}

function setSchemaStatus(message, state = "") {
  schemaStatus.textContent = message;
  schemaStatus.className = `schema-status ${state}`.trim();
}

function setSchemaBadge(enabled, error = false) {
  schemaBadge.textContent = error
    ? "schema error"
    : enabled
      ? "schema on"
      : "schema off";
  schemaBadge.className = `schema-badge ${error ? "error" : enabled ? "on" : "off"}`;
}

function render(report) {
  latestReport = report;
  const summary = report.summary;
  errorCount.textContent = summary.errors;
  warningCount.textContent = summary.warnings;
  suppressedCount.textContent = summary.suppressed;
  dialectBadge.textContent = summary.dialect;
  setSchemaBadge(summary.schema);

  if (report.findings.length === 0) {
    summaryEl.textContent =
      summary.suppressed > 0
        ? `No unsuppressed findings. ${summary.suppressed} reviewed exception(s) remain audited.`
        : "No policy findings. This SQL passed the current review.";
  } else {
    summaryEl.textContent =
      `Scanned ${summary.statements} statement(s): ` +
      `${summary.errors} error(s) and ${summary.warnings} warning(s).`;
  }

  findingsEl.replaceChildren();
  suppressionEl.replaceChildren();
  for (const suppressed of report.suppressions ?? []) {
    const chip = document.createElement("span");
    chip.className = "suppression-chip";
    chip.textContent = `${suppressed.rule_id} ×${suppressed.count}`;
    suppressionEl.append(chip);
  }
  for (const finding of report.findings) {
    const article = document.createElement("article");
    article.className = `finding ${finding.severity}`;

    const top = document.createElement("div");
    top.className = "finding-top";
    const rule = document.createElement("span");
    rule.className = "rule";
    rule.textContent = `${finding.rule_id} · L${finding.line}:${finding.column}`;
    const severity = document.createElement("span");
    severity.className = "rule";
    severity.textContent = finding.severity;
    top.append(rule, severity);

    const title = document.createElement("h3");
    title.textContent = finding.title;
    const risk = document.createElement("p");
    risk.textContent = finding.message;
    const fix = document.createElement("p");
    fix.textContent = `Fix: ${finding.suggestion}`;
    article.append(top, title, risk, fix);
    findingsEl.append(article);
  }
}

function scan() {
  const schemaJson = schemaEnabledInput.checked ? schemaInput.value : "";
  try {
    const result = JSON.parse(
      scanSqlBundle(sqlInput.value, dialectInput.value, schemaJson),
    );
    if (!result.ok) {
      latestReport = null;
      latestMarkdown = "";
      findingsEl.replaceChildren();
      suppressionEl.replaceChildren();
      errorCount.textContent = "0";
      warningCount.textContent = "0";
      suppressedCount.textContent = "0";
      clearPlan();
      setSchemaBadge(false, true);
      setSchemaStatus(result.error, "error");
      summaryEl.textContent =
        "Schema JSON could not be loaded. Fix it or disable schema checks.";
      return;
    }
    latestMarkdown = result.markdown;
    render(result.report);
    renderPlan(result.plan);
    if (result.report.summary.schema) {
      setSchemaStatus(
        "Schema active: SQL201 cross-table checks and SQL202 column protection are enabled.",
        "success",
      );
    } else {
      setSchemaStatus(
        "Schema checks are disabled. Enable them to run SQL201 and SQL202.",
      );
    }
  } catch (error) {
    summaryEl.textContent = `Scan failed: ${error}`;
    setSchemaStatus(String(error), "error");
  }
}

function updateSchemaControl() {
  schemaInput.disabled = !schemaEnabledInput.checked;
  document.querySelector("#schema-panel").classList.toggle(
    "disabled",
    !schemaEnabledInput.checked,
  );
  scan();
}

document.querySelector("#scan").addEventListener("click", scan);
document.querySelector("#load-danger").addEventListener("click", () => {
  sqlInput.value = dangerousSql;
  scan();
});
document.querySelector("#load-safe").addEventListener("click", () => {
  sqlInput.value = safeSql;
  scan();
});
document.querySelector("#load-schema-risk").addEventListener("click", () => {
  sqlInput.value = schemaRiskSql;
  schemaEnabledInput.checked = true;
  updateSchemaControl();
});
document.querySelector("#load-plan").addEventListener("click", () => {
  sqlInput.value = planSql;
  schemaEnabledInput.checked = true;
  updateSchemaControl();
});

schemaEnabledInput.addEventListener("change", updateSchemaControl);

document.querySelector("#format-schema").addEventListener("click", () => {
  try {
    schemaInput.value = JSON.stringify(JSON.parse(schemaInput.value), null, 2);
    setSchemaStatus("Schema JSON is valid and formatted.", "success");
    scan();
  } catch (error) {
    setSchemaStatus(`Invalid JSON: ${error.message}`, "error");
  }
});

document.querySelector("#import-schema").addEventListener("click", () => {
  schemaFileInput.click();
});

schemaFileInput.addEventListener("change", async () => {
  const file = schemaFileInput.files?.[0];
  if (!file) return;
  schemaInput.value = await file.text();
  schemaEnabledInput.checked = true;
  updateSchemaControl();
  schemaFileInput.value = "";
});

document.querySelector("#copy-markdown").addEventListener("click", async () => {
  if (!latestMarkdown) return;
  await navigator.clipboard.writeText(latestMarkdown);
  summaryEl.textContent = "Markdown review copied.";
});

document.querySelector("#download-markdown").addEventListener("click", () => {
  if (!latestMarkdown) return;
  const blob = new Blob([latestMarkdown], { type: "text/markdown" });
  const link = document.createElement("a");
  link.href = URL.createObjectURL(blob);
  link.download = "sqlsentinel-review.md";
  link.click();
  URL.revokeObjectURL(link.href);
  summaryEl.textContent = "Markdown review downloaded.";
});

document.querySelector("#download-json").addEventListener("click", () => {
  if (!latestReport) return;
  const blob = new Blob([JSON.stringify(latestReport, null, 2)], {
    type: "application/json",
  });
  const link = document.createElement("a");
  link.href = URL.createObjectURL(blob);
  link.download = "sqlsentinel-report.json";
  link.click();
  URL.revokeObjectURL(link.href);
});

document.querySelector("#download-plan").addEventListener("click", () => {
  if (!latestPlan) return;
  const blob = new Blob([JSON.stringify(latestPlan, null, 2)], {
    type: "application/json",
  });
  const link = document.createElement("a");
  link.href = URL.createObjectURL(blob);
  link.download = "sqlsentinel-migration-plan.json";
  link.click();
  URL.revokeObjectURL(link.href);
});

document.addEventListener("keydown", (event) => {
  if ((event.ctrlKey || event.metaKey) && event.key === "Enter") {
    event.preventDefault();
    scan();
  }
});

schemaInput.value = JSON.stringify(schemaExample, null, 2);
sqlInput.value = dangerousSql;
scan();
