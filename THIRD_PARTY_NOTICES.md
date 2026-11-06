# 第三方依赖说明

## Codex 内置图片生成能力

本 Skill 在运行时调用 Codex 环境提供的内置图片生成工具。该工具、系统 `imagegen` Skill、模型、服务端实现、图标、脚本及其许可证均不在本仓库中再分发。

安装者需要使用其所在 Codex 版本自带的图片能力，并遵守 OpenAI 的适用条款。内置工具的实际模型名称、快照、费用、配额和可用性不由本仓库控制。

## 历史后处理工具

原工作区曾使用 Python/Pillow、PowerShell/System.Drawing 和 JavaScript/sharp 处理特定成品。这些脚本包含产品专属布局或本机路径，未被核心 Skill 引用，因此不随 v1.0.0 发布；本仓库也不再分发 Pillow、sharp 或其他第三方库。

