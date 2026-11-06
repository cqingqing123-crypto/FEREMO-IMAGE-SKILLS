# FEREMO IMAGE SKILLS v1.0.0 发布设计

## 意图

把当前 Codex 中实际使用的 FEREMO 服装 A+ 图片工作流，整理成可审计、可安装、可复现调用规则的私有仓库；不把客户素材、聊天记录、凭据或一次性产品脚本带入发布包。

## 目标

- 以当前 `CODEX_HOME` 实际加载的 `ecomi-aplus-remix` 为核心。
- 原核心规则逐字保留；把真实会话中反复使用、但未合并进核心文件的通用规则放入 references。
- 只依赖 Codex 内置图片生成能力，不绑定付费 API、模型名或本机绝对路径。
- 提供中文安装说明、来源审计、完整性清单和不调用图片生成的离线验证。

## 非目标

- 不复制 Codex 系统 `imagegen` Skill、系统脚本或插件缓存。
- 不发布客户图片、成品图、逐商品提示词、会话 JSONL、缓存或凭据。
- 不把 17 个硬编码到具体商品/本机路径的后处理脚本包装成通用能力。
- 不声称离线测试验证了人物、服装或图片质量。

## 约束

- 原始工作流全程只读；仅在独立发布副本修改。
- 发布运行时不得含 Windows 盘符硬编码、API Key 或个人目录。
- 多版本判断必须同时使用 SHA-256、加载路径和真实调用记录。
- GitHub 仓库必须为 Private，禁止强推；发布 `v1.0.0` 后回读远程内容。

## 方案比较

1. **只复制现有 SKILL.md**：最保守，但会漏掉多参考图角色矩阵、负向标注图、定向返工和像素验收等已经实际使用的规则。
2. **复制整个图片项目**：最完整地保留历史，但会混入客户素材、硬编码路径、一次性脚本和数百 MB 无关文件，不可发布。
3. **核心 Skill + 证据化 references（采用）**：原核心正文不删改，只追加 references 路由；通用积累与产品专属历史分离，兼顾真实性、隐私和可安装性。

## 结构

- `skills/ecomi-aplus-remix/SKILL.md`：核心入口，原始正文完整保留。
- `skills/ecomi-aplus-remix/references/production-workflow.md`：历史调用中反复验证的多图角色、提示词、返工和保存规则。
- `skills/ecomi-aplus-remix/references/quality-gate.md`：生成前后质检与无法验证时的报告边界。
- `skills/ecomi-aplus-remix/agents/openai.yaml`：Codex UI 元数据，不声明不存在的 MCP 依赖。
- `tests/validate-release.ps1`：元数据、引用、敏感信息、硬编码路径、安装模拟和清单验证。

## 验收

- Skill Creator `quick_validate.py` 通过。
- 仓库验证脚本在发布目录与干净安装副本中均通过。
- 所有内部相对引用可解析；敏感扫描无命中。
- 来源文件 SHA-256 在迁移前后证据中一致，原文件未改动。
- GitHub Private 仓库、`v1.0.0` 标签和 Release 均可回读。

