# 砚记（Inkboard）多 Sprint 总开发进度计划

> 版本：v1.0（初稿）
> 范围：UI 去脸书化、深/浅色主题、资料中心（头像/签名）、日记暂存、回收站

## 1. 目标与范围
- 主题：完善深/浅色模式，设置页可切换，默认跟随系统；Markdown 渲染在暗色下可读性优化。
- 布局：
  - 顶部移除 f 图标、通知按钮、主页按钮、设置按钮，仅保留搜索框；
  - 左侧侧边栏移除“高级搜索”“我的日记”；
  - 侧边栏“设置”按钮修复可跳转；
  - 侧边栏顶部用户区域可进入“编辑资料”。
- 资料中心：支持头像上传（跨端 file_picker）、昵称与个性签名等资料的填写/持久化；在写日记时可一键插入相关资料片段。
- 编辑器增强：新增“暂存”按钮与草稿状态；继续编辑与发布流程顺畅。
- 回收站：软删除机制，新增侧边栏“回收站”入口，支持恢复与彻底删除。

## 2. 需求确认结果（已确认）
- 目标平台：以 Android 为主（其余平台后续再评估）。
- 用户资料字段：头像、昵称、个性签名、性别、生日、地区、邮箱。
- 暂存策略：提供“手动暂存”与“自动保存”两种机制并存。
- 回收站保留期：默认 30 天，超期自动清理。
- 主题默认：默认“跟随系统”，同时提供手动切换。

提示：自动保存的触发与时间间隔以“持续编辑去抖 + 周期性保存”为原则实现，默认参数：去抖 2 秒、间隔 5 秒；失焦/进入后台将立即保存。可在后续实现中微调。

## 3. 技术栈与关键依赖
- Flutter + Riverpod（应用状态）
- Drift（SQLite 持久化，使用 step-by-step 迁移与 addColumn/alterTable.columnTransformer）
- file_picker（跨平台头像选择：Web/桌面使用 bytes）
- markdown_widget（暗色主题配置与代码高亮主题）

## 4. 里程碑与时间轴（粗排）
- 里程碑 A：完成 S1（第 1 周内）
- 里程碑 B：完成 S2（第 2 周末）
- 里程碑 C：完成 S3（第 3 周中）
- 里程碑 D：完成 S4（第 4 周初）
- 里程碑 E：完成 S5（第 4 周末）

## 5. Sprint 切分与交付

### Sprint 1：UI 去脸书化 + 主题完善
- 目标
  - 去除 Facebook 化元素；保留并强化顶部搜索；修复侧边栏“设置”跳转；深/浅色主题落地到组件细节。
- 交付物
  - 顶部 AppBar：移除 f 图标、通知、主页、设置按钮；仅保留搜索框。
  - 左侧侧边栏：移除“高级搜索”“我的日记”；“设置”可跳转。
  - 主题：暗色/浅色配色、对比度与 hover/focus 状态统一；Markdown 暗色渲染适配。
- 关键改动文件（示例）
  - `lib/presentation/layouts/facebook_layout.dart`
  - `lib/presentation/widgets/common/facebook_left_sidebar.dart`
  - `lib/core/theme/facebook_*.dart`
  - `lib/presentation/pages/settings_page.dart`
  - `lib/main.dart`
- 验收标准
  - 顶部仅含搜索；侧边栏“设置”可正常进入设置页；主题切换与系统跟随皆生效。
- 风险
  - 遗留颜色常量命名“facebook_*”导致混淆；统一改色但保持编译通过。

### Sprint 2：用户资料中心（头像/签名/信息）
- 目标
  - 用户可上传头像、编辑昵称与个性签名，并持久化；侧边栏头像/顶部头像点击进入编辑页。
- 交付物
  - Drift 表与仓库：`user_profile`（id=1、avatar BLOB、nickname、signature、gender、birthday、region、email、updatedAt…）。
  - 资料编辑页：头像选择（file_picker）、预览、保存；输入校验与状态反馈。
  - 展示与入口：侧边栏/顶部头像读取资料显示。
- 关键改动/新增文件（示例）
  - `lib/data/tables/user_profile.dart`（新增）
  - `lib/data/repositories/user_profile_repository_impl.dart`（新增）
  - `lib/presentation/pages/profile_edit_page.dart`（新增）
  - `lib/presentation/widgets/common/facebook_left_sidebar.dart`（入口绑定）
- 验收标准
  - 头像可跨端选择与持久化显示；昵称/签名/性别/生日/地区/邮箱保存后侧边栏与编辑页可见；邮箱格式校验通过。
- 风险
  - iOS 自定义类型需 UTI 配置；Web/桌面路径不可用需 bytes 方案。

### Sprint 3：编辑器增强（暂存 + 一键插入资料）
- 目标
  - 日记“暂存”（草稿）能力；编辑时一键插入用户资料片段（昵称/签名…）。
