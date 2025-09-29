import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/domain/usecases/tag_management_usecase.dart';

import 'fakes.dart';

void main() {
  test('TagManagementUseCase 创建/更新/删除边界', () async {
    final repo = InMemoryTagRepository();
    final uc = TagManagementUseCase(repo);

    // 创建失败：空名
    final bad = await uc.createTag(CreateTagParams(name: '   '));
    expect(bad.isFailure, isTrue);

    // 创建成功且去重校验
    final ok1 = await uc.createTag(
      CreateTagParams(name: '编程', color: '#000000'),
    );
    expect(ok1.isSuccess, isTrue);
    final ok2 = await uc.createTag(CreateTagParams(name: '生活'));
    expect(ok2.isSuccess, isTrue);
    final dup = await uc.createTag(CreateTagParams(name: '编程'));
    expect(dup.isFailure, isTrue);

    // 更新：不存在/重名/成功
    final updateMissing = await uc.updateTag(
      UpdateTagParams(id: 999, name: 'X', color: '#fff'),
    );
    expect(updateMissing.isFailure, isTrue);

    final id1 = ok1.dataOrThrow;
    // 第二个创建成功但此处无需使用其ID
    final conflict = await uc.updateTag(
      UpdateTagParams(id: id1, name: '生活', color: '#fff'),
    );
    expect(conflict.isFailure, isTrue);

    final updateOK = await uc.updateTag(
      UpdateTagParams(id: id1, name: '编程1', color: '#333'),
    );
    expect(updateOK.isSuccess, isTrue);

    // 删除/批量删除成功（自定义标签）
    final delBatchOK = await uc.deleteTags([id1]);
    expect(delBatchOK.isSuccess, isTrue);

    // 默认标签不可删
    final defId = await repo.createTag(
      Tag(name: '工作', color: '#1877F2', createdAt: DateTime.now()),
    );
    final delDefault = await uc.deleteTag(defId);
    expect(delDefault.isFailure, isTrue);
    final batchDefault = await uc.deleteTags([defId]);
    expect(batchDefault.isFailure, isTrue);

    // 统计
    final stats = await uc.getStatistics();
    expect(stats.isSuccess, isTrue);

    // 批量删除空列表
    final emptyBatch = await uc.deleteTags([]);
    expect(emptyBatch.isFailure, isTrue);
  });
}
