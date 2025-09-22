import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../core/services/database_key_service.dart';

import '../tables/diary_entries.dart';
import '../tables/tags.dart';
import '../tables/diary_tags.dart';

part 'app_database.g.dart';

/// 应用数据库配置
@lazySingleton
@DriftDatabase(tables: [DiaryEntries, Tags, DiaryTags])
class AppDatabase extends _$AppDatabase {
  /// 构造函数（允许测试传入自定义执行器和密钥服务）
  AppDatabase({QueryExecutor? executor, DatabaseKeyService? keyService})
      : super(executor ?? _openConnection(keyService));

  /// 数据库版本
  @override
  int get schemaVersion => 3;

  /// 数据库迁移逻辑
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();

        // 插入默认标签
        await _insertDefaultTags();

        // 创建 FTS5 和索引（容错）
        await _tryEnsureFts5();
        await _ensureIndices();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // v2: 引入 FTS5（基于标题）与必要索引
        if (from < 2) {
          await _tryEnsureFts5();
          await _ensureIndices();
        }

        // v3: 扩展 FTS 到 (title, content) 并重建触发器
        if (from < 3) {
          await _tryRebuildFts5WithContent();
        }
      },
      beforeOpen: (details) async {
        // 启用外键约束
        await customStatement('PRAGMA foreign_keys = ON');

        // 设置 LIKE 不区分大小写
        await customStatement('PRAGMA case_sensitive_like = OFF');
      },
    );
  }

  /// 插入默认标签
  Future<void> _insertDefaultTags() async {
    final now = DateTime.now();

    final defaultTags = [
      TagsCompanion.insert(
        name: '工作',
        color: const Value('#FF5722'),
        createdAt: now,
        description: const Value('工作相关的记录'),
      ),
      TagsCompanion.insert(
        name: '生活',
        color: const Value('#4CAF50'),
        createdAt: now,
        description: const Value('日常生活记录'),
      ),
      TagsCompanion.insert(
        name: '学习',
        color: const Value('#2196F3'),
        createdAt: now,
        description: const Value('学习笔记和心得'),
      ),
      TagsCompanion.insert(
        name: '思考',
        color: const Value('#9C27B0'),
        createdAt: now,
        description: const Value('个人思考和感悟'),
      ),
      TagsCompanion.insert(
        name: '旅行',
        color: const Value('#FF9800'),
        createdAt: now,
        description: const Value('旅行见闻和体验'),
      ),
    ];

    for (final tag in defaultTags) {
      await into(tags).insert(tag);
    }
  }
  
  /// 容错创建 FTS5（title, content）及触发器
  Future<void> _tryEnsureFts5() async {
    try {
      await customStatement(
        'CREATE VIRTUAL TABLE IF NOT EXISTS diary_entries_fts USING fts5(title, content);',
      );
      await customStatement('''
        CREATE TRIGGER IF NOT EXISTS diary_entries_ai_fts
        AFTER INSERT ON diary_entries BEGIN
          INSERT INTO diary_entries_fts(rowid, title, content) VALUES (new.id, new.title, new.content);
        END;
      ''');
      await customStatement('''
        CREATE TRIGGER IF NOT EXISTS diary_entries_au_fts
        AFTER UPDATE OF title, content ON diary_entries BEGIN
          UPDATE diary_entries_fts SET title = new.title, content = new.content WHERE rowid = new.id;
        END;
      ''');
      await customStatement('''
        CREATE TRIGGER IF NOT EXISTS diary_entries_ad_fts
        AFTER DELETE ON diary_entries BEGIN
          DELETE FROM diary_entries_fts WHERE rowid = old.id;
        END;
      ''');
    } catch (_) {
      // 平台不支持 fts5 时忽略
    }
  }

  /// 将现有仅 title 的 FTS 升级为 (title, content)
  Future<void> _tryRebuildFts5WithContent() async {
    try {
      await customStatement('DROP TABLE IF EXISTS diary_entries_fts;');
      await customStatement(
        'CREATE VIRTUAL TABLE diary_entries_fts USING fts5(title, content);',
      );
      await customStatement('''
        CREATE TRIGGER IF NOT EXISTS diary_entries_ai_fts
        AFTER INSERT ON diary_entries BEGIN
          INSERT INTO diary_entries_fts(rowid, title, content) VALUES (new.id, new.title, new.content);
        END;
      ''');
      await customStatement('''
        CREATE TRIGGER IF NOT EXISTS diary_entries_au_fts
        AFTER UPDATE OF title, content ON diary_entries BEGIN
          UPDATE diary_entries_fts SET title = new.title, content = new.content WHERE rowid = new.id;
        END;
      ''');
      await customStatement('''
        CREATE TRIGGER IF NOT EXISTS diary_entries_ad_fts
        AFTER DELETE ON diary_entries BEGIN
          DELETE FROM diary_entries_fts WHERE rowid = old.id;
        END;
      ''');
      // 回填现有数据
      await customStatement(
        'INSERT INTO diary_entries_fts(rowid, title, content) SELECT id, title, content FROM diary_entries;',
      );
    } catch (_) {}
  }

  /// 常用索引（性能优化）
  Future<void> _ensureIndices() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_diary_entries_created_at ON diary_entries(created_at);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_diary_entries_title ON diary_entries(title);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_tags_name ON tags(name);',
    );
  }
}

/// 打开数据库连接（本地文件，NativeDatabase）
QueryExecutor _openConnection(DatabaseKeyService? keyService) {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'inkboard_database.sqlite'));

    // 使用 NativeDatabase，并在 setup 中尝试设置 SQLCipher 密钥（若可用）
    return NativeDatabase.createInBackground(file, setup: (db) async {
      try {
        final key = keyService != null
            ? await keyService.getOrCreateKey()
            : 'inkboard_default_key';
        db.execute('PRAGMA key = "$key";');
      } catch (_) {}
    });
  });
}
