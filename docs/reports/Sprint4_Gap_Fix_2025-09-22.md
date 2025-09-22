# Sprint 4 缺口补全记录（Markdown 编辑 + 实时预览）

## 变更概览
- 新增依赖：`markdown_widget: ^2.3.2+8`
- 编辑页：`lib/presentation/pages/diary_edit_page.dart`
  - 集成 Markdown 渲染（`MarkdownWidget`）
  - 增加 Markdown 工具栏（粗体、斜体、H1、H2、列表、引用、代码块）
  - 宽屏左右分栏（编辑 / 实时预览），窄屏 SegmentedButton 在“编辑 / 预览”间切换
  - 监听输入实时刷新预览

## 验收对齐
- INK-013：发布区创建新日记 + Markdown 编辑 → 已集成 Markdown 渲染与编辑工具栏
- INK-014：编辑已有日记 + 实时预览 → 已提供实时预览（宽屏分栏、窄屏切换），随输入变化

## 使用说明
- 运行：
  1. `flutter pub get`
  2. 启动应用，进入发布区打开编辑页
- 在编辑页：
  - 顶部工具栏可快速插入 Markdown 语法
  - 宽屏自动分栏；窄屏通过右上角 SegmentedButton 切换“编辑/预览”

## 后续建议
- 可引入语法高亮/主题定制，增强预览视觉
- 如需更强编辑体验，可评估 `flutter_quill` 等富文本编辑器（但需保持与 Markdown 的一致性）
