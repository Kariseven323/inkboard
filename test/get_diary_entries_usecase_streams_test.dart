import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/repositories/diary_entry_repository.dart';
import 'package:inkboard/domain/usecases/get_diary_entries_usecase.dart';

class _RepoOk implements DiaryEntryRepository {
  final _now = DateTime.now();
  @override
  Stream<List<DiaryEntry>> getAllDiaryEntries() => Stream.value([DiaryEntry(title: 'x', content: 'y', createdAt: _now, updatedAt: _now)]);
  @override
  Stream<List<DiaryEntry>> getFavoriteDiaryEntries() => Stream.value(const []);
  @override
  Stream<List<DiaryEntry>> getDiaryEntriesByTags(List<int> tagIds) => Stream.value(const []);
  @override
  Stream<List<DiaryEntry>> getDiaryEntriesByDateRange(DateTime startDate, DateTime endDate) => Stream.value(const []);
  @override
  Future<DiaryEntry?> getDiaryEntryById(int id) async => null;
  @override
  Future<Map<String, int>> getDiaryStatistics() async => {'total': 1, 'favorites': 0, 'monthly': 1};
  @override
  Future<int> createDiaryEntry(DiaryEntry entry) async => 0;
  @override
  Future<bool> updateDiaryEntry(DiaryEntry entry) async => false;
  @override
  Future<bool> deleteDiaryEntry(int id) async => false;
  @override
  Future<bool> deleteDiaryEntries(List<int> ids) async => false;
  @override
  Stream<List<DiaryEntry>> searchDiaryEntries(String query) => Stream.value(const []);
  @override
  Future<bool> toggleFavorite(int id) async => false;
  @override
  Future<bool> addTagToEntry(int entryId, int tagId) async => false;
  @override
  Future<bool> removeTagFromEntry(int entryId, int tagId) async => false;
}

class _RepoThrowsOnGetById extends _RepoOk {
  @override
  Future<DiaryEntry?> getDiaryEntryById(int id) async => throw Exception('IDOops');
}

void main() {
  test('GetDiaryEntriesUseCase 流方法 pass-through 覆盖', () async {
    final uc = GetDiaryEntriesUseCase(_RepoOk());
    expect((await uc.getAllEntries().first).length, 1);
    expect(await uc.getFavoriteEntries().first, isEmpty);
    expect(await uc.getEntriesByTags(const [1]).first, isEmpty);
    expect(await uc.getEntriesByDateRange(DateTime(2020), DateTime(2030)).first, isEmpty);
  });

  test('GetDiaryEntriesUseCase getEntryById 捕获异常', () async {
    final uc = GetDiaryEntriesUseCase(_RepoThrowsOnGetById());
    final r = await uc.getEntryById(1);
    expect(r.isFailure, isTrue);
  });
}

