import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/data/database/app_database.dart';
import 'package:inkboard/data/repositories/diary_entry_repository_impl.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';

void main() {
  late AppDatabase db;
  late DiaryEntryRepositoryImpl repo;

  setUp(() {
    db = AppDatabase(executor: NativeDatabase.memory());
    repo = DiaryEntryRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('DiaryEntryRepositoryImpl full flows', () async {
    // 准备标签
    final tagId1 = await db.into(db.tags).insert(TagsCompanion.insert(name: 'T1', createdAt: DateTime.now()));
    final tagId2 = await db.into(db.tags).insert(TagsCompanion.insert(name: 'T2', createdAt: DateTime.now()));

    final now = DateTime.now();
    final entry = DiaryEntry(
      title: '标题A',
      content: '内容abc',
      createdAt: now,
      updatedAt: now,
      tags: [Tag(id: tagId1, name: 'T1', color: '#1877F2', createdAt: now)],
    );
    final id = await repo.createDiaryEntry(entry);
    expect(id, greaterThan(0));

    // 读取 by id
    final got = await repo.getDiaryEntryById(id);
    expect(got, isNotNull);
    expect(got!.tags.length, 1);

    // 标签流筛选
    final byTags = await repo.getDiaryEntriesByTags([tagId1]).first;
    expect(byTags.length, 1);

    // 日期范围筛选
    final byDate = await repo.getDiaryEntriesByDateRange(now.subtract(const Duration(days: 1)), now.add(const Duration(days: 1))).first;
    expect(byDate.length, greaterThanOrEqualTo(1));

    // FTS 不存在时，search fallback 到标题/内容匹配
    final search = await repo.searchDiaryEntries('abc').first;
    expect(search.length, 1);

    // add/remove tag
    final addOk = await repo.addTagToEntry(id, tagId2);
    expect(addOk, isTrue);
    final addDup = await repo.addTagToEntry(id, tagId2);
    expect(addDup, isFalse);
    final remOk = await repo.removeTagFromEntry(id, tagId2);
    expect(remOk, isTrue);

    // update（日记 + 标签全量替换）
    final updated = await repo.updateDiaryEntry(entry.copyWith(id: id, title: '标题B', tags: [Tag(id: tagId2, name: 'T2', color: '#FF9800', createdAt: now)]));
    expect(updated, isTrue);
    final got2 = await repo.getDiaryEntryById(id);
    expect(got2!.title, '标题B');
    expect(got2.tags.first.id, tagId2);

    // toggleFavorite
    final toggled = await repo.toggleFavorite(id);
    expect(toggled, isTrue);
    final toggled2 = await repo.toggleFavorite(id);
    expect(toggled2, isTrue);

    // 统计
    final stats = await repo.getDiaryStatistics();
    expect(stats['total'], greaterThanOrEqualTo(1));

    // 批量删除：空/非空
    final delEmpty = await repo.deleteDiaryEntries(const []);
    expect(delEmpty, isFalse);
    final delOk = await repo.deleteDiaryEntries([id]);
    expect(delOk, isTrue);
  });
}
