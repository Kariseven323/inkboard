import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/diary_entry.dart';
import '../../domain/entities/tag.dart';
import '../../domain/repositories/diary_entry_repository.dart';
import '../database/app_database.dart';

/// 日记条目仓储实现
@LazySingleton(as: DiaryEntryRepository)
class DiaryEntryRepositoryImpl implements DiaryEntryRepository {
  final AppDatabase _database;

  const DiaryEntryRepositoryImpl(this._database);

  @override
  Stream<List<DiaryEntry>> getAllDiaryEntries() {
    return (_database.select(_database.diaryEntries)
          ..orderBy([(entry) => OrderingTerm.desc(entry.createdAt)]))
        .watch()
        .asyncMap(_mapToEntitiesWithTags);
  }

  @override
  Future<DiaryEntry?> getDiaryEntryById(int id) async {
    final query = _database.select(_database.diaryEntries)
      ..where((entry) => entry.id.equals(id));

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    final tags = await _getTagsForEntry(id);
    return _mapDataToEntity(result, tags);
  }

  @override
  Future<int> createDiaryEntry(DiaryEntry entry) async {
    return await _database.transaction(() async {
      // 插入日记条目
      final entryId = await _database
          .into(_database.diaryEntries)
          .insert(
            DiaryEntriesCompanion.insert(
              title: entry.title,
              content: entry.content,
              createdAt: entry.createdAt,
              updatedAt: entry.updatedAt,
              isFavorite: Value(entry.isFavorite),
              moodScore: Value(entry.moodScore),
              weather: Value(entry.weather),
              location: Value(entry.location),
            ),
          );

      // 添加标签关联
      await _addTagsToEntry(entryId, entry.tags.map((tag) => tag.id!).toList());

      return entryId;
    });
  }

  @override
  Future<bool> updateDiaryEntry(DiaryEntry entry) async {
    if (entry.id == null) return false;

    return await _database.transaction(() async {
      // 更新日记条目
      final updated =
          await (_database.update(
            _database.diaryEntries,
          )..where((e) => e.id.equals(entry.id!))).write(
            DiaryEntriesCompanion(
              title: Value(entry.title),
              content: Value(entry.content),
              updatedAt: Value(DateTime.now()),
              isFavorite: Value(entry.isFavorite),
              moodScore: Value(entry.moodScore),
              weather: Value(entry.weather),
              location: Value(entry.location),
            ),
          );

      if (updated > 0) {
        // 重新设置标签关联
        await _clearTagsForEntry(entry.id!);
        await _addTagsToEntry(
          entry.id!,
          entry.tags.map((tag) => tag.id!).toList(),
        );
        return true;
      }

      return false;
    });
  }

  @override
  Future<bool> deleteDiaryEntry(int id) async {
    return await _database.transaction(() async {
      // 删除标签关联
      await _clearTagsForEntry(id);

      // 删除日记条目
      final deleteCount = await (_database.delete(
        _database.diaryEntries,
      )..where((entry) => entry.id.equals(id))).go();

      return deleteCount > 0;
    });
  }

  @override
  Stream<List<DiaryEntry>> getFavoriteDiaryEntries() {
    return (_database.select(_database.diaryEntries)
          ..where((entry) => entry.isFavorite.equals(true))
          ..orderBy([(entry) => OrderingTerm.desc(entry.createdAt)]))
        .watch()
        .asyncMap(_mapToEntitiesWithTags);
  }

  @override
  Stream<List<DiaryEntry>> getDiaryEntriesByTags(List<int> tagIds) {
    if (tagIds.isEmpty) return Stream.value([]);

    final query =
        _database.select(_database.diaryEntries).join([
            innerJoin(
              _database.diaryTags,
              _database.diaryTags.diaryEntryId.equalsExp(
                _database.diaryEntries.id,
              ),
            ),
          ])
          ..where(_database.diaryTags.tagId.isIn(tagIds))
          ..orderBy([OrderingTerm.desc(_database.diaryEntries.createdAt)]);

    return query.watch().asyncMap((rows) async {
      final entries = rows
          .map((row) => row.readTable(_database.diaryEntries))
          .toList();
      final entitiesWithTags = <DiaryEntry>[];

      for (final entry in entries) {
        final tags = await _getTagsForEntry(entry.id);
        entitiesWithTags.add(_mapDataToEntity(entry, tags));
      }

      return entitiesWithTags;
    });
  }

