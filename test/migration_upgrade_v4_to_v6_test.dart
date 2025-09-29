import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:flutter_test/flutter_test.dart';
import 'package:inkboard/data/database/app_database.dart';

/// 模拟从 v4 升级到 v6 的迁移：
/// - v5: 新增 diary_entries.is_draft (默认 false)
/// - v6: 新增 diary_entries.deleted_at (可空)
/// - v4: 引入 user_profiles 表（本测试在升级过程中由迁移创建）
void main() {
  test('从 v4 升级至 v6：新增列与 user_profiles 表创建成功', () async {
    // 1) 构造“旧版”内存数据库（user_version=4），仅包含老表结构
    final sqliteDb = sqlite.sqlite3.openInMemory();
    // diary_entries（无 is_draft、deleted_at）
    sqliteDb.execute('''
      CREATE TABLE diary_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        is_favorite INTEGER NOT NULL DEFAULT 0 CHECK (is_favorite IN (0,1)),
        mood_score INTEGER,
        weather TEXT,
        location TEXT
      );
    ''');
    // tags / diary_tags（与现行一致，无新增列差异）
    sqliteDb.execute('''
      CREATE TABLE tags (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color TEXT NOT NULL DEFAULT '#1877F2',
        created_at INTEGER NOT NULL,
        usage_count INTEGER NOT NULL DEFAULT 0,
        description TEXT
      );
    ''');
    sqliteDb.execute('''
      CREATE TABLE diary_tags (
        diary_entry_id INTEGER NOT NULL,
        tag_id INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        PRIMARY KEY (diary_entry_id, tag_id)
      );
    ''');

    // user_profiles（v4 引入，模拟已存在且含默认记录 id=1）
    sqliteDb.execute('''
      CREATE TABLE user_profiles (
        id INTEGER NOT NULL,
        avatar BLOB,
        nickname TEXT,
        signature TEXT,
        gender TEXT,
        birthday INTEGER,
        region TEXT,
        email TEXT,
        updated_at INTEGER,
        PRIMARY KEY (id)
      );
    ''');
    sqliteDb.execute(
      "INSERT INTO user_profiles(id, updated_at) VALUES (1, strftime('%s','now')); ",
    );

    // 设置为 v4（触发 AppDatabase.onUpgrade from=4 -> to=6）
    sqliteDb.execute('PRAGMA user_version = 4;');

    // 2) 用“旧库”作为执行器打开 AppDatabase，触发迁移
    final raw = NativeDatabase.opened(sqliteDb, enableMigrations: true);
    final app = AppDatabase(executor: raw);

    // 3) 断言：diary_entries 新增列存在
    final diaryInfo = await app
        .customSelect("PRAGMA table_info('diary_entries');")
        .get();
    final cols = diaryInfo.map((r) => r.data['name'] as String).toSet();
    expect(cols.contains('is_draft'), isTrue, reason: 'v5 应新增 is_draft');
    expect(cols.contains('deleted_at'), isTrue, reason: 'v6 应新增 deleted_at');

    // 4) 断言：user_profiles 表存在且默认记录仍在
    final hasUserProfiles = await app
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='user_profiles';",
        )
        .get();
    expect(hasUserProfiles.isNotEmpty, isTrue, reason: '应存在 user_profiles 表');

    final defaultProfile = await app
        .customSelect('SELECT id FROM user_profiles WHERE id = 1;')
        .get();
    expect(defaultProfile.isNotEmpty, isTrue, reason: '应插入默认用户资料记录');

    await app.close();
  });
}
