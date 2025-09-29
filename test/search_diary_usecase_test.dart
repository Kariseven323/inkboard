import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/domain/services/search_service.dart';
import 'package:inkboard/domain/usecases/search_diary_usecase.dart';

class _OKService implements SearchService {
  @override
  Future<List<SearchResult>> globalSearch(String query) async => const [];

  @override
  Stream<List<DiaryEntry>> searchDiaryEntries(String query) async* {
    yield const [];
  }

  @override
  Stream<List<Tag>> searchTags(String query) async* {
    yield const [];
  }

  @override
  Stream<List<DiaryEntry>> advancedSearchDiaryEntries({String? titleQuery, String? contentQuery, List<int>? tagIds, DateTime? startDate, DateTime? endDate, bool? isFavorite, int? moodScore}) async* {
    yield const [];
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

class _ErrorService extends _OKService {
  @override
  Future<List<SearchResult>> globalSearch(String query) async => throw Exception('boom');

  @override
  Future<List<String>> getSearchSuggestions(String query) async => throw Exception('boom');

  @override
  Future<List<String>> getPopularSearchTerms() async => throw Exception('boom');

  @override
  Future<List<String>> getSearchHistory({int limit = 10}) async => throw Exception('boom');

  @override
  Future<void> clearSearchHistory() async => throw Exception('boom');
}

void main() {
  test('globalSearch 输入裁剪与错误处理', () async {
    final ok = SearchDiaryUseCase(_OKService());
    final r1 = await ok.globalSearch('   ');
    expect(r1.isSuccess, isTrue);
    expect(r1.dataOrThrow, isEmpty);

    final err = SearchDiaryUseCase(_ErrorService());
    final r2 = await err.globalSearch('abc');
    expect(r2.isFailure, isTrue);
    expect(() => r2.dataOrThrow, throwsA(isA<Exception>()));
  });

  test('searchDiaryEntries/Tags 空查询返回空流', () async {
    final ok = SearchDiaryUseCase(_OKService());
    final list1 = await ok.searchDiaryEntries('  ').first;
    final list2 = await ok.searchTags('  ').first;
    expect(list1, isEmpty);
    expect(list2, isEmpty);
  });

  test('getSearchSuggestions/Popular/History 成功与错误', () async {
    final ok = SearchDiaryUseCase(_OKService());
    final s1 = await ok.getSearchSuggestions('a');
    expect(s1.isSuccess, isTrue);
    final p1 = await ok.getPopularSearchTerms();
    expect(p1.isSuccess, isTrue);
    final h1 = await ok.getSearchHistory(limit: 3);
    expect(h1.isSuccess, isTrue);
    final cleared = await ok.clearSearchHistory();
    expect(cleared.isSuccess, isTrue);

    final err = SearchDiaryUseCase(_ErrorService());
    expect((await err.getSearchSuggestions('x')).isFailure, isTrue);
    expect((await err.getPopularSearchTerms()).isFailure, isTrue);
    expect((await err.getSearchHistory(limit: 1)).isFailure, isTrue);
    expect((await err.clearSearchHistory()).isFailure, isTrue);
  });

  test('AdvancedSearchParams.hasAnyCondition 判定', () async {
    final p0 = AdvancedSearchParams();
    expect(p0.hasAnyCondition, isFalse);
    final p1 = AdvancedSearchParams(titleQuery: ' a ');
    expect(p1.hasAnyCondition, isTrue);
    final p2 = AdvancedSearchParams(contentQuery: 'b');
    expect(p2.hasAnyCondition, isTrue);
    final p3 = AdvancedSearchParams(tagIds: [1]);
    expect(p3.hasAnyCondition, isTrue);
    final p4 = AdvancedSearchParams(startDate: DateTime.now());
    expect(p4.hasAnyCondition, isTrue);
    final p5 = AdvancedSearchParams(endDate: DateTime.now());
    expect(p5.hasAnyCondition, isTrue);
    final p6 = AdvancedSearchParams(isFavorite: false);
    expect(p6.hasAnyCondition, isTrue);
    final p7 = AdvancedSearchParams(moodScore: 3);
    expect(p7.hasAnyCondition, isTrue);
  });
}
