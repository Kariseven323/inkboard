import 'package:injectable/injectable.dart';

import '../common/result.dart';
import '../entities/tag.dart';
import '../repositories/diary_entry_repository.dart';
import '../repositories/tag_repository.dart';

/// 更新日记条目用例
@injectable
class UpdateDiaryEntryUseCase {
  final DiaryEntryRepository _diaryEntryRepository;
  final TagRepository _tagRepository;

  UpdateDiaryEntryUseCase(this._diaryEntryRepository, this._tagRepository);

  /// 执行更新日记条目
  Future<Result<bool>> execute(UpdateDiaryEntryParams params) async {
    try {
      // 验证输入
      if (params.title.trim().isEmpty) {
        return Result.failure('标题不能为空');
      }

      if (params.content.trim().isEmpty) {
        return Result.failure('内容不能为空');
      }

      // 获取现有条目
      final existing = await _diaryEntryRepository.getDiaryEntryById(params.id);
      if (existing == null) {
        return Result.failure('未找到指定的日记条目');
      }

      // 处理标签变更
      final tags = <Tag>[];
      final oldTagIds = existing.tags.map((tag) => tag.id!).toSet();
      final newTagIds = <int>{};

      for (final tagName in params.tagNames) {
        Tag? tag = await _tagRepository.getTagByName(tagName);
        if (tag == null) {
          // 创建新标签
          final tagId = await _tagRepository.createTag(
            Tag(
              name: tagName,
              color: params.defaultTagColor ?? '#1877F2',
              createdAt: DateTime.now(),
            ),
          );
          tag = await _tagRepository.getTagById(tagId);
        }

        if (tag != null) {
          tags.add(tag);
          newTagIds.add(tag.id!);

          // 如果是新添加的标签，增加使用次数
          if (!oldTagIds.contains(tag.id)) {
            await _tagRepository.incrementTagUsage(tag.id!);
          }
        }
      }

      // 对于移除的标签，减少使用次数
      for (final oldTagId in oldTagIds) {
        if (!newTagIds.contains(oldTagId)) {
          await _tagRepository.decrementTagUsage(oldTagId);
        }
      }

      // 更新日记条目
      final updatedEntry = existing.copyWith(
        title: params.title.trim(),
        content: params.content.trim(),
        updatedAt: DateTime.now(),
        isFavorite: params.isFavorite,
        moodScore: params.moodScore,
        weather: params.weather,
        location: params.location,
        tags: tags,
      );

      final success = await _diaryEntryRepository.updateDiaryEntry(
        updatedEntry,
      );
      if (success) {
        return Result.success(true);
      } else {
        return Result.failure('更新日记失败');
      }
    } catch (e) {
      return Result.failure('更新日记失败: $e');
    }
  }

  /// 切换收藏状态
  Future<Result<bool>> toggleFavorite(int id) async {
    try {
      final success = await _diaryEntryRepository.toggleFavorite(id);
      if (success) {
        return Result.success(true);
      } else {
        return Result.failure('切换收藏状态失败');
      }
    } catch (e) {
      return Result.failure('切换收藏状态失败: $e');
    }
  }
}

/// 删除日记条目用例
@injectable
class DeleteDiaryEntryUseCase {
  final DiaryEntryRepository _diaryEntryRepository;
  final TagRepository _tagRepository;

  DeleteDiaryEntryUseCase(this._diaryEntryRepository, this._tagRepository);

  /// 删除单个日记条目
  Future<Result<bool>> execute(int id) async {
    try {
      // 获取要删除的条目信息，用于减少标签使用次数
      final entry = await _diaryEntryRepository.getDiaryEntryById(id);
      if (entry != null) {
        // 减少相关标签的使用次数
        for (final tag in entry.tags) {
          if (tag.id != null) {
            await _tagRepository.decrementTagUsage(tag.id!);
          }
        }
      }

      final success = await _diaryEntryRepository.deleteDiaryEntry(id);
      if (success) {
        return Result.success(true);
      } else {
        return Result.failure('删除日记失败');
      }
    } catch (e) {
      return Result.failure('删除日记失败: $e');
    }
  }

  /// 批量删除日记条目
  Future<Result<bool>> deleteBatch(List<int> ids) async {
    try {
      if (ids.isEmpty) {
        return Result.failure('请选择要删除的日记条目');
      }

      // 减少相关标签的使用次数
      for (final id in ids) {
        final entry = await _diaryEntryRepository.getDiaryEntryById(id);
        if (entry != null) {
          for (final tag in entry.tags) {
            if (tag.id != null) {
              await _tagRepository.decrementTagUsage(tag.id!);
            }
          }
        }
      }

      final success = await _diaryEntryRepository.deleteDiaryEntries(ids);
      if (success) {
        return Result.success(true);
      } else {
        return Result.failure('批量删除日记失败');
      }
    } catch (e) {
      return Result.failure('批量删除日记失败: $e');
    }
  }
}

/// 更新日记条目的参数
class UpdateDiaryEntryParams {
  final int id;
  final String title;
  final String content;
  final bool isFavorite;
  final int? moodScore;
  final String? weather;
  final String? location;
  final List<String> tagNames;
  final String? defaultTagColor;

  UpdateDiaryEntryParams({
    required this.id,
    required this.title,
    required this.content,
    required this.isFavorite,
    this.moodScore,
    this.weather,
    this.location,
    this.tagNames = const [],
    this.defaultTagColor,
  });
}
