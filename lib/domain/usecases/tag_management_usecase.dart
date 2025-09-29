import 'package:injectable/injectable.dart';

import '../common/result.dart';
import '../entities/tag.dart';
import '../repositories/tag_repository.dart';

/// 标签管理用例
@injectable
class TagManagementUseCase {
  final TagRepository _tagRepository;

  TagManagementUseCase(this._tagRepository);

  /// 获取所有标签
  Stream<List<Tag>> getAllTags() {
    return _tagRepository.getAllTags();
  }

  /// 获取热门标签
  Stream<List<Tag>> getPopularTags({int limit = 10}) {
    return _tagRepository.getPopularTags(limit: limit);
  }

  /// 获取最近使用的标签
  Stream<List<Tag>> getRecentTags({int limit = 5}) {
    return _tagRepository.getRecentTags(limit: limit);
  }

  /// 创建新标签
  Future<Result<int>> createTag(CreateTagParams params) async {
    try {
      // 验证输入
      if (params.name.trim().isEmpty) {
        return Result.failure('标签名称不能为空');
      }

      // 检查名称是否已存在
      final exists = await _tagRepository.isTagNameExists(params.name.trim());
      if (exists) {
        return Result.failure('标签名称已存在');
      }

      // 创建标签
      final tag = Tag(
        name: params.name.trim(),
        color: params.color,
        createdAt: DateTime.now(),
        description: params.description?.trim(),
      );

      final tagId = await _tagRepository.createTag(tag);
      return Result.success(tagId);
    } catch (e) {
      return Result.failure('创建标签失败: $e');
    }
  }

  /// 更新标签
  Future<Result<bool>> updateTag(UpdateTagParams params) async {
    try {
      // 验证输入
      if (params.name.trim().isEmpty) {
        return Result.failure('标签名称不能为空');
      }

      // 检查标签是否存在
      final existing = await _tagRepository.getTagById(params.id);
      if (existing == null) {
        return Result.failure('未找到指定的标签');
      }

      // 检查名称是否与其他标签冲突
      final nameExists = await _tagRepository.isTagNameExists(
        params.name.trim(),
        excludeId: params.id,
      );
      if (nameExists) {
        return Result.failure('标签名称已存在');
      }

      // 更新标签
      final updatedTag = existing.copyWith(
        name: params.name.trim(),
        color: params.color,
        description: params.description?.trim(),
      );

      final success = await _tagRepository.updateTag(updatedTag);
      if (success) {
        return Result.success(true);
      } else {
        return Result.failure('更新标签失败');
      }
    } catch (e) {
      return Result.failure('更新标签失败: $e');
    }
  }

  /// 删除标签
  Future<Result<bool>> deleteTag(int id) async {
    try {
      // 检查标签是否存在
      final tag = await _tagRepository.getTagById(id);
      if (tag == null) {
        return Result.failure('未找到指定的标签');
      }

      // 检查是否为默认标签
      if (tag.isDefault) {
        return Result.failure('无法删除系统预设标签');
      }

      final success = await _tagRepository.deleteTag(id);
      if (success) {
        return Result.success(true);
      } else {
        return Result.failure('删除标签失败');
      }
    } catch (e) {
      return Result.failure('删除标签失败: $e');
    }
  }

  /// 批量删除标签
  Future<Result<bool>> deleteTags(List<int> ids) async {
    try {
      if (ids.isEmpty) {
        return Result.failure('请选择要删除的标签');
      }

      // 检查是否包含默认标签
      for (final id in ids) {
        final tag = await _tagRepository.getTagById(id);
        if (tag != null && tag.isDefault) {
          return Result.failure('无法删除系统预设标签');
        }
      }

      final success = await _tagRepository.deleteTags(ids);
      if (success) {
        return Result.success(true);
      } else {
        return Result.failure('批量删除标签失败');
      }
    } catch (e) {
      return Result.failure('批量删除标签失败: $e');
    }
  }

  /// 搜索标签
  Stream<List<Tag>> searchTags(String query) {
    return _tagRepository.searchTags(query);
  }

  /// 根据ID获取标签
  Future<Result<Tag>> getTagById(int id) async {
    try {
      final tag = await _tagRepository.getTagById(id);
      if (tag == null) {
        return Result.failure('未找到指定的标签');
      }
      return Result.success(tag);
    } catch (e) {
      return Result.failure('获取标签失败: $e');
    }
  }

  /// 获取标签统计信息
  Future<Result<TagStatistics>> getStatistics() async {
    try {
      final stats = await _tagRepository.getTagStatistics();
      return Result.success(TagStatistics.fromMap(stats));
    } catch (e) {
      return Result.failure('获取标签统计失败: $e');
    }
  }
}

/// 创建标签的参数
class CreateTagParams {
  final String name;
  final String color;
  final String? description;

  CreateTagParams({
    required this.name,
    this.color = '#1877F2',
    this.description,
  });
}

/// 更新标签的参数
class UpdateTagParams {
  final int id;
  final String name;
  final String color;
  final String? description;

  UpdateTagParams({
    required this.id,
    required this.name,
    required this.color,
    this.description,
  });
}

/// 标签统计信息
class TagStatistics {
  final int totalCount;
  final int usedCount;
  final int monthlyCreatedCount;

  TagStatistics({
    required this.totalCount,
    required this.usedCount,
    required this.monthlyCreatedCount,
  });

  factory TagStatistics.fromMap(Map<String, int> map) {
    return TagStatistics(
      totalCount: map['total'] ?? 0,
      usedCount: map['used'] ?? 0,
      monthlyCreatedCount: map['monthly_created'] ?? 0,
    );
  }

  /// 获取标签使用率
  double get usageRate {
    if (totalCount == 0) return 0.0;
    return usedCount / totalCount;
  }

  /// 获取未使用的标签数量
  int get unusedCount => totalCount - usedCount;
}
