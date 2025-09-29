import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/repositories/diary_entry_repository.dart';
import 'package:inkboard/domain/usecases/soft_delete_diary_entry_usecase.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';

class _RepoStub implements DiaryEntryRepository {
  bool softDeleteOne = true;
  bool softDeleteMany = true;
  bool throwOnOne = false;
  bool throwOnMany = false;

  @override
  Future<bool> softDeleteDiaryEntry(int id) async {
    if (throwOnOne) throw Exception('x');
    return softDeleteOne;
  }

  @override
  Future<bool> softDeleteDiaryEntries(List<int> ids) async {
    if (throwOnMany) throw Exception('y');
    return softDeleteMany;
  }

  // Unused
  @override
  Future<bool> addTagToEntry(int entryId, int tagId) async => true;
  @override
  Future<int> createDiaryEntry(entry) async => 1;
  @override
  Future<bool> deleteDiaryEntries(List<int> ids) async => true;
  @override
  Future<bool> deleteDiaryEntry(int id) async => true;
  @override
  Future<DiaryEntry?> getDiaryEntryById(int id) async => null;
  @override
  Stream<List<DiaryEntry>> getDiaryEntriesByDateRange(
    startDate,
    endDate,
  ) async* {}
  @override
  Stream<List<DiaryEntry>> getDiaryEntriesByTags(List<int> tagIds) async* {}
  @override
  Stream<List<DiaryEntry>> getAllDiaryEntries() async* {}
  @override
  Stream<List<DiaryEntry>> getFavoriteDiaryEntries() async* {}
  @override
  Stream<List<DiaryEntry>> getDeletedDiaryEntries() async* {}
  @override
  Stream<List<DiaryEntry>> searchDiaryEntries(String query) async* {}
  @override
  Future<Map<String, int>> getDiaryStatistics() async => {};
  @override
  Future<bool> removeTagFromEntry(int entryId, int tagId) async => true;
  @override
  Future<bool> restoreDiaryEntries(List<int> ids) async => true;
  @override
  Future<bool> restoreDiaryEntry(int id) async => true;
  @override
  Future<bool> toggleFavorite(int id) async => true;
  @override
  Future<bool> updateDiaryEntry(entry) async => true;
  @override
  Future<bool> purgeDiaryEntries(List<int> ids) async => true;
  @override
  Future<bool> purgeDiaryEntry(int id) async => true;
}

void main() {
  test('SoftDeleteDiaryEntryUseCase: execute 分支覆盖', () async {
    final repo = _RepoStub();
    final use = SoftDeleteDiaryEntryUseCase(repo);

    // 成功
    var r = await use.execute(1);
    expect(r.isSuccess, isTrue);

    // 返回 false
    repo.softDeleteOne = false;
    r = await use.execute(1);
    expect(r.isSuccess, isFalse);

    // 异常
    repo.throwOnOne = true;
    r = await use.execute(1);
    expect(r.isSuccess, isFalse);
  });

  test('SoftDeleteDiaryEntryUseCase: deleteBatch 分支覆盖', () async {
    final repo = _RepoStub();
    final use = SoftDeleteDiaryEntryUseCase(repo);

    // 空列表
    var r = await use.deleteBatch(const []);
    expect(r.isSuccess, isFalse);

    // 成功
    r = await use.deleteBatch(const [1, 2]);
    expect(r.isSuccess, isTrue);

    // 返回 false
    repo.softDeleteMany = false;
    r = await use.deleteBatch(const [1, 2]);
    expect(r.isSuccess, isFalse);

    // 异常
    repo.throwOnMany = true;
    r = await use.deleteBatch(const [1]);
    expect(r.isSuccess, isFalse);
  });
}
