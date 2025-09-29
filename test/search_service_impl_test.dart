import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/data/services/search_service_impl.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';

import 'fakes.dart';

void main() {
  group('SearchServiceImpl', () {
    test('globalSearch / suggestions / history / popular', () async {
      final entryRepo = InMemoryDiaryEntryRepository();
      final tagRepo = InMemoryTagRepository();
      final search = SearchServiceImpl(entryRepo, tagRepo);

      final now = DateTime.now();
      // 造一些数据
      final t1 = Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now);
      final t2 = Tag(
        id: 2,
        name: '学习',
        color: '#1877F2',
        createdAt: now,
        usageCount: 2,
      );

      await tagRepo.createTag(t1);
      await tagRepo.createTag(t2);

      await entryRepo.createDiaryEntry(
        DiaryEntry(
          title: '今天的工作日志',
          content: '完成了搜索功能，以及单元测试',
          createdAt: now,
          updatedAt: now,
          tags: [t1],
        ),
      );
      await entryRepo.createDiaryEntry(
        DiaryEntry(
          title: 'Flutter 学习笔记',
          content: '测试与覆盖率统计',
          createdAt: now,
          updatedAt: now,
          isFavorite: true,
          tags: [t2],
        ),
      );

      // globalSearch（排序、片段）
      final results = await search.globalSearch('学习');
      expect(results.isNotEmpty, true);
      // 顶部应更相关（标题命中）
      expect(results.first.relevanceScore >= results.last.relevanceScore, true);
      expect(results.first.snippet.isNotEmpty, true);

      // suggestions（来自标签与历史）
      await search.recordSearchHistory('工作周报');
      final sugg = await search.getSearchSuggestions('工');
      expect(sugg.any((s) => s.contains('工作')), true);

      // popular terms（来源热门标签）
      final pop = await search.getPopularSearchTerms();
      expect(pop.isNotEmpty, true);

      // history limit & clear
      final h1 = await search.getSearchHistory(limit: 1);
      expect(h1.length, 1);
      await search.clearSearchHistory();
      final h2 = await search.getSearchHistory();
      expect(h2, isEmpty);
    });

    test('advancedSearchDiaryEntries filters', () async {
      final entryRepo = InMemoryDiaryEntryRepository();
      final tagRepo = InMemoryTagRepository();
      final search = SearchServiceImpl(entryRepo, tagRepo);
      final now = DateTime.now();

      final t1 = Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now);
      final t2 = Tag(id: 2, name: '生活', color: '#1877F2', createdAt: now);
      await tagRepo.createTag(t1);
      await tagRepo.createTag(t2);

      final e1 = DiaryEntry(
        id: 1,
        title: '工作日报',
        content: '修复了一个棘手的 bug',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now,
        isFavorite: true,
        moodScore: 4,
        tags: [t1],
      );
      final e2 = DiaryEntry(
        id: 2,
        title: '周末生活',
        content: '郊游与摄影',
        createdAt: now,
        updatedAt: now,
        isFavorite: false,
        moodScore: 3,
        tags: [t2],
      );
      await entryRepo.createDiaryEntry(e1);
      await entryRepo.createDiaryEntry(e2);

      // 标题过滤
      final byTitle = await search
          .advancedSearchDiaryEntries(titleQuery: '工作')
          .first;
      expect(byTitle.length, 1);
      // 内容过滤
      final byContent = await search
          .advancedSearchDiaryEntries(contentQuery: '摄影')
          .first;
      expect(byContent.length, 1);
      // 标签过滤
      final byTag = await search
          .advancedSearchDiaryEntries(tagIds: const [1])
          .first;
      expect(byTag.length, 1);
      // 日期范围过滤
      final byDate = await search
          .advancedSearchDiaryEntries(
            startDate: now.subtract(const Duration(days: 1)),
          )
          .first;
      expect(byDate.any((e) => e.title == '周末生活'), true);
      // 收藏过滤
      final byFav = await search
          .advancedSearchDiaryEntries(isFavorite: true)
          .first;
      expect(byFav.any((e) => e.title == '工作日报'), true);
      // 心情过滤
      final byMood = await search
          .advancedSearchDiaryEntries(moodScore: 3)
          .first;
      expect(byMood.any((e) => e.title == '周末生活'), true);
    });
  });
}