  @override
  Stream<List<DiaryEntry>> getDiaryEntriesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return (_database.select(_database.diaryEntries)
          ..where(
            (entry) => entry.createdAt.isBetweenValues(startDate, endDate),
          )
          ..orderBy([(entry) => OrderingTerm.desc(entry.createdAt)]))
        .watch()
        .asyncMap(_mapToEntitiesWithTags);
  }

  @override
  Stream<List<DiaryEntry>> searchDiaryEntries(String query) {
    final q = query.trim();
    if (q.isEmpty) return Stream.value([]);

    // 基于全量流 + FTS 标题匹配 + 解密后内容匹配进行过滤，保证在内容加密下仍可搜索
    return getAllDiaryEntries().asyncMap((entries) async {
      final ftsIds = await _getFtsMatchIds(q);
      final lower = q.toLowerCase();
      return entries.where((e) {
        final inFts = e.id != null && ftsIds.contains(e.id);
        final titleHit = e.title.toLowerCase().contains(lower);
        final contentHit = e.content.toLowerCase().contains(lower);
        return inFts || titleHit || contentHit;
      }).toList();
    });
  }

  @override
  Future<Map<String, int>> getDiaryStatistics() async {
    final totalCount = await _database
        .select(_database.diaryEntries)
        .get()
        .then((rows) => rows.length);
    final favoriteCount =
        await (_database.select(_database.diaryEntries)
              ..where((entry) => entry.isFavorite.equals(true)))
            .get()
            .then((rows) => rows.length);

    final thisMonth = DateTime.now();
    final firstDayOfMonth = DateTime(thisMonth.year, thisMonth.month, 1);
    final monthlyCount =
        await (_database.select(_database.diaryEntries)..where(
              (entry) => entry.createdAt.isBiggerOrEqualValue(firstDayOfMonth),
            ))
            .get()
            .then((rows) => rows.length);

    return {
      'total': totalCount,
      'favorites': favoriteCount,
      'monthly': monthlyCount,
    };
  }

  @override
  Future<bool> toggleFavorite(int id) async {
    final current = await getDiaryEntryById(id);
    if (current == null) return false;

    final updateCount =
        await (_database.update(
          _database.diaryEntries,
        )..where((entry) => entry.id.equals(id))).write(
          DiaryEntriesCompanion(
            isFavorite: Value(!current.isFavorite),
            updatedAt: Value(DateTime.now()),
          ),
        );

    return updateCount > 0;
  }

  @override
  Future<bool> addTagToEntry(int entryId, int tagId) async {
    try {
      await _database
          .into(_database.diaryTags)
          .insert(
            DiaryTagsCompanion.insert(
              diaryEntryId: entryId,
              tagId: tagId,
              createdAt: DateTime.now(),
            ),
          );
      return true;
    } catch (e) {
      // 可能是重复关联
      return false;
    }
  }

  @override
  Future<bool> removeTagFromEntry(int entryId, int tagId) async {
    final deleteCount =
        await (_database.delete(_database.diaryTags)..where(
              (dt) => dt.diaryEntryId.equals(entryId) & dt.tagId.equals(tagId),
            ))
            .go();

    return deleteCount > 0;
  }

  @override
  Future<bool> deleteDiaryEntries(List<int> ids) async {
    if (ids.isEmpty) return false;

    return await _database.transaction(() async {
      // 删除所有相关的标签关联
      for (final id in ids) {
        await _clearTagsForEntry(id);
      }

      // 批量删除日记条目
      final deleteCount = await (_database.delete(
        _database.diaryEntries,
      )..where((entry) => entry.id.isIn(ids))).go();

      return deleteCount > 0;
    });
  }

  /// 获取指定日记条目的所有标签
  Future<List<Tag>> _getTagsForEntry(int entryId) async {
    final query = _database.select(_database.tags).join([
      innerJoin(
        _database.diaryTags,
        _database.diaryTags.tagId.equalsExp(_database.tags.id),
      ),
    ])..where(_database.diaryTags.diaryEntryId.equals(entryId));

    final result = await query.get();
    return result
        .map((row) => _mapTagDataToEntity(row.readTable(_database.tags)))
        .toList();
  }

  /// 为日记条目添加多个标签
  Future<void> _addTagsToEntry(int entryId, List<int> tagIds) async {
    for (final tagId in tagIds) {
      try {
        await _database
            .into(_database.diaryTags)
            .insert(
              DiaryTagsCompanion.insert(
                diaryEntryId: entryId,
                tagId: tagId,
                createdAt: DateTime.now(),
              ),
            );
      } catch (e) {
        // 忽略重复关联错误
      }
    }
  }

  /// 清除日记条目的所有标签关联
  Future<void> _clearTagsForEntry(int entryId) async {
    await (_database.delete(
      _database.diaryTags,
    )..where((dt) => dt.diaryEntryId.equals(entryId))).go();
  }

  /// 将数据库结果映射为包含标签的实体列表
  Future<List<DiaryEntry>> _mapToEntitiesWithTags(
    List<DiaryEntryData> dataList,
  ) async {
    final entitiesWithTags = <DiaryEntry>[];

    for (final data in dataList) {
      final tags = await _getTagsForEntry(data.id);
      entitiesWithTags.add(_mapDataToEntity(data, tags));
    }

    return entitiesWithTags;
  }

  /// 将数据库数据映射为实体
  DiaryEntry _mapDataToEntity(DiaryEntryData data, List<Tag> tags) {
    return DiaryEntry(
      id: data.id,
      title: data.title,
      content: data.content,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      isFavorite: data.isFavorite,
      moodScore: data.moodScore,
      weather: data.weather,
      location: data.location,
      tags: tags,
    );
  }

  /// 将标签数据映射为实体
  Tag _mapTagDataToEntity(TagData data) {
    return Tag(
      id: data.id,
      name: data.name,
      color: data.color,
      createdAt: data.createdAt,
      usageCount: data.usageCount,
      description: data.description,
    );
  }

  /// FTS（标题）匹配到的 rowid 集合（若 FTS 表不存在则返回空集合）
  Future<Set<int>> _getFtsMatchIds(String query) async {
    try {
      final result = await _database
          .customSelect(
            'SELECT rowid FROM diary_entries_fts WHERE diary_entries_fts MATCH ?;',
            variables: [Variable.withString(query)],
            readsFrom: {_database.diaryEntries},
          )
          .get();
      return result.map((row) => row.read<int>('rowid')).toSet();
    } catch (_) {
      // FTS 表不存在或不可用时忽略
      return <int>{};
    }
  }
}
