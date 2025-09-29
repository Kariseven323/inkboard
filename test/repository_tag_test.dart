import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';
import 'package:inkboard/domain/entities/tag.dart';

void main() {
  final harness = TestHarness();

  setUp(() async {
    await harness.setUp();
  });

  tearDown(() async {
    await harness.tearDown();
  });

  test('tag CRUD and queries', () async {
    final id = await harness.tagRepo.createTag(
      Tag(name: '编程', color: '#2196F3', createdAt: DateTime.now()),
    );

    final fetched = await harness.tagRepo.getTagById(id);
    expect(fetched?.name, '编程');

    final updated = await harness.tagRepo.updateTag(
      fetched!.copyWith(color: '#000000'),
    );
    expect(updated, isTrue);

    final exists = await harness.tagRepo.isTagNameExists('编程');
    expect(exists, isTrue);

    final popular = await harness.tagRepo.getPopularTags().first;
    expect(popular, isNotNull);

    final recent = await harness.tagRepo.getRecentTags().first;
    expect(recent.isNotEmpty, isTrue);

    final search = await harness.tagRepo.searchTags('编').first;
    expect(search.any((t) => t.id == id), isTrue);

    final deleted = await harness.tagRepo.deleteTag(id);
    expect(deleted, isTrue);
  });
}
