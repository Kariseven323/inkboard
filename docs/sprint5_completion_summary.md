# Sprint 5 完成总结：测试、迁移验证与文档

本次 Sprint 目标：完善关键流程测试、数据库迁移验证（空库/存量库）与用户/运维文档。

## 测试工作
- 新增：`test/migration_upgrade_v4_to_v6_test.dart`
  - 构造旧版内存库（`PRAGMA user_version=4`），创建旧结构表
  - 打开 `AppDatabase` 触发升级至 v6
  - 断言：`is_draft`、`deleted_at` 新列存在；`user_profiles` 表创建并插入默认记录（id=1）
- 新增：`test/diary_edit_insert_profile_snippets_test.dart`
  - 注册 `UserProfileRepository` 假实现
  - 验证“插入资料 → 插入昵称”将昵称插入到编辑器光标处
- 既有覆盖（抽样核对）：
  - 主题切换（`theme_*_test.dart`）
  - 资料编辑（`profile_edit_page_test.dart`）
  - 草稿与发布（`diary_edit_save_flows_test.dart`、`diary_edit_markdown_test.dart`）
  - 回收站软删除流程（`home_page_soft_delete_flow_test.dart`）

## 迁移验证
- 空库：`test/migration_onupgrade_test.dart` 验证 onCreate 行为与 FTS/索引容错
- 存量库：`test/migration_upgrade_v4_to_v6_test.dart` 验证从 v4 升级至 v6 的关键变更

## 文档交付
- 新增：`docs/development/DB_MIGRATION_GUIDE.md`（数据库迁移与验证指南）
- 新增：`docs/development/USER_GUIDE.md`（设置/资料中心/草稿/回收站使用指南）
- 更新：`README.md` 文档索引

## 验收结论
- 核心流程测试齐备；迁移路径可验证且有回滚指引；用户文档覆盖主要功能与注意事项。

