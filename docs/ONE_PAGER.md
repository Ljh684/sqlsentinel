# SQLSentinel 项目一页说明

## 一句话介绍

SQLSentinel 是用 MoonBit 编写的数据库变更分析引擎，在不连接数据库、不执行
SQL 的前提下同时完成单语句风险检查和多文件迁移计划模拟，生成可复现的
影响报告、SARIF、GitHub 注解及可嵌入 API。

## 解决的问题

数据库变更评审中最危险的问题往往不需要连接数据库就能识别，例如忘记
`WHERE` 的更新/删除、直接删除表或列、缺少稳定排序的分页、隐含逗号连接，
以及破坏兼容性的 `INSERT` 或新增必填列。现有 MoonBit 生态已有 SQL
驱动、ORM 和解析器，但缺少把语句风险、schema 演变、影响面和团队策略统一
起来、可嵌入 CI 与平台的变更智能层。

## 项目能力

- 纯 MoonBit SQL 词法与结构分析，不执行 SQL；
- 14 条风险检查规则和 1 条指令诊断规则；
- 按顺序模拟多文件 schema 演变，输出影响表、破坏性变化和迁移计划；
- 可选本地 schema JSON，CLI 与浏览器编辑器共享解析，支持外键引用与索引列保护；
- JSON 基线快照只阻塞新增风险，并单独审计历史风险的抑制数量；
- 配置或 CLI 可按规则提升/降低严重级别，并保持报告审计；
- 文本、JSON、Markdown、SARIF 2.1.0 和 GitHub 注解输出；
- 支持语句级忽略，并统计被抑制的规则数量；
- 支持文件、递归目录、glob、项目配置和 Git 变更文件；
- 提供 `auto`、PostgreSQL、MySQL 和 SQLite 方言配置；
- 提供跨平台可复用 GitHub Action；
- 报告对字符串字面量脱敏，并提供规则解释与修复建议。

## 技术边界

项目不重复实现数据库驱动、ORM 或完整 SQL AST。核心只使用 MoonBit 标准能力，
文件系统使用官方 `moonbitlang/x`，原生 CLI 才负责调用 Git。所有检查都是确定性
的，AI 可以用于审阅 Markdown 报告，但不是运行依赖。

## 验证

- 75 个 Native 单元测试全部通过；
- Wasm-GC 测试、全后端类型检查和格式检查通过；
- JSON、SARIF、配置、目录、glob、Git 变更和 Action 均进入 CI；
- 危险与安全迁移示例可直接演示；
- GitHub Actions 每次提交执行完整回归。

## 演示入口

```bash
moon run --target native cmd/main -- examples/dangerous_migration.sql
moon run --target native cmd/main -- \
  --format markdown \
  --fail-on never \
  examples/dangerous_migration.sql
```

## 后续计划

继续增加 PostgreSQL、MySQL 和 SQLite 方言配置、规则语料、可复用 Action
版本标签以及浏览器演示。项目坚持小步提交和单一功能验收。
