import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../services/database_key_service.dart';

@module
abstract class DiModules {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  // 提供 QueryExecutor，供 AppDatabase 构造函数注入
  @lazySingleton
  QueryExecutor appQueryExecutor(DatabaseKeyService keyService) {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'inkboard_database.sqlite'));
      return NativeDatabase.createInBackground(
        file,
        setup: (db) async {
          try {
            final key = await keyService.getOrCreateKey();
            db.execute('PRAGMA key = "$key";');
          } catch (_) {}
        },
      );
    });
  }
}
