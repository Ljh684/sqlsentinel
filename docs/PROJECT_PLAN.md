# SQLSentinel 黑客松项目方案

## 一句话介绍

SQLSentinel 是一个用 MoonBit 编写的数据库变更安全审查器：在不连接数据库、
不执行 SQL 的前提下，为仓库中的 SQL 和迁移脚本生成带位置、解释和修复建议的
可复现报告，并输出适合 GitHub CI 的 SARIF。

## 真实需求

数据库变更通常散落在迁移文件、后台脚本和查询文件中。提交评审时，最常见的
高风险问题恰好可以只依赖 SQL 结构判断：

- 忘记写 `WHERE` 的 `UPDATE` / `DELETE`；
- 在生产迁移中直接 `DROP TABLE`、`TRUNCATE` 或删除列；
- `SELECT *` 将调用方绑定到当前列集合；
- `LIMIT` 缺少 `ORDER BY`，导致分页结果不稳定；
- 前缀通配符搜索可能造成大范围扫描；
- 逗号连接和未写列名的 `INSERT` 容易在后续结构变更时失效；
- 新增 `NOT NULL` 列却没有默认值。

这些问题不需要数据库连接即可定位，但现有 SQL 工具更多关注解析、格式化、
ORM 或特定数据库协议。SQLSentinel 聚焦“提交前的风险审查”这一层。

## 差异化

选择该方向前检索了 mooncakes.io 上 `SQL lint`、`SQL safety`、`SQL review`、
`migration safety` 等关键词。已有项目主要覆盖：

- SQL 解析器和查询构建器；
- SQLite / PostgreSQL 驱动与 ORM；
- 数据库 schema diff 和迁移执行；
- 特定 PostgreSQL 索引迁移审查；
- 特定分析型 SQL 方言的解析工具。

SQLSentinel 的边界是一个数据库无关、可嵌入、可输出 SARIF 的 SQL 风险审查库。
核心只依赖 MoonBit 标准能力，CLI 的文件读取使用官方 `moonbitlang/x`。

## MVP

首版已经实现：

- 注释、单引号字符串、引号标识符、美元引号字符串的识别；
- 按顶层分号切分 SQL 语句；
- 15 条风险检查规则及 1 条指令诊断规则，均有明确编号和修复建议；
- 多文件迁移计划分析：模拟 schema 演变、影响表、缺失对象、类型变更和外键索引；
- 下游查询影响分析：将迁移变化映射到引用旧表/旧列的查询文件；
- 统一 Review Packet：输出 pass/review/block 结论与合并后的修复动作；
- 文本、JSON、Markdown、SARIF 输出；
- 可配置失败阈值和破坏性变更降级策略；
- 语句级忽略指令与格式错误诊断；
- SQL 目录递归发现、确定性排序、去重和常见构建目录过滤；
- Git `HEAD`/指定基准的变更 SQL 过滤，含参数安全校验；
- `.sqlsentinel.json` 项目配置，支持路径、策略、忽略规则和 Git 基准；
- `*`、`?`、`**` 路径匹配与配置路径组合；
- 可复用 GitHub Action，覆盖 Linux、macOS 和 Windows runner；
- GitHub Actions 行内注解输出及 NUL 安全的 Git 文件名解析；
- 行内及全局规则抑制的数量审计；
- PostgreSQL、MySQL、SQLite 与通用方言配置，并对 SQLite 必填列风险升级；
- 可选本地 schema 目录与外键、索引保护检查（SQL201/SQL202）；
- 可重建 JSON 基线，历史风险不阻塞 CI，新增风险继续失败；
- 逐规则严重级别覆盖进入配置、CLI、Action、计数阈值和报告审计；
- 浏览器端 SQL/schema 审查演示，支持 schema 编辑、开关、导入、格式化和导出；
- 静态产物随仓库发布，CI 每次重建并执行真实模块冒烟测试，并提供 Pages 部署工作流；
- 79 个 Native 单元测试；
- GitHub Actions 自动验证。

## 四周推进计划

### 第 1 周：可信核心

- 完善规则语料和误报测试；
- 深化 PostgreSQL / MySQL / SQLite 方言特定规则；
- 完善规则语料在不同 SQL 方言下的边界用例；
- 把规则文档改为由规则目录自动生成。

### 第 2 周：仓库集成

- 增加 JSON Schema 和 SARIF 校验测试。

### 第 3 周：可演示性

- 做一个基于 WASM 的浏览器演示页；
- 增加“危险迁移 vs 分阶段安全迁移”对照示例；
- 生成 Pull Request 评论格式的样例；
- 增加性能基准和大型 SQL 语料测试。

### 第 4 周：发布与验收

- 完善 README、规则手册和贡献指南；
- 发布 mooncakes.io 0.1.0；
- 发布 GitHub Release；
- 录制 60 秒演示；
- 准备申报书和项目验收清单。

## 验收对应

| 要求 | 当前实现 |
| --- | --- |
| MoonBit 为主要语言 | 核心、测试、CLI 均为 MoonBit |
| 仓库公开、开发过程可追踪 | 从首版开始保留小步提交记录 |
| README、示例、测试 | 已包含可执行命令、三份 SQL 示例和单元测试 |
| 开源合规 | Apache-2.0；官方依赖 `moonbitlang/x` |
| AI 可解释 | Markdown 报告可作为受约束的 AI 审阅上下文 |
| 可运行、可复现 | 本地命令无网络和数据库依赖 |

## 风险与规避

**误报风险**：首版只实现结构明确、解释成本低的规则，并允许阈值与风格检查
配置。下一阶段增加行内抑制和方言配置。

**范围膨胀**：不追求完整 SQL AST 或数据库优化器。跨表检查仅依赖用户提供的
本地 schema JSON，不连接数据库，也不替代真实约束验证。

**与已有项目重叠**：不实现驱动、ORM、SQL 执行或数据库 schema diff；复用
社区解析器作为可选前端，而不是重复建设数据库协议层。

## 演示脚本

1. 打开 `examples/dangerous_migration.sql`。
2. 运行默认文本扫描，展示错误和修复建议。
3. 生成 Markdown 报告，说明如何交给人工或 AI 审阅。
4. 生成 SARIF，说明可直接进入 GitHub code scanning。
5. 扫描 `examples/safe_migration.sql`，展示 CI 通过。

## 发布前待办

- 把 `moon.mod` 中的 `repository` 改成真实 GitHub 地址；
- 创建公开 GitHub 仓库并保留连续提交；
- 运行 `moon fmt`、`moon check --target native`、`moon test --target native`；
- 在仓库 Settings 中启用 Actions；
- 在赛事表单中填写公开仓库链接和一页项目说明；
- 发布 mooncakes.io 0.1.0，并确认包名未被占用。
