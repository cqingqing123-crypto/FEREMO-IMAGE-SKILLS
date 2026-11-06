# FEREMO IMAGE SKILLS v1.0.0 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 发布当前实际使用的 FEREMO Codex 图片工作流，并证明来源、安装和远程完整性。

**Architecture:** 单一领域 Skill 调用 Codex 内置图片生成工具；稳定规则通过 references 渐进加载。仓库级 PowerShell 验证器负责离线结构、敏感信息、安装模拟和 SHA-256 检查，不调用图片服务。

**Tech Stack:** Markdown, YAML, PowerShell, Git, GitHub

**Spec:** `docs/audit/2026-11-06-release-design.md`

## Global Constraints

- 原始工作流只读，修改仅发生在独立发布副本。
- 不包含凭据、聊天记录、客户图片、成品图片、缓存或产品专属硬编码脚本。
- 不调用付费 API，不批量生成图片。
- GitHub 仓库必须为 Public，公开安装不得要求协作者权限或私有仓库认证；禁止强制推送。

## Review Focus

- 同名 Skill 多副本是否被错误当成不同版本。
- references 是否能在不同安装目录解析。
- 发布 Skill 是否含本机绝对路径或敏感信息。
- 干净安装是否保留全部发布文件与 SHA-256。
- 远程默认分支、标签和 Release 是否指向同一提交。

---

### Task 1: 来源与依赖闭包

**Files:**
- Create: `docs/PROVENANCE.zh-CN.md`
- Create: `docs/SOURCE_SHA256.txt`

**Interfaces:**
- Produces: 供 Task 2 采用的核心 Skill、必要资源、可选工具、第三方依赖和历史文件分类。

- [ ] 核对 `CODEX_HOME`、同名副本、Junction、旧迁移备份和当前项目副本。
- [ ] 从真实会话确认 Skill 加载路径、图片工具调用和已积累规则。
- [ ] 记录所有原始候选的 SHA-256，并确认原文件只读。

### Task 2: 可安装 Skill 包

**Files:**
- Create: `skills/ecomi-aplus-remix/SKILL.md`
- Create: `skills/ecomi-aplus-remix/agents/openai.yaml`
- Create: `skills/ecomi-aplus-remix/references/production-workflow.md`
- Create: `skills/ecomi-aplus-remix/references/quality-gate.md`
- Create: `README.md`
- Create: `THIRD_PARTY_NOTICES.md`
- Create: `.gitignore`

**Interfaces:**
- Consumes: Task 1 的核心版本和依赖分类。
- Produces: Task 3 可验证、同事可安装的相对路径 Skill 目录。

- [ ] 原核心 SKILL.md 正文逐字保留并只追加 references 路由。
- [ ] 把真实历史中反复出现的通用规则去产品化后写入 references。
- [ ] 写入基于 `CODEX_HOME` 的中文安装和更新说明。

### Task 3: 离线验证与安装模拟

**Files:**
- Create: `tests/validate-release.ps1`
- Create: `MANIFEST.sha256`
- Create: `docs/TEST_REPORT.zh-CN.md`

**Interfaces:**
- Consumes: Task 2 的完整发布树。
- Produces: Task 4 发布门禁和可复核证据。

- [ ] 先运行验证器并确认因发布文件缺失而失败（RED）。
- [ ] 完成发布文件后运行验证器通过（GREEN）。
- [ ] 运行 Skill Creator 元数据校验、内部引用检查、敏感扫描和干净安装模拟。
- [ ] 生成并复核 SHA-256 清单；明确图片质量未实测。

### Task 4: GitHub 公开发布

**Files:**
- Create: Git repository metadata, tag `v1.0.0`, GitHub Release

**Interfaces:**
- Consumes: Task 3 通过的发布树和清单。
- Produces: Public GitHub repository URL, Release URL, remote verification evidence.

- [ ] 检查认证、账号和同名仓库；若存在先检查内容。
- [ ] 初始化 Git，提交验证通过的文件并推送，不强推。
- [ ] 创建 `v1.0.0` 标签和 Release。
- [ ] 回读仓库可见性、默认分支、提交、标签和 Release；在远程检出副本重跑验证。
