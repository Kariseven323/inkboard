import 'dart:async';

import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/domain/repositories/diary_entry_repository.dart';
import 'package:inkboard/domain/repositories/tag_repository.dart';

class InMemoryDiaryEntryRepository implements DiaryEntryRepository {
  final List<DiaryEntry> _entries = [];
  int _id = 1;

  @override
  Stream<List<DiaryEntry>> getAllDiaryEntries() async* {
    yield List.unmodifiable(_entries);
  }

  @override
  Future<int> createDiaryEntry(DiaryEntry entry) async {
    // 若外部已指定 id（如编辑流程预置条目），则尊重该 id，不强行改写
    if (entry.id != null) {
      _entries.add(entry);
      // 保持自增游标不冲突
      if (entry.id! >= _id) {
        _id = entry.id! + 1;
      }
      return entry.id!;
    }
    final e = entry.copyWith(id: _id++);
    _entries.add(e);
    return e.id!;
  }

  @override
  Future<bool> deleteDiaryEntry(int id) async {
    final before = _entries.length;
    _entries.removeWhere((e) => e.id == id);
    return _entries.length < before;
  }

  @override
  Future<bool> deleteDiaryEntries(List<int> ids) async {
    final before = _entries.length;
    _entries.removeWhere((e) => ids.contains(e.id));
    return _entries.length < before;
  }

  // 软删除：在内存实现中等同于硬删除（测试目的）
  @override
  Future<bool> softDeleteDiaryEntry(int id) async {
    return deleteDiaryEntry(id);
  }

  @override
  Future<bool> softDeleteDiaryEntries(List<int> ids) async {
    return deleteDiaryEntries(ids);
  }

  @override
  Stream<List<DiaryEntry>> getDeletedDiaryEntries() async* {
    // 简化：内存实现不保留回收站数据
    yield const <DiaryEntry>[];
  }

  @override
  Future<bool> restoreDiaryEntry(int id) async {
    // 简化：无状态
    return true;
  }

  @override
  Future<bool> restoreDiaryEntries(List<int> ids) async {
    return true;
  }

  @override
  Future<bool> purgeDiaryEntry(int id) async {
    return true;
  }

  @override
  Future<bool> purgeDiaryEntries(List<int> ids) async {
    return true;
  }

  @override
  Future<DiaryEntry?> getDiaryEntryById(int id) async {
    return _entries.where((e) => e.id == id).cast<DiaryEntry?>().firstOrNull;
  }

  @override
  Stream<List<DiaryEntry>> getDiaryEntriesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async* {
    yield _entries
        .where(
          (e) =>
              !e.createdAt.isBefore(startDate) && !e.createdAt.isAfter(endDate),
        )
        .toList();
  }

  @override
  Stream<List<DiaryEntry>> getDiaryEntriesByTags(List<int> tagIds) async* {
    // 调试：打印当前条目与传入tagIds
    assert(() {
      // ignore: avoid_print
      print(
        '[InMemory] getDiaryEntriesByTags ids=$tagIds entries=${_entries.length}',
      );
      return true;
    }());
    yield _entries
        .where((e) => e.tags.any((t) => t.id != null && tagIds.contains(t.id)))
        .toList();
  }

  @override
  Stream<List<DiaryEntry>> getFavoriteDiaryEntries() async* {
    yield _entries.where((e) => e.isFavorite).toList();
  }

