import '../entities/diary_entry.dart';

/// 日记条目仓储接口
abstract class DiaryEntryRepository {
  /// 获取所有日记条目
  Stream<List<DiaryEntry>> getAllDiaryEntries();

  /// 根据ID获取日记条目
  Future<DiaryEntry?> getDiaryEntryById(int id);

  /// 创建日记条目
  Future<int> createDiaryEntry(DiaryEntry entry);

  /// 更新日记条目
  Future<bool> updateDiaryEntry(DiaryEntry entry);

  /// 删除日记条目
  Future<bool> deleteDiaryEntry(int id);

  /// 根据收藏状态获取日记条目
  Stream<List<DiaryEntry>> getFavoriteDiaryEntries();

  /// 根据标签筛选日记条目
  Stream<List<DiaryEntry>> getDiaryEntriesByTags(List<int> tagIds);

  /// 根据日期范围获取日记条目
  Stream<List<DiaryEntry>> getDiaryEntriesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// 全文搜索日记条目
  Stream<List<DiaryEntry>> searchDiaryEntries(String query);

  /// 获取日记条目统计信息
  Future<Map<String, int>> getDiaryStatistics();

  /// 切换收藏状态
  Future<bool> toggleFavorite(int id);

  /// 为日记条目添加标签
  Future<bool> addTagToEntry(int entryId, int tagId);

  /// 从日记条目移除标签
  Future<bool> removeTagFromEntry(int entryId, int tagId);

  /// 批量删除日记条目
  Future<bool> deleteDiaryEntries(List<int> ids);

  // ===== 回收站（软删除） =====
  /// 软删除到回收站
  Future<bool> softDeleteDiaryEntry(int id);
  Future<bool> softDeleteDiaryEntries(List<int> ids);

  /// 回收站条目流
  Stream<List<DiaryEntry>> getDeletedDiaryEntries();

  /// 从回收站恢复
  Future<bool> restoreDiaryEntry(int id);
  Future<bool> restoreDiaryEntries(List<int> ids);

  /// 彻底删除（仅对回收站内条目）
  Future<bool> purgeDiaryEntry(int id);
  Future<bool> purgeDiaryEntries(List<int> ids);
}
