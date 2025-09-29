import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/domain/usecases/tag_management_usecase.dart';

import 'fakes.dart';

void main() {
  test('TagManagementUseCase popular/recent/search 流', () async {
    final repo = InMemoryTagRepository();
    final uc = TagManagementUseCase(repo);
    final now = DateTime.now();
    await repo.createTag(Tag(name: 'A', color: '#1', createdAt: now, usageCount: 5));
    await repo.createTag(Tag(name: 'B', color: '#2', createdAt: now, usageCount: 1));
    final popular = await uc.getPopularTags(limit: 1).first;
    expect(popular.length, 1);
    final recent = await uc.getRecentTags(limit: 1).first;
    expect(recent.length, 1);
    final search = await uc.searchTags('A').first;
    expect(search.first.name, 'A');
  });
}