  @override
  Stream<List<DiaryEntry>> searchDiaryEntries(String query) async* {
    final q = query.toLowerCase();
    yield _entries
        .where(
          (e) =>
              e.title.toLowerCase().contains(q) ||
              e.content.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Future<bool> updateDiaryEntry(DiaryEntry entry) async {
    final idx = _entries.indexWhere((e) => e.id == entry.id);
    if (idx == -1) return false;
    _entries[idx] = entry;
    return true;
  }

  @override
  Future<Map<String, int>> getDiaryStatistics() async {
    final total = _entries.length;
    final favorites = _entries.where((e) => e.isFavorite).length;
    // 简化：最近30天内创建的视为本月
    final now = DateTime.now();
    final monthly = _entries
        .where(
          (e) => e.createdAt.isAfter(now.subtract(const Duration(days: 30))),
        )
        .length;
    return {'total': total, 'favorites': favorites, 'monthly': monthly};
  }

  @override
  Future<bool> toggleFavorite(int id) async {
    final idx = _entries.indexWhere((e) => e.id == id);
    if (idx == -1) return false;
    final e = _entries[idx];
    _entries[idx] = e.copyWith(
      isFavorite: !e.isFavorite,
      updatedAt: DateTime.now(),
    );
    return true;
  }

  @override
  Future<bool> addTagToEntry(int entryId, int tagId) async {
    final idx = _entries.indexWhere((e) => e.id == entryId);
    if (idx == -1) return false;
    final e = _entries[idx];
    if (e.tags.any((t) => t.id == tagId)) return true;
    _entries[idx] = e.copyWith(
      tags: [
        ...e.tags,
        Tag(
          id: tagId,
          name: 'T$tagId',
          color: '#1877F2',
          createdAt: DateTime.now(),
        ),
      ],
    );
    return true;
  }

  @override
  Future<bool> removeTagFromEntry(int entryId, int tagId) async {
    final idx = _entries.indexWhere((e) => e.id == entryId);
    if (idx == -1) return false;
    final e = _entries[idx];
    _entries[idx] = e.copyWith(
      tags: e.tags.where((t) => t.id != tagId).toList(),
    );
    return true;
  }
}

class InMemoryTagRepository implements TagRepository {
  final List<Tag> _tags = [];
  final StreamController<List<Tag>> _tagsController =
      StreamController<List<Tag>>.broadcast();
  int _id = 1;

  void _emit() {
    if (!_tagsController.isClosed) {
      _tagsController.add(List.unmodifiable(_tags));
    }
  }

  @override
  Future<int> createTag(Tag tag) async {
    final t = Tag(
      id: _id++,
      name: tag.name,
      color: tag.color,
      createdAt: tag.createdAt,
      usageCount: tag.usageCount,
      description: tag.description,
    );
    _tags.add(t);
    _emit();
    return t.id!;
  }

  @override
  Future<bool> deleteTag(int id) async {
    final before = _tags.length;
    _tags.removeWhere((t) => t.id == id);
    _emit();
    return _tags.length < before;
  }

  @override
  Future<Tag?> getTagById(int id) async =>
      _tags.where((t) => t.id == id).cast<Tag?>().firstOrNull;

  @override
  Future<Tag?> getTagByName(String name) async =>
      _tags.where((t) => t.name == name).cast<Tag?>().firstOrNull;

  @override
  Future<bool> incrementTagUsage(int tagId) async {
    final idx = _tags.indexWhere((t) => t.id == tagId);
    if (idx == -1) return false;
    final t = _tags[idx];
    _tags[idx] = Tag(
      id: t.id,
      name: t.name,
      color: t.color,
      createdAt: t.createdAt,
      usageCount: t.usageCount + 1,
      description: t.description,
    );
    _emit();
    return true;
  }

  @override
  Future<bool> decrementTagUsage(int tagId) async {
    final idx = _tags.indexWhere((t) => t.id == tagId);
    if (idx == -1) return false;
    final t = _tags[idx];
    _tags[idx] = Tag(
      id: t.id,
      name: t.name,
      color: t.color,
      createdAt: t.createdAt,
      usageCount: t.usageCount > 0 ? t.usageCount - 1 : 0,
      description: t.description,
    );
    _emit();
    return true;
  }

  // 以下流式接口：返回当前快照 + 后续变更
  @override
  Stream<List<Tag>> getAllTags() async* {
    yield List.unmodifiable(_tags);
    yield* _tagsController.stream;
  }

  @override
  Stream<List<Tag>> getPopularTags({int limit = 10}) {
    return getAllTags().map((list) {
      final copy = list.toList()
        ..sort((a, b) => b.usageCount.compareTo(a.usageCount));
      return copy.take(limit).toList();
    });
  }

  @override
  Stream<List<Tag>> getRecentTags({int limit = 5}) {
    return getAllTags().map((list) => list.reversed.take(limit).toList());
  }

  @override
  Stream<List<Tag>> searchTags(String query) {
    return getAllTags().map(
      (list) => list.where((t) => t.name.contains(query)).toList(),
    );
  }

  @override
  Future<bool> updateTag(Tag tag) async {
    final idx = _tags.indexWhere((t) => t.id == tag.id);
    if (idx == -1) return false;
    _tags[idx] = tag;
    _emit();
    return true;
  }

  @override
  Future<bool> deleteTags(List<int> ids) async {
    final before = _tags.length;
    _tags.removeWhere((t) => ids.contains(t.id));
    _emit();
    return _tags.length < before;
  }

  @override
  Future<Map<String, int>> getTagStatistics() async => {
    'total': _tags.length,
    'popular': _tags.where((t) => t.usageCount > 0).length,
  };

  @override
  Future<bool> isTagNameExists(String name, {int? excludeId}) async => _tags
      .any((t) => t.name == name && (excludeId == null || t.id != excludeId));
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
