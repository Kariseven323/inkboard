import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/domain/usecases/tag_management_usecase.dart';

import 'fakes.dart';

void main() {
  test('TagManagementUseCase 流式API与统计派生字段', () async {
    final repo = InMemoryTagRepository();
    final uc = TagManagementUseCase(repo);

    // 预置标签：不同 usageCount 与顺序
    final now = DateTime.now();
    final id1 = await repo.createTag(
      Tag(name: 'A', color: '#1', createdAt: now, usageCount: 1),
    );
    final id2 = await repo.createTag(
      Tag(name: 'B', color: '#2', createdAt: now, usageCount: 5),
    );
    final id3 = await repo.createTag(
      Tag(name: 'C', color: '#3', createdAt: now, usageCount: 3),
    );

    // getAllTags 初始快照
    final all = await uc.getAllTags().first;
    expect(all.length, 3);

    // 热门标签按 usageCount 降序，limit=2
    final popular = await uc.getPopularTags(limit: 2).first;
    expect(popular.map((t) => t.name).toList(), ['B', 'C']);

    // 最近标签为插入顺序的反序，limit=2
    final recent = await uc.getRecentTags(limit: 2).first;
    expect(recent.map((t) => t.name).toList(), ['C', 'B']);

    // 搜索
    final search = await uc.searchTags('B').first;
    expect(search.map((t) => t.name), contains('B'));

    // 统计派生字段（usageRate / unusedCount）
    final statsRes = await uc.getStatistics();
    final stats = statsRes.dataOrThrow;
    // InMemoryTagRepository.getTagStatistics 仅返回 total/popular 两项
    // unusedCount = total - used
    expect(stats.totalCount, isNonZero);
    expect(stats.unusedCount, stats.totalCount - stats.usedCount);
    // usageRate 在 [0,1]
    expect(stats.usageRate, inInclusiveRange(0.0, 1.0));

    // 清理避免未使用变量警告
    expect([id1, id2, id3].length, 3);
  });
}
