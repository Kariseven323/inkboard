import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/service_locator.dart';
import '../../domain/entities/diary_entry.dart';
import '../../domain/usecases/get_diary_entries_usecase.dart';

/// 日记列表状态管理
final diaryEntriesProvider = StreamProvider<List<DiaryEntry>>((ref) {
  final getDiaryEntriesUseCase = getIt<GetDiaryEntriesUseCase>();
  return getDiaryEntriesUseCase.getAllEntries();
});

/// 收藏的日记列表状态管理
final favoriteDiaryEntriesProvider = StreamProvider<List<DiaryEntry>>((ref) {
  final getDiaryEntriesUseCase = getIt<GetDiaryEntriesUseCase>();
  return getDiaryEntriesUseCase.getFavoriteEntries();
});

/// 日记统计信息状态管理
final diaryStatisticsProvider = FutureProvider((ref) async {
  final getDiaryEntriesUseCase = getIt<GetDiaryEntriesUseCase>();
  final result = await getDiaryEntriesUseCase.getStatistics();
  return result.dataOrThrow;
});

/// 根据标签筛选的日记列表状态管理
final diaryEntriesByTagsProvider = StreamProvider.family<List<DiaryEntry>, List<int>>((ref, tagIds) {
  final getDiaryEntriesUseCase = getIt<GetDiaryEntriesUseCase>();
  return getDiaryEntriesUseCase.getEntriesByTags(tagIds);
});

/// 根据日期范围筛选的日记列表状态管理
final diaryEntriesByDateRangeProvider = StreamProvider.family<List<DiaryEntry>, DateRange>((ref, dateRange) {
  final getDiaryEntriesUseCase = getIt<GetDiaryEntriesUseCase>();
  return getDiaryEntriesUseCase.getEntriesByDateRange(dateRange.startDate, dateRange.endDate);
});

/// 日期范围辅助类
class DateRange {
  final DateTime startDate;
  final DateTime endDate;

  DateRange({
    required this.startDate,
    required this.endDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateRange &&
          runtimeType == other.runtimeType &&
          startDate == other.startDate &&
          endDate == other.endDate;

  @override
  int get hashCode => startDate.hashCode ^ endDate.hashCode;
}