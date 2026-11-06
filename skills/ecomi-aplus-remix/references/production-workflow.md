# 生产工作流

本文件只补充真实生产会话中反复出现、但原核心文件没有完整表达的通用规则。用户当前任务的明确要求优先。

## 1. 建立图片角色矩阵

生成前用一句话确认每张图的角色，不要只按顺序猜测：

- `layout_reference`：仅提供版式、人物位置、姿势、机位、取景、场景、光线或文字区域。
- `product_authority`：提供服装颜色、印花、材质、领口、袖长、下摆、口袋、侧缝、版型和 Logo 等事实。
- `identity_authority`：提供人物身份、面部、发型、年龄感、真实体型和人体比例。
- `negative_annotation`：只指出禁止出现的结构或区域；框线、箭头、遮罩和说明文字不得进入成品。
- `edit_target`：已有成品，后续只修改用户指定的项目。

多个产品图通常是同一商品或同一人物的不同角度，应共同用于消除遮挡和结构歧义；不要把它们误当成需要同时出现在成品中的多个人物。

## 2. 生成前写出不变量

提示词至少明确以下优先级：

1. 用户明确要求。
2. 产品图中的客观服装事实与人物自然比例。
3. 参考图的取景、构图、姿势、机位与场景逻辑。
4. 可自由生成的背景、道具和装饰。

服装不变量按实际可见证据列出，不从参考图继承：颜色与色调、印花单元和密度、领口、袖长、衣长/裤长、松量、裤腿收窄程度、口袋数量/位置/开口、侧缝、腰头、材质纹理、Logo 和配件。证据不清楚时保持简单，不发明多余口袋、拼接、饰条或功能。

## 3. 提示词结构

按以下结构组织内置图片生成工具的提示词；内容使用本任务图片事实替换，不能照抄某个历史商品：

```text
Use case: identity-preserve / compositing / precise-object-edit
Asset type and intended aspect ratio or final pixel size

Input roles:
- Image N = layout reference only
- Image N = product and/or identity authority
- Image N = negative annotation only or edit target

Primary request
Product invariants
Identity and body fidelity
Composition and exact crop
Scene, camera, lighting and commercial style
Text supplied or explicitly retained by the user
Hard constraints and avoid list
Output one finished image
```

本地文件全部有路径时，把所有目标图片一次传给内置工具；若图片只存在于最近对话，使用当前工具允许的最小最近图片数量。不要同时使用两种图片传入方式。

## 4. 多页与多版本

- 用户要求多张成品时，每张版式分别调用一次并分别保存；不要让工具把多页拼成一张未要求的拼图。
- 同一版式的多商品/多颜色任务，先明确哪个商品出现在每个区域。
- 版本化命名使用不覆盖形式，例如 `name-v1`、`name-v2`；每一版保存对应最终提示词。

## 5. 定向返工

已有成品需要修改时，把当前成品设为 `edit_target`，同时保留必要的产品/人物权威图。提示词写清：

- 这是唯一允许改变的项目。
- 必须保持不变的构图、人物、服装、背景、文字和尺寸。
- 修正后重新执行完整质量检查，不能只检查被修改区域。

人物比例、身份或服装结构发生漂移时，优先回到原产品图重新合成；不要在已经漂移的版本上连续累积修改。

## 6. 文案和尺寸

- 只有用户提供准确文案，或明确要求保留且有权使用参考文案时才逐字呈现；否则生成无字底图。
- “4K”不是具体像素尺寸。用户同时给出像素时以像素为验收值；只给比例时以比例为准。
- 图片工具的提示词尺寸不等于实际文件尺寸。交付前必须读取成品像素；若不一致，安全地后处理或明确报告未达到，不能虚报。

## 7. 保存与交付

保存到当前任务可写目录，使用相对或动态工作区路径，不把个人盘符写入 Skill。交付时说明：最终路径、像素尺寸、使用的内置生成模式、最终提示词位置、返工次数和仍需人工确认的项目。

