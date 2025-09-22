import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';
import 'package:inkboard/domain/usecases/create_diary_entry_usecase.dart';
import 'package:inkboard/domain/usecases/search_diary_usecase.dart';
import 'package:inkboard/data/services/search_service_impl.dart';

void main() {
  final harness = TestHarness();

  setUp(() async {
    await harness.setUp();
  });

  tearDown(() async {
    await harness.tearDown();
  });

  test('use cases: create diary with tags then global search', () async {
    final create = CreateDiaryEntryUseCase(harness.diaryRepo, harness.tagRepo);
    final searchService = SearchServiceImpl(harness.diaryRepo, harness.tagRepo);
    final search = SearchDiaryUseCase(searchService);

    final res = await create.execute(CreateDiaryEntryParams(
      title: '项目总结',
      content: '包含加密字段与搜索功能验证',
      tagNames: ['生活', '思考'],
    ));
    expect(res.isSuccess, isTrue);

    final global = await search.globalSearch('搜索');
    expect(global.isSuccess, isTrue);
    expect(global.data!.isNotEmpty, isTrue);

    final diaryHits = await search.searchDiaryEntries('加密').first;
    expect(diaryHits.any((e) => e.title == '项目总结'), isTrue);
  });
}

