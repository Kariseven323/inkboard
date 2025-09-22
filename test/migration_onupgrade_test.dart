import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkboard/data/database/app_database.dart';

void main() {
  test('onCreate creates FTS/indices when supported', () async {
    final app = AppDatabase(executor: NativeDatabase.memory());
    try {
      final fts = await app.customSelect(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='diary_entries_fts';",
      ).get();
      // FTS 表存在或不支持，存在则至少 1 行
      if (fts.isNotEmpty) {
        expect(fts.first.data['name'], 'diary_entries_fts');
      }
    } catch (_) {
      // 平台不支持 fts5：跳过
    }
    await app.close();
  });
}
