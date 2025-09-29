import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';

void main() {
  final harness = TestHarness();

  setUp(() async {
    await harness.setUp();
  });

  tearDown(() async {
    await harness.tearDown();
  });

  test(
    'create/read/update/delete diary entry with encryption + tags',
    () async {
      // prepare tag
      final tagId = await harness.tagRepo.createTag(
        Tag(name: '编程', color: '#FF5722', createdAt: DateTime.now()),
      );
      final tag = await harness.tagRepo.getTagById(tagId);
      expect(tag, isNotNull);

      final now = DateTime.now();
      final entryId = await harness.diaryRepo.createDiaryEntry(
        DiaryEntry(
          title: '第一篇',
          content: '这是敏感内容 secret-123',
          createdAt: now,
          updatedAt: now,
          tags: [if (tag != null) tag],
        ),
      );
      expect(entryId, greaterThan(0));

      final fetched = await harness.diaryRepo.getDiaryEntryById(entryId);
      expect(fetched, isNotNull);
      expect(fetched!.content, contains('secret-123'));
      expect(fetched.tags.map((t) => t.name).toList(), contains('编程'));

      final updated = await harness.diaryRepo.updateDiaryEntry(
        fetched.copyWith(title: '更新后的标题', isFavorite: true),
      );
      expect(updated, isTrue);

      final favStream = harness.diaryRepo.getFavoriteDiaryEntries();
      final favList = await favStream.first;
      expect(favList.length, 1);
      expect(favList.first.title, '更新后的标题');

      final deleted = await harness.diaryRepo.deleteDiaryEntry(entryId);
      expect(deleted, isTrue);
      final afterDelete = await harness.diaryRepo.getDiaryEntryById(entryId);
      expect(afterDelete, isNull);
    },
  );

  test('search supports title/content (content decrypted path)', () async {
    final now = DateTime.now();
    final id1 = await harness.diaryRepo.createDiaryEntry(
      DiaryEntry(
        title: '周会纪要',
        content: '本周重点：完善加密与全文搜索',
        createdAt: now,
        updatedAt: now,
      ),
    );

    // 搜索标题命中
    final s1 = await harness.diaryRepo.searchDiaryEntries('纪要').first;
    expect(s1.map((e) => e.id).toList(), contains(id1));

    // 搜索内容命中（需要解密后过滤）
    final s2 = await harness.diaryRepo.searchDiaryEntries('加密').first;
    expect(s2.map((e) => e.id).toList(), contains(id1));
  });

  test('date range filter', () async {
    final now = DateTime.now();
    final id = await harness.diaryRepo.createDiaryEntry(
      DiaryEntry(title: '范围内', content: 'test', createdAt: now, updatedAt: now),
    );

    final list = await harness.diaryRepo
        .getDiaryEntriesByDateRange(
          now.subtract(const Duration(days: 1)),
          now.add(const Duration(days: 1)),
        )
        .first;
    expect(list.any((e) => e.id == id), isTrue);

    final empty = await harness.diaryRepo
        .getDiaryEntriesByDateRange(
          now.add(const Duration(days: 1)),
          now.add(const Duration(days: 2)),
        )
        .first;
    expect(empty, isEmpty);
  });
}
