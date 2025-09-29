import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/repositories/diary_entry_repository.dart';
import 'package:inkboard/domain/usecases/get_diary_entries_usecase.dart';

class _RepoThrows implements DiaryEntryRepository {
  @override
  Future<bool> addTagToEntry(int entryId, int tagId) => Future.value(false);
  @override
  Future<bool> deleteDiaryEntries(List<int> ids) => Future.value(false);
  @override
  Future<bool> deleteDiaryEntry(int id) => Future.value(false);
  @override
  Stream<List<DiaryEntry>> getAllDiaryEntries() => Stream.value(const []);
  @override
  Future<Map<String, int>> getDiaryStatistics() =>
      Future<Map<String, int>>.error('X');
  @override
  Stream<List<DiaryEntry>> getDiaryEntriesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) => Stream.value(const []);
  @override
  Stream<List<DiaryEntry>> getDiaryEntriesByTags(List<int> tagIds) =>
      Stream.value(const []);
  @override
  Stream<List<DiaryEntry>> getFavoriteDiaryEntries() => Stream.value(const []);
  @override
  Future<DiaryEntry?> getDiaryEntryById(int id) async => null;
  @override
  Future<int> createDiaryEntry(DiaryEntry entry) async => 0;
  @override
  Future<bool> removeTagFromEntry(int entryId, int tagId) async => false;
  @override
  Stream<List<DiaryEntry>> searchDiaryEntries(String query) =>
      Stream.value(const []);
  @override
  Future<bool> toggleFavorite(int id) async => false;
  @override
  Future<bool> updateDiaryEntry(DiaryEntry entry) async => false;
}

void main() {
  test('GetDiaryEntriesUseCase getStatistics 捕获异常并返回失败', () async {
    final uc = GetDiaryEntriesUseCase(_RepoThrows());
    final r = await uc.getStatistics();
    expect(r.isFailure, isTrue);
  });
}
