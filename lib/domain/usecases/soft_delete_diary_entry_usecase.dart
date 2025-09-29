import 'package:injectable/injectable.dart';

import '../common/result.dart';
import '../repositories/diary_entry_repository.dart';

@injectable
class SoftDeleteDiaryEntryUseCase {
  final DiaryEntryRepository _repo;
  SoftDeleteDiaryEntryUseCase(this._repo);

  Future<Result<bool>> execute(int id) async {
    try {
      final ok = await _repo.softDeleteDiaryEntry(id);
      return ok ? Result.success(true) : Result.failure('软删除失败');
    } catch (e) {
      return Result.failure('软删除失败: $e');
    }
  }

  Future<Result<bool>> deleteBatch(List<int> ids) async {
      if (ids.isEmpty) {
        return Result.failure('请选择要删除的日记条目');
      }
      try {
        final ok = await _repo.softDeleteDiaryEntries(ids);
        return ok ? Result.success(true) : Result.failure('软删除失败');
      } catch (e) {
        return Result.failure('软删除失败: $e');
      }
  }
}

