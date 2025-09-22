import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';
import 'package:inkboard/data/services/search_service_impl.dart';
import 'package:inkboard/domain/usecases/create_diary_entry_usecase.dart';

void main() {
  final harness = TestHarness();

  setUp(() async {
    await harness.setUp();
  });

  tearDown(() async {
    await harness.tearDown();
  });

  test('search relevance and snippet highlight', () async {
    final create = CreateDiaryEntryUseCase(harness.diaryRepo, harness.tagRepo);
    final searchService = SearchServiceImpl(harness.diaryRepo, harness.tagRepo);

    await create.execute(CreateDiaryEntryParams(
      title: 'Flutter Drift 全文搜索',
      content: '使用 FTS5 与 SQLCipher 进行加密与全文搜索',
      tagNames: const [],
    ));
    await create.execute(CreateDiaryEntryParams(
      title: '普通标题',
      content: '无关内容',
      tagNames: const [],
    ));

    final items = await searchService.globalSearch('全文搜索');
    expect(items.isNotEmpty, isTrue);
    // 最高相关性应包含高亮
    final top = items.first;
    expect(top.snippet.contains('**全文搜索**'), isTrue);
  });
}
