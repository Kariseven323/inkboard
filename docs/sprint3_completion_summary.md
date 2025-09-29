# Sprint 3 交付总结（暂存 + 插入资料）

完成项
- 数据层
  - `diary_entries` 新增字段 `isDraft`（Bool，默认 false）。
  - `AppDatabase` 迁移至 schemaVersion=5，onUpgrade 使用 `m.addColumn` 平滑添加列。
- 领域/用例
  - `DiaryEntry` 实体新增 `isDraft` 字段。
  - `CreateDiaryEntryUseCase`、`UpdateDiaryEntryUseCase` 支持草稿：
    - 参数新增 `isDraft`（默认 false），发布严格校验，草稿放宽。
- 编辑器
  - `DiaryEditPage`
    - 新增“暂存”按钮，手动保存为草稿。
    - 自动保存：持续编辑去抖 2s + 周期 5s；空内容不保存；退出时定时器释放。
    - 插入资料：工具栏新增“插入资料”菜单（昵称/签名/邮箱/地区），在光标处插入。
- 测试
  - 新增 `test/profile_edit_page_test.dart`：验证资料保存与持久化；测试结束主动卸载页面，避免定时器导致挂起。

后续建议
- 失焦/后台立即保存可通过 `WidgetsBindingObserver` 捕获生命周期事件触发 `_autoSaveDraft`，必要时再补测。
- 若需列表中过滤草稿/仅显示发布项，可在查询层加默认过滤（当前不改变现有列表逻辑）。
