import 'package:injectable/injectable.dart';

import '../../domain/entities/diary_entry.dart';
import '../../domain/entities/tag.dart';
import '../../domain/repositories/diary_entry_repository.dart';
import '../../domain/repositories/tag_repository.dart';
import '../../domain/services/search_service.dart';

/// 搜索服务实现
@LazySingleton(as: SearchService)
class SearchServiceImpl implements SearchService {
  final DiaryEntryRepository _diaryEntryRepository;
  final TagRepository _tagRepository;

  // 简单的搜索历史存储（实际项目中可能需要持久化）
  final List<String> _searchHistory = [];

  SearchServiceImpl(
    this._diaryEntryRepository,
    this._tagRepository,
  );

  @override
  Future<List<SearchResult>> globalSearch(String query) async {
    if (query.trim().isEmpty) return [];

    final results = <SearchResult>[];

    // 搜索日记条目
    final diaryEntries = await _diaryEntryRepository.searchDiaryEntries(query).first;
    for (final entry in diaryEntries) {
      results.add(SearchResult(
        type: SearchResultType.diaryEntry,
        data: entry,
        snippet: _generateSnippet(entry, query),
        relevanceScore: _calculateRelevanceScore(entry, query),
      ));
    }

    // 搜索标签
    final tags = await _tagRepository.searchTags(query).first;
    for (final tag in tags) {
      results.add(SearchResult(
        type: SearchResultType.tag,
        data: tag,
        snippet: tag.description ?? tag.name,
        relevanceScore: _calculateTextRelevanceScore('${tag.name} ${tag.description ?? ''}', query),
      ));
    }

    // 按相关性排序
    results.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

    // 记录搜索历史
    await recordSearchHistory(query);

    return results;
  }

  @override
  Stream<List<DiaryEntry>> searchDiaryEntries(String query) {
    return _diaryEntryRepository.searchDiaryEntries(query);
  }

