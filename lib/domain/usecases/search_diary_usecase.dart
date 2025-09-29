import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../common/result.dart';
import '../entities/diary_entry.dart';
import '../entities/tag.dart';
import '../services/search_service.dart';

/// 搜索日记用例
@injectable
class SearchDiaryUseCase {
  final SearchService _searchService;

  SearchDiaryUseCase(this._searchService);

  /// 全局搜索（日记和标签）
  Future<Result<List<SearchResult>>> globalSearch(String query) async {
    try {
      if (query.trim().isEmpty) {
        return Result.success([]);
      }

      final results = await _searchService.globalSearch(query.trim());
      return Result.success(results);
    } catch (e) {
      return Result.failure('搜索失败: $e');
    }
  }

  /// 搜索日记条目
  Stream<List<DiaryEntry>> searchDiaryEntries(String query) {
    if (query.trim().isEmpty) {
      return Stream.value([]);
    }
    return _searchService.searchDiaryEntries(query.trim());
  }

  /// 搜索标签
  Stream<List<Tag>> searchTags(String query) {
    if (query.trim().isEmpty) {
      return Stream.value([]);
    }
    return _searchService.searchTags(query.trim());
  }

  /// 高级搜索日记条目
  Stream<List<DiaryEntry>> advancedSearch(AdvancedSearchParams params) {
    return _searchService.advancedSearchDiaryEntries(
      titleQuery: params.titleQuery?.trim(),
      contentQuery: params.contentQuery?.trim(),
      tagIds: params.tagIds,
      startDate: params.startDate,
      endDate: params.endDate,
      isFavorite: params.isFavorite,
      moodScore: params.moodScore,
    );
  }

  /// 获取搜索建议
  Future<Result<List<String>>> getSearchSuggestions(String query) async {
    try {
      final suggestions = await _searchService.getSearchSuggestions(query.trim());
      return Result.success(suggestions);
    } catch (e) {
      return Result.failure('获取搜索建议失败: $e');
    }
  }

  /// 获取热门搜索词
  Future<Result<List<String>>> getPopularSearchTerms() async {
    try {
      final terms = await _searchService.getPopularSearchTerms();
      return Result.success(terms);
    } catch (e) {
      return Result.failure('获取热门搜索词失败: $e');
    }
  }

  /// 获取搜索历史
  Future<Result<List<String>>> getSearchHistory({int limit = 10}) async {
    try {
      final history = await _searchService.getSearchHistory(limit: limit);
      return Result.success(history);
    } catch (e) {
      return Result.failure('获取搜索历史失败: $e');
    }
  }

  /// 清除搜索历史
  Future<Result<bool>> clearSearchHistory() async {
    try {
      await _searchService.clearSearchHistory();
      return Result.success(true);
    } catch (e) {
      return Result.failure('清除搜索历史失败: $e');
    }
  }
}

/// 高级搜索参数
class AdvancedSearchParams extends Equatable {
  final String? titleQuery;
  final String? contentQuery;
  final List<int>? tagIds;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isFavorite;
  final int? moodScore;

  const AdvancedSearchParams({
    this.titleQuery,
    this.contentQuery,
    this.tagIds,
    this.startDate,
    this.endDate,
    this.isFavorite,
    this.moodScore,
  });

  /// 检查是否有任何搜索条件
  bool get hasAnyCondition {
    return (titleQuery?.isNotEmpty == true) ||
        (contentQuery?.isNotEmpty == true) ||
        (tagIds?.isNotEmpty == true) ||
        startDate != null ||
        endDate != null ||
        isFavorite != null ||
        moodScore != null;
  }

  @override
  List<Object?> get props {
    final normalizedTags = tagIds == null
        ? null
        : (List<int>.from(tagIds!)..sort());
    return [
      titleQuery?.trim(),
      contentQuery?.trim(),
      normalizedTags,
      startDate?.millisecondsSinceEpoch,
      endDate?.millisecondsSinceEpoch,
      isFavorite,
      moodScore,
    ];
  }
}
