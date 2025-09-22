import 'package:injectable/injectable.dart';

import '../common/result.dart';
import '../entities/diary_entry.dart';
import '../repositories/diary_entry_repository.dart';

/// 获取日记列表用例
@injectable
class GetDiaryEntriesUseCase {
  final DiaryEntryRepository _diaryEntryRepository;

  GetDiaryEntriesUseCase(this._diaryEntryRepository);

  /// 获取所有日记条目
  Stream<List<DiaryEntry>> getAllEntries() {
    return _diaryEntryRepository.getAllDiaryEntries();
  }

  /// 获取收藏的日记条目
  Stream<List<DiaryEntry>> getFavoriteEntries() {
    return _diaryEntryRepository.getFavoriteDiaryEntries();
  }

  /// 根据标签筛选日记条目
  Stream<List<DiaryEntry>> getEntriesByTags(List<int> tagIds) {
    return _diaryEntryRepository.getDiaryEntriesByTags(tagIds);
  }

  /// 根据日期范围获取日记条目
  Stream<List<DiaryEntry>> getEntriesByDateRange(DateTime startDate, DateTime endDate) {
    return _diaryEntryRepository.getDiaryEntriesByDateRange(startDate, endDate);
  }

  /// 根据ID获取单个日记条目
  Future<Result<DiaryEntry>> getEntryById(int id) async {
    try {
      final entry = await _diaryEntryRepository.getDiaryEntryById(id);
      if (entry == null) {
        return Result.failure('未找到指定的日记条目');
      }
      return Result.success(entry);
    } catch (e) {
      return Result.failure('获取日记条目失败: $e');
    }
  }

  /// 获取日记统计信息
  Future<Result<DiaryStatistics>> getStatistics() async {
    try {
      final stats = await _diaryEntryRepository.getDiaryStatistics();
      return Result.success(DiaryStatistics.fromMap(stats));
    } catch (e) {
      return Result.failure('获取统计信息失败: $e');
    }
  }
}

/// 日记统计信息
class DiaryStatistics {
  final int totalCount;
  final int favoriteCount;
  final int monthlyCount;

  DiaryStatistics({
    required this.totalCount,
    required this.favoriteCount,
    required this.monthlyCount,
  });

  factory DiaryStatistics.fromMap(Map<String, int> map) {
    return DiaryStatistics(
      totalCount: map['total'] ?? 0,
      favoriteCount: map['favorites'] ?? 0,
      monthlyCount: map['monthly'] ?? 0,
    );
  }

  /// 获取平均每月写作天数（假设总共使用了N个月）
  double getAverageMonthlyEntries(int totalMonths) {
    if (totalMonths <= 0) return 0.0;
    return totalCount / totalMonths;
  }

  /// 获取收藏率
  double get favoriteRate {
    if (totalCount == 0) return 0.0;
    return favoriteCount / totalCount;
  }
}