# 来源、版本与依赖审计

## 实际核心版本

- 当前 `CODEX_HOME`：`H:\Codex\Home`。
- 当前实际加载入口：`H:\Codex\Home\skills\ecomi-aplus-remix\SKILL.md`。
- 原始大小：5,524 字节。
- 原始 SHA-256：`a04c867f508ed6f4745310cf88bf22d36bf86ca353705ce75a3d8751666670e3`。

确认依据不是修改时间，而是三类证据同时成立：当前环境变量和 Skill 注册路径、所有候选文件内容/SHA-256、2026-09 至 2026-10 的真实 `image_gen__imagegen` 调用记录。

## 多副本结论

发现的项目副本、当前用户级副本、迁移前备份和 `C:\Users\Administrator\.codex` Junction 别名内容完全一致，没有第二个不同 SHA-256 的修改版。Junction 是同一物理目录的别名，不是独立版本。

2026-11-02 的只读审计会话再次确认：当时可发现范围内没有不同 SHA-256 的个人修改版，当前环境也没有 `ecomi-aplus-layout` 文件。

## 历史调用证据

以下会话只用于核对实际调用路径和通用规则；原始 JSONL 与图片均未复制进仓库：

- `01a0a334-89b9-74b2-ad0f-033d12eaff8b`：多版式、多产品图、人物比例返工和已有成品定向编辑。
- `01a0cc23-08c9-7e80-a8ce-946992a5d567`：参考图/产品图角色分离、服装结构不变量和多版本保存。
- `01a13412-c93f-7323-a130-8ae1a892170b`：多张同一人物/服装参考、完整人体等比例缩放和精确裁切。
- `01a13ee4-52fe-7af3-83d9-81927c64d621`：人物体型、印花、侧袋和参考取景优先级。
- `01a143ec-8120-7020-b419-5e37a5d61aaa`：负向标注图、口袋/侧缝禁止项、裤型和箭头保留。
- `01a19b7f-0e54-70c1-a87a-88cc6c419dcf`：完整只读扫描、工作流质量基准和依赖分类。

## 依赖分类

### A. 核心 Skill

- `ecomi-aplus-remix/SKILL.md`：领域路由、人物/身体比例、服装和构图规则。

### B. 必要配套资源

- `references/production-workflow.md`：从真实调用中提炼的多图角色、提示词、返工、尺寸和保存规则。
- `references/quality-gate.md`：生成前后门禁及报告边界。
- `agents/openai.yaml`：Codex UI 元数据与隐式调用策略。

### C. 可选辅助工具（未发布）

- 原工作区 10 个 PowerShell、6 个 Python 和 1 个 JavaScript 后处理脚本。
- 它们未被核心 Skill 引用，包含特定商品、布局或本机路径，仅在历史个案中使用。

### D. 第三方依赖（不复制）

- Codex 内置图片生成工具和系统 `imagegen` Skill。
- 历史脚本曾使用 Pillow、System.Drawing、sharp；v1.0.0 核心运行不要求这些库。

### E. 历史遗留与证据（未发布）

- 33 个产品专属提示词、客户输入图、成品图、Benchmark 导出、ZIP、生成缓存和会话 JSONL。
- 缺失的 `ecomi-aplus-layout` 只保留为核心 Skill 的边界说明，不冒充已发布依赖。

## 发布副本的变化

原核心正文从 frontmatter 到“边界”逐字保留。发布副本只追加“已验证的扩展工作流”路由，并新增两份去产品化 reference；没有删除、重写或弱化任何原规则。原文件未被修改。
