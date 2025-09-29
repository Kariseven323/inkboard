import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';
import 'package:inkboard/domain/usecases/tag_management_usecase.dart';

void main() {
  final harness = TestHarness();

  setUp(() async {
    await harness.setUp();
  });

  tearDown(() async {
    await harness.tearDown();
  });

  test('tag management use cases', () async {
    final uc = TagManagementUseCase(harness.tagRepo);

    final create = await uc.createTag(
      CreateTagParams(name: '用例标签', color: '#123456'),
    );
    expect(create.isSuccess, isTrue);
    final id = create.dataOrThrow;

    final getRes = await uc.getTagById(id);
    expect(getRes.isSuccess, isTrue);
    expect(getRes.dataOrThrow.name, '用例标签');

    final upd = await uc.updateTag(
      UpdateTagParams(id: id, name: '用例标签2', color: '#654321'),
    );
    expect(upd.isSuccess, isTrue);

    final stats = await uc.getStatistics();
    expect(stats.isSuccess, isTrue);

    final del = await uc.deleteTag(id);
    expect(del.isSuccess, isTrue);
  });
}