- 交付物
  - Drift 迁移：`diary_entries` 增加 `isDraft`（或 `status`）。
  - 编辑页：新增“暂存”按钮；工具栏“插入资料”菜单，光标处插入 Markdown 片段（可选择插入昵称/签名/邮箱/地区等）。
  - 自动保存：持续编辑状态下自动保存为草稿（不打扰用户），采用去抖与周期性保存组合（默认参数：去抖 2 秒、间隔 5 秒；失焦/进入后台立即保存）。
  - Provider：`UserProfileProvider` 读资料；编辑器状态管理与插入接口。
- 关键改动文件（示例）
  - `lib/data/tables/diary_entries.dart`、`lib/data/database/app_database.dart`
  - `lib/presentation/pages/diary_edit_page.dart`
- 验收标准
  - 草稿可见且可继续编辑；“插入资料”在光标位置插入正确文本并正常渲染；自动保存在持续编辑与失焦场景有效，且不影响手动“暂存”。
- 风险
  - 光标定位在不同平台输入法下的兼容性；需实际端测。

### Sprint 4：回收站机制（软删除）
- 目标
  - 删除操作改为软删除；回收站页面支持恢复与彻底删除（可批量）。
- 交付物
  - Drift 迁移：`diary_entries` 增加 `deletedAt`（或 `isDeleted`）。
  - 查询默认排除已删除项；回收站页面（过滤、批量恢复/彻底删除）。
  - 侧边栏新增“回收站”入口。
  - 自动清理：回收站内超过 30 天的条目在应用启动或定时维护任务中自动清理（不影响手动“彻底删除”）。
- 关键改动/新增文件（示例）
  - `lib/data/tables/diary_entries.dart`、`lib/data/repositories/diary_entry_repository_impl.dart`
  - `lib/presentation/pages/recycle_bin_page.dart`（新增）
  - `lib/presentation/widgets/common/facebook_left_sidebar.dart`
- 验收标准
  - 正常列表不含已删除；回收站可恢复或彻底删除；批量操作可用；超过 30 天的条目按策略自动清理。
- 风险
  - 与收藏/搜索/标签联动的过滤一致性，需要回归。

### Sprint 5：测试、迁移验证与文档
- 目标
  - 完成关键流程测试、迁移验证与用户文档。
- 交付物
  - 测试：主题切换、资料编辑、暂存与插入、回收站的集成/Widget 测试。
  - 迁移：在空库与存量库双场景验证；备份/回滚指引。
  - 文档：设置/资料中心/草稿/回收站使用说明与注意事项。
- 验收标准
  - 核心流程测试通过；迁移稳定无数据丢失；文档可用。

## 6. 数据库迁移策略（Drift）
- 使用 step-by-step 迁移与 `m.addColumn`/`alterTable.columnTransformer`；为存量数据提供默认值或允许空。
- BLOB 字段（头像）存储；必要时考虑缩略图或尺寸上限。
- 软删除字段（`deletedAt` 或 `isDeleted`）与草稿字段（`isDraft`/`status`）同时引入时，建议分两次迁移降低风险。

## 7. 设计与可用性规范
- 暗色可读性：正文/次级文本/分隔线/阴影对比度符合规范；Markdown 代码块与链接在暗色下清晰。
- 悬停/聚焦：输入框与按钮 hover/focus 有清晰反馈；键盘可达性（Tab 焦点）保留。
- 头像：裁剪与尺寸策略（最小/最大像素），失败回退为首字母占位。

## 8. 风险与缓解
- 多端文件选择差异（移动端系统选择器/桌面权限/Web 无路径）：统一用 bytes；必要时平台分支。
- Drift 迁移：提供备份与回滚脚本；在测试库反复演练。
- 主题改色：去“facebook_*”命名带来的认知成本——先保持命名不变，仅调整值，后续再重构命名。

## 9. 验收与发布清单
- 功能走查：主题/导航/资料/编辑器/回收站核心链路全通。
- 数据安全：迁移零报错、零丢失；回收站操作可逆（恢复）与不可逆（彻底删除）逻辑一致。
- 文档完善：设置页说明、资料中心与头像、草稿与插入、回收站；备份导出提示。
- 版本标记与变更日志：记录功能点与迁移注意事项。

---

附：涉及的主要文件（非穷举）
- `lib/presentation/layouts/facebook_layout.dart`
- `lib/presentation/widgets/common/facebook_left_sidebar.dart`
- `lib/presentation/pages/diary_edit_page.dart`
- `lib/presentation/pages/settings_page.dart`
- `lib/presentation/pages/recycle_bin_page.dart`（新增）
- `lib/data/tables/diary_entries.dart`
- `lib/data/tables/user_profile.dart`（新增）
- `lib/data/database/app_database.dart`
- `lib/data/repositories/*.dart`
- `lib/presentation/providers/*.dart`

说明：若“需求待澄清”中的问题确认后，将据此细化每个 Sprint 的任务清单与工时，并进入实施。
