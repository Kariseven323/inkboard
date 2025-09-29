import '../entities/diary_entry.dart';
import '../entities/tag.dart';

/// 搜索结果类型
enum SearchResultType { diaryEntry, tag }

/// 搜索结果项
class SearchResult {
  final SearchResultType type;
  final dynamic data; // DiaryEntry 或 Tag
  final String snippet; // 搜索片段
  final double relevanceScore; // 相关性评分

  const SearchResult({
    required this.type,
    required this.data,
    required this.snippet,
    this.relevanceScore = 0.0,
  });
}

/// 搜索服务接口
abstract class SearchService {
  /// 全局搜索（日记和标签）
  Future<List<SearchResult>> globalSearch(String query);

  /// 搜索日记条目
  Stream<List<DiaryEntry>> searchDiaryEntries(String query);

  /// 搜索标签
  Stream<List<Tag>> searchTags(String query);

  /// 高级搜索日记条目
  Stream<List<DiaryEntry>> advancedSearchDiaryEntries({
    String? titleQuery,
    String? contentQuery,
    List<int>? tagIds,
    DateTime? startDate,
    DateTime? endDate,
    bool? isFavorite,
    int? moodScore,
  });

  /// 获取搜索建议
  Future<List<String>> getSearchSuggestions(String query);

  /// 获取热门搜索词
  Future<List<String>> getPopularSearchTerms();

  /// 记录搜索历史
  Future<void> recordSearchHistory(String query);

  /// 获取搜索历史
  Future<List<String>> getSearchHistory({int limit = 10});

  /// 清除搜索历史
  Future<void> clearSearchHistory();
}
