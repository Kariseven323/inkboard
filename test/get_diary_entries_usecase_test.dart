import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/usecases/get_diary_entries_usecase.dart';
import 'package:inkboard/domain/entities/tag.dart';

import 'fakes.dart';

void main() {
  test('GetDiaryEntriesUseCase 基本流与统计/查询', () async {
    final repo = InMemoryDiaryEntryRepository();
    final uc = GetDiaryEntriesUseCase(repo);
    final now = DateTime.now();
    await repo.createDiaryEntry(
      DiaryEntry(
        id: 1,
        title: 'A',
        content: 'a',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await repo.createDiaryEntry(
      DiaryEntry(
        id: 2,
        title: 'B',
        content: 'b',
        createdAt: now,
        updatedAt: now,
        isFavorite: true,
      ),
    );

    // 全量
    final all = await uc.getAllEntries().first;
    expect(all.length, 2);
    // 收藏
    final fav = await uc.getFavoriteEntries().first;
    expect(fav.length, 1);
    // 日期范围
    final byDate = await uc
        .getEntriesByDateRange(
          now.subtract(const Duration(days: 1)),
          now.add(const Duration(days: 1)),
        )
        .first;
    expect(byDate.length, 2);
    // 按标签（给一条加上id=1标签）
    final tagged = all.first.copyWith(
      tags: [Tag(id: 1, name: 'T1', color: '#1877F2', createdAt: now)],
    );
    await repo.updateDiaryEntry(tagged);
    final byTags = await uc.getEntriesByTags(const [1]).first;
    expect(byTags.length, 1);

    // 根据ID与统计
    final one = await uc.getEntryById(1);
    expect(one.isSuccess, isTrue);
    final stats = await uc.getStatistics();
    expect(stats.isSuccess, isTrue);
    final s = stats.dataOrThrow;
    expect(s.totalCount, 2);
    expect(s.favoriteCount, 1);
    expect(s.favoriteRate, closeTo(0.5, 0.0001));
    expect(s.getAverageMonthlyEntries(2), closeTo(1.0, 0.0001));
  });

  test('GetDiaryEntriesUseCase getEntryById 未找到', () async {
    final repo = InMemoryDiaryEntryRepository();
    final uc = GetDiaryEntriesUseCase(repo);
    final r = await uc.getEntryById(999);
    expect(r.isFailure, isTrue);
  });
}
