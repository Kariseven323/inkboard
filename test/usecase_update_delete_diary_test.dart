import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';
import 'package:inkboard/domain/usecases/update_delete_diary_entry_usecase.dart';
import 'package:inkboard/domain/usecases/create_diary_entry_usecase.dart';

void main() {
  final harness = TestHarness();

  setUp(() async {
    await harness.setUp();
  });

  tearDown(() async {
    await harness.tearDown();
  });

  test('update and delete diary use cases', () async {
    final create = CreateDiaryEntryUseCase(harness.diaryRepo, harness.tagRepo);
    final update = UpdateDiaryEntryUseCase(harness.diaryRepo, harness.tagRepo);
    final del = DeleteDiaryEntryUseCase(harness.diaryRepo, harness.tagRepo);

    final res = await create.execute(CreateDiaryEntryParams(
      title: '初始标题',
      content: '内容A',
      tagNames: ['标签A'],
    ));
    expect(res.isSuccess, isTrue);
    final id = res.dataOrThrow;

    final upd = await update.execute(UpdateDiaryEntryParams(
      id: id,
      title: '更新标题',
      content: '内容B',
      tagNames: ['标签B'],
      isFavorite: false,
    ));
    expect(upd.isSuccess, isTrue);

    final all = await harness.diaryRepo.getAllDiaryEntries().first;
    expect(all.any((e) => e.title == '更新标题'), isTrue);

    final delRes = await del.execute(id);
    expect(delRes.isSuccess, isTrue);
    final after = await harness.diaryRepo.getDiaryEntryById(id);
    expect(after, isNull);
  });
}
