import '../entities/tag.dart';

/// 标签仓储接口
abstract class TagRepository {
  /// 获取所有标签
  Stream<List<Tag>> getAllTags();

  /// 根据ID获取标签
  Future<Tag?> getTagById(int id);

  /// 根据名称获取标签
  Future<Tag?> getTagByName(String name);

  /// 创建标签
  Future<int> createTag(Tag tag);

  /// 更新标签
  Future<bool> updateTag(Tag tag);

  /// 删除标签
  Future<bool> deleteTag(int id);

  /// 搜索标签（根据名称或描述）
  Stream<List<Tag>> searchTags(String query);

  /// 获取热门标签（按使用次数排序）
  Stream<List<Tag>> getPopularTags({int limit = 10});

  /// 获取最近使用的标签
  Stream<List<Tag>> getRecentTags({int limit = 5});

  /// 增加标签使用次数
  Future<bool> incrementTagUsage(int tagId);

  /// 减少标签使用次数
  Future<bool> decrementTagUsage(int tagId);

  /// 批量删除标签
  Future<bool> deleteTags(List<int> ids);

  /// 获取标签统计信息
  Future<Map<String, int>> getTagStatistics();

  /// 检查标签名称是否存在
  Future<bool> isTagNameExists(String name, {int? excludeId});
}
