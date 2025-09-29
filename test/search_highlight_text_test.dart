import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/domain/services/search_service.dart';
import 'package:inkboard/domain/usecases/search_diary_usecase.dart';
import 'package:inkboard/presentation/pages/search_page.dart';

class _Svc implements SearchService {
  @override
  Future<List<SearchResult>> globalSearch(String query) async {
    final now = DateTime.now();
    final entry = DiaryEntry(id: 1, title: 't', content: 'c', createdAt: now, updatedAt: now, tags: [Tag(id: 1, name: '标签', color: '#1877F2', createdAt: now)]);
    return [SearchResult(type: SearchResultType.diaryEntry, data: entry, snippet: '命中 **ABC** 片段')];
  }
  @override
  Stream<List<DiaryEntry>> searchDiaryEntries(String query) async* { yield const []; }
  @override
  Stream<List<Tag>> searchTags(String query) async* { yield const []; }
  @override
  Stream<List<DiaryEntry>> advancedSearchDiaryEntries({String? titleQuery, String? contentQuery, List<int>? tagIds, DateTime? startDate, DateTime? endDate, bool? isFavorite, int? moodScore}) async* { yield const []; }
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
  testWidgets('SearchPage 片段高亮粗体渲染', (tester) async {
    await getIt.reset();
    getIt.registerSingleton<SearchDiaryUseCase>(SearchDiaryUseCase(_Svc()));

    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: SearchPage(initialQuery: 'ABC')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 找到包含“命中 ”的 RichText
    final richTexts = find.byWidgetPredicate((w) => w is RichText);
    bool hasBold = false;
    for (final e in richTexts.evaluate()) {
      final w = e.widget as RichText;
      final span = w.text;
      if (span is TextSpan && (span.toPlainText().contains('命中') || span.toPlainText().contains('片段'))) {
        final children = span.children ?? const [];
        for (final c in children) {
          if (c is TextSpan && (c.text?.contains('ABC') ?? false)) {
            final fw = c.style?.fontWeight;
            if (fw == FontWeight.w600 || fw == FontWeight.bold) {
              hasBold = true;
            }
          }
        }
      }
    }
    expect(hasBold, isTrue);
  });
}

