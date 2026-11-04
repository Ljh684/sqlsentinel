import { scanSqlJson, scanSqlMarkdown } from "./web.js";

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

const sqlInput = document.querySelector("#sql");
const dialectInput = document.querySelector("#dialect");
const findingsEl = document.querySelector("#findings");
const summaryEl = document.querySelector("#summary");
const suppressionEl = document.querySelector("#suppression-detail");
const dialectBadge = document.querySelector("#dialect-badge");
const errorCount = document.querySelector("#error-count");
const warningCount = document.querySelector("#warning-count");
const suppressedCount = document.querySelector("#suppressed-count");

let latestReport = null;

function render(report) {
  latestReport = report;
  const summary = report.summary;
  errorCount.textContent = summary.errors;
  warningCount.textContent = summary.warnings;
  suppressedCount.textContent = summary.suppressed;
  dialectBadge.textContent = summary.dialect;

  if (report.findings.length === 0) {
    summaryEl.textContent =
      summary.suppressed > 0
        ? `没有未抑制的问题；${summary.suppressed} 条审查例外已记录。`
        : "未发现策略问题。该 SQL 通过了本次审查。";
  } else {
    summaryEl.textContent = `扫描 ${summary.statements} 条语句，发现 ${summary.errors} 个错误和 ${summary.warnings} 个警告。`;
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
  try {
    render(JSON.parse(scanSqlJson(sqlInput.value, dialectInput.value)));
  } catch (error) {
    summaryEl.textContent = `扫描失败：${error}`;
  }
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

document.querySelector("#copy-markdown").addEventListener("click", async () => {
  const markdown = scanSqlMarkdown(sqlInput.value, dialectInput.value);
  await navigator.clipboard.writeText(markdown);
  summaryEl.textContent = "Markdown 审查报告已复制。";
});

document.querySelector("#download-markdown").addEventListener("click", () => {
  const markdown = scanSqlMarkdown(sqlInput.value, dialectInput.value);
  const blob = new Blob([markdown], { type: "text/markdown" });
  const link = document.createElement("a");
  link.href = URL.createObjectURL(blob);
  link.download = "sqlsentinel-review.md";
  link.click();
  URL.revokeObjectURL(link.href);
  summaryEl.textContent = "Markdown 审查报告已下载。";
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

document.addEventListener("keydown", (event) => {
  if ((event.ctrlKey || event.metaKey) && event.key === "Enter") {
    event.preventDefault();
    scan();
  }
});

sqlInput.value = dangerousSql;
scan();
