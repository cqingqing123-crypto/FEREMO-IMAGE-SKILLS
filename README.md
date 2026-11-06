# FEREMO IMAGE SKILLS

FEREMO 服装图片工作流的 Codex 私有发布包。核心 Skill 是 `ecomi-aplus-remix`：使用版式参考图与产品/模特图生成 Amazon A+ 图片，并严格控制人物身份、真实体型、取景、服装颜色、印花、版型和结构。

## 发布内容

```text
skills/ecomi-aplus-remix/
├── SKILL.md
├── agents/openai.yaml
└── references/
    ├── production-workflow.md
    └── quality-gate.md
```

本仓库不包含客户图片、成品图、聊天记录、API Key、缓存、系统 Skill 或产品专属后处理脚本。

## 依赖

- Codex Desktop/CLI，且当前会话可用内置图片生成工具。
- 有权访问本私有 GitHub 仓库的 GitHub 账号。
- 核心工作流不需要单独配置 OpenAI API Key，也不会自动回退到付费 API。

## 安装（推荐）

在 Codex 中发送：

```text
使用 $skill-installer，从私有仓库 cqingqing123-crypto/FEREMO-IMAGE-SKILLS 的 skills/ecomi-aplus-remix 安装 Skill。
```

内置安装器会使用当前 GitHub 凭据，并安装到当前电脑的 `$CODEX_HOME/skills/ecomi-aplus-remix`；`CODEX_HOME` 未设置时使用 Codex 默认目录。

## 手动安装（PowerShell）

```powershell
git clone https://github.com/cqingqing123-crypto/FEREMO-IMAGE-SKILLS.git
$destination = Join-Path $env:CODEX_HOME 'skills\ecomi-aplus-remix'
if (Test-Path -LiteralPath $destination) { throw "目标已存在，请先备份或使用更新流程：$destination" }
Copy-Item -Recurse -LiteralPath '.\FEREMO-IMAGE-SKILLS\skills\ecomi-aplus-remix' -Destination $destination
```

重新打开一个 Codex 任务后，显式测试：

```text
使用 $ecomi-aplus-remix。图1是版式参考，图2是我的产品模特。先说明你识别到的图片角色，不要生成图片。
```

## 更新

不要直接覆盖正在使用的目录。先备份现有 Skill，再从已审核的 Release 安装；安装后运行本仓库的验证脚本并在新任务中测试识别。

## 离线验证

```powershell
powershell -ExecutionPolicy Bypass -File .\tests\validate-release.ps1
```

验证包括元数据、内部引用、运行时绝对路径、敏感令牌、SHA-256 清单和干净安装模拟；不会调用图片生成服务。

## 使用

最短调用：

```text
使用 $ecomi-aplus-remix。图1是版式参考，图2是我的产品模特。
```

多参考图时应明确每张图的角色。Skill 会优先保留产品图中的人物、体型和服装事实，只把参考图用于构图、场景、机位、姿势和取景。

## 证据与限制

- [来源与版本确认](docs/PROVENANCE.zh-CN.md)
- [自动测试报告](docs/TEST_REPORT.zh-CN.md)
- [原始来源 SHA-256](docs/SOURCE_SHA256.txt)
- [第三方依赖说明](THIRD_PARTY_NOTICES.md)

图片质量、人物身份和服装细节属于视觉结果，无法由离线结构测试证明；每次交付仍需按质量门禁人工复核。

参考：[OpenAI 官方 Skills 结构说明](https://developers.openai.com/plugins/build/skills)、[OpenAI Skills 测试方法](https://developers.openai.com/blog/eval-skills)。

