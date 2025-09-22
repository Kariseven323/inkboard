实现内容：
1) 数据库：AppDatabase 改为 NativeDatabase 文件存储；schemaVersion=2；onCreate/OnUpgrade 创建 FTS5（标题）和常用索引；提供 LazyDatabase 打开，测试可传入 QueryExecutor。
2) 仓储：DiaryEntryRepositoryImpl 注入 EncryptionService，内容透明加解密；搜索结合 FTS（标题）+ 解密后内存过滤（内容）。
3) DI：更新 service_locator.config.dart，将 EncryptionService 注入 DiaryEntryRepositoryImpl。
4) 测试：
  - test/test_helpers.dart 测试装置（内存 DB、加密服务注入）。
  - repository_diary_entry_test.dart 覆盖 CRUD/收藏流/搜索（标题+内容）/日期过滤。
  - repository_tag_test.dart 覆盖 Tag CRUD/搜索/热门与最近/存在性。
  - usecase_create_and_search_test.dart 覆盖创建用例与全局搜索用例。
  - migration_onupgrade_test.dart 构造 v1 文件数据库，验证升级后 FTS 表存在。
未做：不更换底层 sqlite3_flutter_libs 为 sqlcipher_flutter_libs（避免破坏现有平台插件生成）；后续如需 DB 层加密，可在 _openConnection 引入 SQLCipher 并配置 PRAGMA key。