  @override
  Stream<List<Tag>> searchTags(String query) {
    return _tagRepository.searchTags(query);
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
  }) {
    // 开始从所有日记条目进行筛选
    Stream<List<DiaryEntry>> stream = _diaryEntryRepository.getAllDiaryEntries();

    // 应用各种筛选条件
    stream = stream.map((entries) {
      return entries.where((entry) {
        // 标题搜索
        if (titleQuery != null && titleQuery.isNotEmpty) {
          if (!entry.title.toLowerCase().contains(titleQuery.toLowerCase())) {
            return false;
          }
        }

        // 内容搜索
        if (contentQuery != null && contentQuery.isNotEmpty) {
          if (!entry.content.toLowerCase().contains(contentQuery.toLowerCase())) {
            return false;
          }
        }

        // 标签筛选
        if (tagIds != null && tagIds.isNotEmpty) {
          final entryTagIds = entry.tags.map((tag) => tag.id).whereType<int>().toSet();
          if (!tagIds.any((tagId) => entryTagIds.contains(tagId))) {
            return false;
          }
        }

        // 日期范围筛选
        if (startDate != null && entry.createdAt.isBefore(startDate)) {
          return false;
        }
        if (endDate != null && entry.createdAt.isAfter(endDate)) {
          return false;
        }

        // 收藏状态筛选
        if (isFavorite != null && entry.isFavorite != isFavorite) {
          return false;
        }

        // 心情评分筛选
        if (moodScore != null && entry.moodScore != moodScore) {
          return false;
        }

        return true;
      }).toList();
    });

    return stream;
  }

  @override
  Future<List<String>> getSearchSuggestions(String query) async {
    if (query.trim().isEmpty) return [];

    final suggestions = <String>[];

    // 从标签名称中获取建议
    final tags = await _tagRepository.searchTags(query).first;
    suggestions.addAll(tags.map((tag) => tag.name));

    // 从搜索历史中获取建议
    final history = await getSearchHistory();
    suggestions.addAll(
      history.where((term) => term.toLowerCase().contains(query.toLowerCase()))
    );

    // 去重并限制数量
    return suggestions.toSet().take(10).toList();
  }

  @override
  Future<List<String>> getPopularSearchTerms() async {
    // 简单实现：返回最常用的标签名称
    final popularTags = await _tagRepository.getPopularTags(limit: 10).first;
    return popularTags.map((tag) => tag.name).toList();
  }

  @override
  Future<void> recordSearchHistory(String query) async {
    if (query.trim().isEmpty) return;

    // 移除重复项
    _searchHistory.remove(query);

    // 添加到开头
    _searchHistory.insert(0, query);

    // 限制历史记录数量
    if (_searchHistory.length > 50) {
      _searchHistory.removeRange(50, _searchHistory.length);
    }
  }

  @override
  Future<List<String>> getSearchHistory({int limit = 10}) async {
    return _searchHistory.take(limit).toList();
  }

  @override
  Future<void> clearSearchHistory() async {
    _searchHistory.clear();
  }

  /// 生成搜索片段
  String _generateSnippet(DiaryEntry entry, String query, {int maxLength = 150}) {
    final lowerQuery = query.toLowerCase();
    final title = entry.title;
    final content = entry.content;

    // 优先从标题匹配片段
    final idxTitle = title.toLowerCase().indexOf(lowerQuery);
    if (idxTitle >= 0) {
      return _highlight(title, lowerQuery, maxLength: maxLength, isTitle: true);
    }

    // 再从内容匹配片段
    final idx = content.toLowerCase().indexOf(lowerQuery);
    if (idx == -1) {
      return content.length <= maxLength ? content : '${content.substring(0, maxLength - 3)}...';
    }

    final start = (idx - maxLength ~/ 4).clamp(0, content.length);
    final end = (idx + lowerQuery.length + maxLength ~/ 4 * 3).clamp(0, content.length);
    var snippet = content.substring(start, end);
    if (start > 0) snippet = '...$snippet';
    if (end < content.length) snippet = '$snippet...';
    return _applyHighlight(snippet, lowerQuery);
  }

  /// 计算相关性评分
  double _calculateRelevanceScore(DiaryEntry entry, String query) {
    final lq = query.toLowerCase();
    final lt = entry.title.toLowerCase();
    final lc = entry.content.toLowerCase();

    // 词频
    int freq(String text) => text.isEmpty ? 0 : text.split(lq).length - 1;

    final titleFreq = freq(lt);
    final contentFreq = freq(lc);

    // 位置：越靠前越高分
    int posScore(String text) {
      final idx = text.indexOf(lq);
      if (idx < 0) return 0;
      return (1000 - idx).clamp(0, 1000);
    }

    final titlePos = posScore(lt);
    final contentPos = posScore(lc);

    // 长度惩罚（更短文本更有相关性）
    double lenPenalty(String text) => 1.0 + (text.length / 800.0);

    // 时间衰减（越新越高）
    final days = DateTime.now().difference(entry.createdAt).inDays;
    final timeFactor = 1.0 / (1.0 + days / 30.0);

    final titleScore = (titleFreq * 5.0 + titlePos / 50.0) / lenPenalty(lt) * 2.0;
    final contentScore = (contentFreq * 3.0 + contentPos / 100.0) / lenPenalty(lc) * 1.0;

    return (titleScore + contentScore) * timeFactor;
  }

  double _calculateTextRelevanceScore(String text, String query) {
    final lt = text.toLowerCase();
    final lq = query.toLowerCase();
    int freq(String t) => t.isEmpty ? 0 : t.split(lq).length - 1;
    final f = freq(lt);
    final pos = lt.indexOf(lq);
    final posScore = pos < 0 ? 0 : (500 - pos).clamp(0, 500);
    final lenPenalty = 1.0 + (lt.length / 800.0);
    return (f * 3.0 + posScore / 100.0) / lenPenalty;
  }

  String _highlight(String text, String lowerQuery, {int maxLength = 150, bool isTitle = false}) {
    final idx = text.toLowerCase().indexOf(lowerQuery);
    if (idx < 0) return text.length <= maxLength ? text : '${text.substring(0, maxLength - 3)}...';
    if (isTitle) return _applyHighlight(text, lowerQuery);
    final start = (idx - maxLength ~/ 4).clamp(0, text.length);
    final end = (idx + lowerQuery.length + maxLength ~/ 4 * 3).clamp(0, text.length);
    var snippet = text.substring(start, end);
    if (start > 0) snippet = '...$snippet';
    if (end < text.length) snippet = '$snippet...';
    return _applyHighlight(snippet, lowerQuery);
  }

  String _applyHighlight(String text, String lowerQuery) {
    // 简单高亮：将匹配到的词用 ** 包裹
    final re = RegExp(RegExp.escape(lowerQuery), caseSensitive: false);
    return text.replaceAllMapped(re, (m) => '**${m.group(0)}**');
  }
}
