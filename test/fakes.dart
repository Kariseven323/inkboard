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

  @override
  Future<DiaryEntry?> getDiaryEntryById(int id) async {
    return _entries.where((e) => e.id == id).cast<DiaryEntry?>().firstOrNull;
  }

  @override
  Stream<List<DiaryEntry>> getDiaryEntriesByDateRange(DateTime startDate, DateTime endDate) async* {
    yield _entries.where((e) => !e.createdAt.isBefore(startDate) && !e.createdAt.isAfter(endDate)).toList();
  }

  @override
  Stream<List<DiaryEntry>> getDiaryEntriesByTags(List<int> tagIds) async* {
    yield _entries.where((e) => e.tags.any((t) => t.id != null && tagIds.contains(t.id))).toList();
  }

  @override
  Stream<List<DiaryEntry>> getFavoriteDiaryEntries() async* {
    yield _entries.where((e) => e.isFavorite).toList();
  }

  @override
  Stream<List<DiaryEntry>> searchDiaryEntries(String query) async* {
    final q = query.toLowerCase();
    yield _entries.where((e) => e.title.toLowerCase().contains(q) || e.content.toLowerCase().contains(q)).toList();
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
    final monthly = _entries.where((e) => e.createdAt.isAfter(now.subtract(const Duration(days: 30)))).length;
    return {'total': total, 'favorites': favorites, 'monthly': monthly};
  }

  @override
  Future<bool> toggleFavorite(int id) async {
    final idx = _entries.indexWhere((e) => e.id == id);
    if (idx == -1) return false;
    final e = _entries[idx];
    _entries[idx] = e.copyWith(isFavorite: !e.isFavorite, updatedAt: DateTime.now());
    return true;
  }

  @override
  Future<bool> addTagToEntry(int entryId, int tagId) async {
    final idx = _entries.indexWhere((e) => e.id == entryId);
    if (idx == -1) return false;
    final e = _entries[idx];
    if (e.tags.any((t) => t.id == tagId)) return true;
    _entries[idx] = e.copyWith(tags: [...e.tags, Tag(id: tagId, name: 'T$tagId', color: '#1877F2', createdAt: DateTime.now())]);
    return true;
  }

  @override
  Future<bool> removeTagFromEntry(int entryId, int tagId) async {
    final idx = _entries.indexWhere((e) => e.id == entryId);
    if (idx == -1) return false;
    final e = _entries[idx];
    _entries[idx] = e.copyWith(tags: e.tags.where((t) => t.id != tagId).toList());
    return true;
  }
}

class InMemoryTagRepository implements TagRepository {
  final List<Tag> _tags = [];
  int _id = 1;

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
    return t.id!;
  }

  @override
  Future<bool> deleteTag(int id) async {
    final before = _tags.length;
    _tags.removeWhere((t) => t.id == id);
    return _tags.length < before;
  }

  @override
  Future<Tag?> getTagById(int id) async => _tags.where((t) => t.id == id).cast<Tag?>().firstOrNull;

  @override
  Future<Tag?> getTagByName(String name) async => _tags.where((t) => t.name == name).cast<Tag?>().firstOrNull;

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
    return true;
  }

  // 以下流式接口为测试方便返回静态一次
  @override
  Stream<List<Tag>> getAllTags() async* {
    yield List.unmodifiable(_tags);
  }
  @override
  Stream<List<Tag>> getPopularTags({int limit = 10}) async* {
    final list = _tags.toList()..sort((a,b)=>b.usageCount.compareTo(a.usageCount));
    yield list.take(limit).toList();
  }
  @override
  Stream<List<Tag>> getRecentTags({int limit = 5}) async* {
    yield _tags.reversed.take(limit).toList();
  }
  @override
  Stream<List<Tag>> searchTags(String query) async* {
    yield _tags.where((t)=>t.name.contains(query)).toList();
  }

  @override
  Future<bool> updateTag(Tag tag) async {
    final idx = _tags.indexWhere((t)=>t.id==tag.id);
    if (idx==-1) return false; _tags[idx]=tag; return true;
  }

  @override
  Future<bool> deleteTags(List<int> ids) async {
    final before = _tags.length;
    _tags.removeWhere((t)=>ids.contains(t.id));
    return _tags.length < before;
  }

  @override
  Future<Map<String, int>> getTagStatistics() async => {
        'total': _tags.length,
        'popular': _tags.where((t) => t.usageCount > 0).length,
      };

  @override
  Future<bool> isTagNameExists(String name, {int? excludeId}) async =>
      _tags.any((t) => t.name == name && (excludeId == null || t.id != excludeId));
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
