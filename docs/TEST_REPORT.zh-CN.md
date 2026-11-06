# 自动测试报告

执行日期：2026-11-06

## 已通过

| 检查 | 结果 |
|---|---|
| Skill Creator `quick_validate.py` | `Skill is valid!` |
| 仓库验证器 | 元数据、内部引用、敏感信息、运行时路径、SHA-256、安装模拟全部通过 |
| PowerShell 语法 | `tests/validate-release.ps1` 解析错误 0 |
| 原核心正文保持 | 发布副本追加章节之前的正文与原文件规范化后逐字一致 |
| 原核心 SHA-256 | `a04c867f508ed6f4745310cf88bf22d36bf86ca353705ce75a3d8751666670e3` |
| 来源完整性 | `docs/SOURCE_SHA256.txt` 中 65/65 个原始来源文件回读一致 |
| 敏感信息扫描 | API Key、GitHub Token、私钥、`auth.json`、会话 JSONL 命中 0 |
| 第三方运行依赖 | 当前 Codex 系统 `imagegen/SKILL.md` 可发现；未复制进仓库 |
| 干净安装模拟 | 临时 `$CODEX_HOME/skills/ecomi-aplus-remix` 文件数量和 SHA-256 全部一致 |

## RED→GREEN 记录

1. 首次运行验证器因 11 个必需发布文件尚未创建而失败。
2. 文件补齐后，验证器发现 `docs/PROVENANCE.zh-CN.md` 的清单哈希因勘误而过期。
3. 更新清单后验证器通过。
4. 官方 `quick_validate.py` 首次因运行时缺少 `PyYAML` 无法启动；确认根因后只在任务临时目录安装 `PyYAML 6.0.3`，再次运行通过。该临时依赖未进入仓库。

## 未实际验证

- 未调用图片生成服务或付费 API。
- 未生成新图片，因此未实测人物身份、身体比例、服装色值、印花、版型、文字准确性和视觉完成度。
- 未证明内置图片工具的具体模型名称、快照、原生输出分辨率或跨版本一致性。
- GitHub 远程分支、标签、Release 和远程检出验证在发布步骤完成后单独回读，并以最终交付报告为准。
