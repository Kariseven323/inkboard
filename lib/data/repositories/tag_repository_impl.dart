import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/tag.dart';
import '../../domain/repositories/tag_repository.dart';
import '../database/app_database.dart';

/// 标签仓储实现
@LazySingleton(as: TagRepository)
class TagRepositoryImpl implements TagRepository {
  final AppDatabase _database;

  const TagRepositoryImpl(this._database);

  @override
  Stream<List<Tag>> getAllTags() {
    return (_database.select(_database.tags)
        ..orderBy([(tag) => OrderingTerm.asc(tag.name)]))
        .watch()
        .map(_mapToEntities);
  }

  @override
  Future<Tag?> getTagById(int id) async {
    final query = _database.select(_database.tags)
      ..where((tag) => tag.id.equals(id));

    final result = await query.getSingleOrNull();
    return result != null ? _mapDataToEntity(result) : null;
  }

  @override
  Future<Tag?> getTagByName(String name) async {
    final query = _database.select(_database.tags)
      ..where((tag) => tag.name.equals(name));

    final result = await query.getSingleOrNull();
    return result != null ? _mapDataToEntity(result) : null;
  }

  @override
  Future<int> createTag(Tag tag) async {
    return await _database.into(_database.tags).insert(
      TagsCompanion.insert(
        name: tag.name,
        color: Value(tag.color),
        createdAt: tag.createdAt,
        usageCount: Value(tag.usageCount),
        description: Value(tag.description),
      ),
    );
  }

  @override
  Future<bool> updateTag(Tag tag) async {
    if (tag.id == null) return false;

    final updateCount = await (_database.update(_database.tags)
      ..where((t) => t.id.equals(tag.id!))).write(
      TagsCompanion(
        name: Value(tag.name),
        color: Value(tag.color),
        usageCount: Value(tag.usageCount),
        description: Value(tag.description),
      ),
    );

    return updateCount > 0;
  }

  @override
  Future<bool> deleteTag(int id) async {
    return await _database.transaction(() async {
      // 首先删除所有相关的日记-标签关联
      await (_database.delete(_database.diaryTags)
        ..where((dt) => dt.tagId.equals(id))).go();

      // 然后删除标签本身
      final deleteCount = await (_database.delete(_database.tags)
        ..where((tag) => tag.id.equals(id))).go();

      return deleteCount > 0;
    });
  }

  @override
  Stream<List<Tag>> searchTags(String query) {
    if (query.trim().isEmpty) return Stream.value([]);

    return (_database.select(_database.tags)
        ..where((tag) =>
            tag.name.contains(query) |
            tag.description.contains(query))
        ..orderBy([(tag) => OrderingTerm.asc(tag.name)]))
        .watch()
        .map(_mapToEntities);
  }

  @override
  Stream<List<Tag>> getPopularTags({int limit = 10}) {
    return (_database.select(_database.tags)
        ..orderBy([(tag) => OrderingTerm.desc(tag.usageCount)])
        ..limit(limit))
        .watch()
        .map(_mapToEntities);
  }

  @override
  Stream<List<Tag>> getRecentTags({int limit = 5}) {
    return (_database.select(_database.tags)
        ..orderBy([(tag) => OrderingTerm.desc(tag.createdAt)])
        ..limit(limit))
        .watch()
        .map(_mapToEntities);
  }

  @override
  Future<bool> incrementTagUsage(int tagId) async {
    final current = await getTagById(tagId);
    if (current == null) return false;

    final updateCount = await (_database.update(_database.tags)
      ..where((tag) => tag.id.equals(tagId))).write(
      TagsCompanion(
        usageCount: Value(current.usageCount + 1),
      ),
    );

    return updateCount > 0;
  }

  @override
  Future<bool> decrementTagUsage(int tagId) async {
    final current = await getTagById(tagId);
    if (current == null) return false;

    final newCount = (current.usageCount - 1).clamp(0, double.infinity).toInt();
    final updateCount = await (_database.update(_database.tags)
      ..where((tag) => tag.id.equals(tagId))).write(
      TagsCompanion(
        usageCount: Value(newCount),
      ),
    );

    return updateCount > 0;
  }

  @override
  Future<bool> deleteTags(List<int> ids) async {
    if (ids.isEmpty) return false;

    return await _database.transaction(() async {
      // 删除所有相关的日记-标签关联
      await (_database.delete(_database.diaryTags)
        ..where((dt) => dt.tagId.isIn(ids))).go();

      // 批量删除标签
      final deleteCount = await (_database.delete(_database.tags)
        ..where((tag) => tag.id.isIn(ids))).go();

      return deleteCount > 0;
    });
  }

  @override
  Future<Map<String, int>> getTagStatistics() async {
    final totalCount = await _database.select(_database.tags).get().then((rows) => rows.length);

    final usedTagsCount = await (_database.select(_database.tags)
        ..where((tag) => tag.usageCount.isBiggerThanValue(0)))
        .get()
        .then((rows) => rows.length);

    final thisMonth = DateTime.now();
    final firstDayOfMonth = DateTime(thisMonth.year, thisMonth.month, 1);
    final monthlyCreatedCount = await (_database.select(_database.tags)
        ..where((tag) => tag.createdAt.isBiggerOrEqualValue(firstDayOfMonth)))
        .get()
        .then((rows) => rows.length);

    return {
      'total': totalCount,
      'used': usedTagsCount,
      'monthly_created': monthlyCreatedCount,
    };
  }

  @override
  Future<bool> isTagNameExists(String name, {int? excludeId}) async {
    var query = _database.select(_database.tags)
      ..where((tag) => tag.name.equals(name));

    if (excludeId != null) {
      query = _database.select(_database.tags)
        ..where((tag) => tag.name.equals(name) & tag.id.equals(excludeId).not());
    }

    final result = await query.getSingleOrNull();
    return result != null;
  }

  /// 将数据库结果映射为实体列表
  List<Tag> _mapToEntities(List<TagData> dataList) {
    return dataList.map(_mapDataToEntity).toList();
  }

  /// 将数据库数据映射为实体
  Tag _mapDataToEntity(TagData data) {
    return Tag(
      id: data.id,
      name: data.name,
      color: data.color,
      createdAt: data.createdAt,
      usageCount: data.usageCount,
      description: data.description,
    );
  }
}