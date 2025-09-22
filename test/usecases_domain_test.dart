import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/usecases/create_diary_entry_usecase.dart';
import 'package:inkboard/domain/usecases/get_diary_entries_usecase.dart';
import 'package:inkboard/domain/usecases/update_delete_diary_entry_usecase.dart';

import 'fakes.dart';

void main() {
  group('UseCases', () {
    test('CreateDiaryEntryUseCase: 基本成功与输入校验', () async {
      final entryRepo = InMemoryDiaryEntryRepository();
      final tagRepo = InMemoryTagRepository();
      final usecase = CreateDiaryEntryUseCase(entryRepo, tagRepo);

      // 失败：标题/内容为空
      final r1 = await usecase.execute(CreateDiaryEntryParams(title: '', content: 'x'));
      expect(r1.isFailure, true);
      final r2 = await usecase.execute(CreateDiaryEntryParams(title: 't', content: ''));
      expect(r2.isFailure, true);

      // 成功：创建并自动创建标签 + 增加使用次数
      final r3 = await usecase.execute(CreateDiaryEntryParams(
        title: 'T',
        content: 'C',
        tagNames: const ['工作', '学习'],
      ));
      expect(r3.isSuccess, true);
      final id = r3.dataOrThrow;
      final entry = await entryRepo.getDiaryEntryById(id);
      expect(entry != null, true);
      expect(entry!.tags.length, 2);
    });

    test('UpdateDiaryEntryUseCase: 未找到/成功更新/标签计数变化', () async {
      final entryRepo = InMemoryDiaryEntryRepository();
      final tagRepo = InMemoryTagRepository();
      final create = CreateDiaryEntryUseCase(entryRepo, tagRepo);
      final update = UpdateDiaryEntryUseCase(entryRepo, tagRepo);

      final createdId = (await create.execute(CreateDiaryEntryParams(title: 'a', content: 'b', tagNames: const ['A']))).dataOrThrow;

      // 未找到
      final nf = await update.execute(UpdateDiaryEntryParams(
        id: 999,
        title: 'x',
        content: 'y',
        isFavorite: false,
        tagNames: const [],
      ));
      expect(nf.isFailure, true);

      // 成功 & 替换标签（A -> B）
      final ok = await update.execute(UpdateDiaryEntryParams(
        id: createdId,
        title: 'T2',
        content: 'C2',
        isFavorite: true,
        tagNames: const ['B'],
      ));
      expect(ok.isSuccess, true);
      final e2 = await entryRepo.getDiaryEntryById(createdId);
      expect(e2!.title, 'T2');
      expect(e2.isFavorite, true);
      expect(e2.tags.length, 1);
      expect(e2.tags.first.name, 'B');

      // 收藏切换
      final toggled = await update.toggleFavorite(createdId);
      expect(toggled.isSuccess, true);
    });

    test('DeleteDiaryEntryUseCase: 单个与批量', () async {
      final entryRepo = InMemoryDiaryEntryRepository();
      final tagRepo = InMemoryTagRepository();
      final create = CreateDiaryEntryUseCase(entryRepo, tagRepo);
      final del = DeleteDiaryEntryUseCase(entryRepo, tagRepo);

      final id1 = (await create.execute(CreateDiaryEntryParams(title: 'a', content: 'b', tagNames: const ['A']))).dataOrThrow;
      final id2 = (await create.execute(CreateDiaryEntryParams(title: 'c', content: 'd', tagNames: const ['A']))).dataOrThrow;

      // 批量删除空ID集合
      final emptyBatch = await del.deleteBatch(const []);
      expect(emptyBatch.isFailure, true);

      // 删除单个
      final r1 = await del.execute(id1);
      expect(r1.isSuccess, true);
      expect(await entryRepo.getDiaryEntryById(id1), isNull);

      // 批量删除
      final r2 = await del.deleteBatch([id2]);
      expect(r2.isSuccess, true);
      expect(await entryRepo.getDiaryEntryById(id2), isNull);
    });

    test('GetDiaryEntriesUseCase: 流与统计/按条件查询', () async {
      final entryRepo = InMemoryDiaryEntryRepository();
      final tagRepo = InMemoryTagRepository();
      final create = CreateDiaryEntryUseCase(entryRepo, tagRepo);
      final get = GetDiaryEntriesUseCase(entryRepo);

      final now = DateTime.now();
      final id1 = (await create.execute(CreateDiaryEntryParams(title: 'x', content: 'y', isFavorite: true, tagNames: const ['A']))).dataOrThrow;
      final id2 = (await create.execute(CreateDiaryEntryParams(title: 'm', content: 'n', tagNames: const ['B']))).dataOrThrow;

      // all
      final all = await get.getAllEntries().first;
      expect(all.length >= 2, true);
      // favorites
      final fav = await get.getFavoriteEntries().first;
      expect(fav.any((e)=>e.id==id1), true);
      // tags
      final byTags = await get.getEntriesByTags(const [1]).first; // tag A 可能为 id=1（在内存实现中从1开始累加）
      expect(byTags.isNotEmpty, true);
      // date range（包含今天）
      final byDate = await get.getEntriesByDateRange(now.subtract(const Duration(days: 1)), now.add(const Duration(days: 1))).first;
      expect(byDate.length >= 2, true);
      // by id
      final ok = await get.getEntryById(id2);
      expect(ok.isSuccess, true);
      final notfound = await get.getEntryById(9999);
      expect(notfound.isFailure, true);
      // stats
      final stats = await get.getStatistics();
      expect(stats.isSuccess, true);
      expect(stats.dataOrThrow.totalCount >= 2, true);
    });
  });
}
