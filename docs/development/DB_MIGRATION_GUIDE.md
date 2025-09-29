# Inkboard 数据库迁移与验证指南（Drift/SQLite）

适用版本：schemaVersion 6（含）及之前版本的升级路径

目标：保证“空库（新安装）”与“存量库（旧版本升级）”两场景下，迁移安全、可验证、可回滚。

## 一、迁移范围与版本
- v2：引入 FTS5（全文检索）与索引
- v3：FTS 从 title 扩展至 (title, content) 并重建触发器
- v4：新增 `user_profiles` 表并插入默认记录（id=1）
- v5：`diary_entries` 新增 `is_draft`（默认 false）
- v6：`diary_entries` 新增 `deleted_at`（软删除时间，NULL 表示未删除）

数据库类：`lib/data/database/app_database.dart`（`schemaVersion = 6`，`MigrationStrategy` 分步迁移）

## 二、验证步骤

### 场景 A：空库（新安装）
1. 清理应用数据或更换新的数据库文件
2. 启动应用或在测试中构造 `NativeDatabase.memory()`
3. 预期：
   - 所有表一次性创建成功（`m.createAll()`）
   - 默认标签插入完成
   - FTS/索引创建成功（若平台支持 FTS5）
   - `user_profiles` 存在且含默认记录（id=1）

测试参考：`test/migration_onupgrade_test.dart`

### 场景 B：存量库（旧版本升级）
1. 准备旧库（真实设备或测试构造）：设置 `PRAGMA user_version = 4`，并具有旧版表结构
2. 打开新版 `AppDatabase`，触发 `onUpgrade(from=4 → to=6)`
3. 预期：
   - `diary_entries` 自动增加 `is_draft`、`deleted_at`
   - 创建 `user_profiles`（若不存在）并插入默认记录 id=1
   - 其他数据保持不丢失

测试参考：`test/migration_upgrade_v4_to_v6_test.dart`

## 三、备份与回滚

迁移前建议用户或 CI 做一次完整备份：
- Android：备份 `Android/data/<applicationId>/files/inkboard_database.sqlite`
- 桌面：备份应用文档目录下的 `inkboard_database.sqlite`

回滚策略：
- 若迁移后异常，可回退到旧版本 App 并用备份文件覆盖，确保 `user_version` ≤ 目标版本
- 不建议跨越多个大版本直接回退；必要时分步回退并验证

## 四、常见问题与排查
- FTS5 不支持：部分平台不支持 FTS5，代码已做 try/catch 容错；检索仍可用基本 LIKE
- 旧库缺少基础表：真实升级路径不会缺少 v1 的基础表；若测试构造库时遗漏，请先按旧结构补齐
- 默认值与旧数据：新增列使用默认值（如 `is_draft=false`），旧数据不会丢失；若需要批量回填，可添加一次性 SQL 脚本

## 五、开发建议
- 保持“小步迁移”：一个版本只做少量字段/表变更，降低风险
- 为每次迁移补充测试：空库创建 + 指定 from→to 升级
- 在 `beforeOpen` 中执行只读或清理逻辑（如软删超过 30 天自动清理）

---

附：相关文件
- `lib/data/database/app_database.dart`
- `lib/data/tables/*.dart`
- `test/migration_onupgrade_test.dart`
- `test/migration_upgrade_v4_to_v6_test.dart`

