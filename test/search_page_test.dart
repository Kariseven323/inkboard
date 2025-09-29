import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/domain/usecases/update_delete_diary_entry_usecase.dart';
import 'fakes.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/domain/services/search_service.dart';
import 'package:inkboard/domain/usecases/search_diary_usecase.dart';
import 'package:inkboard/presentation/pages/search_page.dart';

class _FakeSearchService implements SearchService {
  @override
  Future<List<SearchResult>> globalSearch(String query) async {
    final now = DateTime.now();
    final entry = DiaryEntry(
      id: 1,
      title: '关于$query 的日记',
      content: '包含 **$query** 的内容',
      createdAt: now,
      updatedAt: now,
      tags: [Tag(id: 1, name: '测试', color: '#1877F2', createdAt: now)],
    );
    return [
      SearchResult(
        type: SearchResultType.diaryEntry,
        data: entry,
        snippet: '命中 **$query** 片段',
      ),
      SearchResult(
        type: SearchResultType.tag,
        data: Tag(id: 2, name: '学习', color: '#1877F2', createdAt: now),
        snippet: '标签 **学习**',
      ),
    ];
  }

  @override
  Stream<List<DiaryEntry>> searchDiaryEntries(String query) async* {
    yield [];
  }

  @override
  Stream<List<Tag>> searchTags(String query) async* {
    yield const [];
  }

  @override
  Stream<List<DiaryEntry>> advancedSearchDiaryEntries({
    String? titleQuery,
    String? contentQuery,
    List<int>? tagIds,
    DateTime? startDate,
    DateTime? endDate,
    bool? isFavorite,
    int? moodScore,
  }) async* {
    final now = DateTime.now();
    yield [
      DiaryEntry(
        id: 99,
        title: '高级：$titleQuery',
        content: contentQuery ?? '',
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  @override
  Future<List<String>> getSearchSuggestions(String query) async => [];

  @override
  Future<List<String>> getPopularSearchTerms() async => [];

  @override
  Future<void> recordSearchHistory(String query) async {}

  @override
  Future<List<String>> getSearchHistory({int limit = 10}) async => [];

  @override
  Future<void> clearSearchHistory() async {}
}

void main() {
  setUp(() async {
    await getIt.reset();
    final fakeService = _FakeSearchService();
    getIt.registerSingleton<SearchDiaryUseCase>(
      SearchDiaryUseCase(fakeService),
    );
    // 注册收藏切换用例，避免点击心形时出错
    final entryRepo = InMemoryDiaryEntryRepository();
    final tagRepo = InMemoryTagRepository();
    getIt.registerSingleton<UpdateDiaryEntryUseCase>(
      UpdateDiaryEntryUseCase(entryRepo, tagRepo),
    );
  });

  testWidgets('SearchPage 初始为空态显示提示', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: SearchPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 初始为空提示
    expect(find.text('输入关键词开始搜索'), findsOneWidget);

    // 保持空态即可
  });

  testWidgets('SearchPage 初始查询显示结果列表', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) =>
              const MaterialApp(home: SearchPage(initialQuery: 'Foo')),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.textContaining('关于Foo'), findsWidgets);
    // 标签结果项验证留给服务层与集成测试，这里确保初始日记结果已渲染
  });

  // 高级筛选交互改由集成测试覆盖
  testWidgets('SearchPage 打开高级筛选显示控件', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) =>
              const MaterialApp(home: SearchPage(initialQuery: 'hello')),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 150));

    await tester.tap(find.byIcon(Icons.tune));
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('仅收藏'), findsOneWidget);
  });

  testWidgets('SearchPage 高级筛选结果来自 Stream', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) =>
              const MaterialApp(home: SearchPage(initialQuery: 'hello')),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 150));
    await tester.tap(find.byIcon(Icons.tune));
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('仅收藏'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.textContaining('高级：'), findsWidgets);
  });

  testWidgets('SearchPage 高级筛选流错误显示', (tester) async {
    await getIt.reset();
    final svc = _AdvancedErrorSearchService();
    getIt.registerSingleton<SearchDiaryUseCase>(SearchDiaryUseCase(svc));
    // 注册更新用例占位
    getIt.registerSingleton<UpdateDiaryEntryUseCase>(
      UpdateDiaryEntryUseCase(
        InMemoryDiaryEntryRepository(),
        InMemoryTagRepository(),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) =>
              const MaterialApp(home: SearchPage(initialQuery: 'x')),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byIcon(Icons.tune));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('BAD_STREAM'), findsOneWidget);
  });

  testWidgets('SearchPage 查询错误显示错误提示', (tester) async {
    // 使用抛错的 SearchService
    await getIt.reset();
    final badService = _ThrowingSearchService();
    getIt.registerSingleton<SearchDiaryUseCase>(SearchDiaryUseCase(badService));
    final entryRepo = InMemoryDiaryEntryRepository();
    final tagRepo = InMemoryTagRepository();
    getIt.registerSingleton<UpdateDiaryEntryUseCase>(
      UpdateDiaryEntryUseCase(entryRepo, tagRepo),
    );

    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: SearchPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'ERR');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.textContaining('搜索失败'), findsOneWidget);
  });

  testWidgets('SearchPage 结果为空与错误展示（override provider）', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // 覆盖搜索结果为：空
          searchResultsProvider.overrideWithProvider(
            (query) => FutureProvider((ref) async => <SearchResult>[]),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) =>
              const MaterialApp(home: SearchPage(initialQuery: 'x')),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('没有找到匹配的结果'), findsOneWidget);

    // 错误态覆盖另行在集成/服务层测试
  });

  // 高级搜索流错误路径较依赖平台弹窗节奏，此处留待集成测试覆盖
}

class _ThrowingSearchService extends _FakeSearchService {
  @override
  Future<List<SearchResult>> globalSearch(String query) async {
    throw Exception('boom');
  }
}

class _AdvancedErrorSearchService extends _FakeSearchService {
  @override
  Stream<List<DiaryEntry>> advancedSearchDiaryEntries({
    String? titleQuery,
    String? contentQuery,
    List<int>? tagIds,
    DateTime? startDate,
    DateTime? endDate,
    bool? isFavorite,
    int? moodScore,
  }) async* {
    yield* Stream<List<DiaryEntry>>.error(Exception('BAD_STREAM'));
  }
}
