import 'package:injectable/injectable.dart';

import '../common/result.dart';
import '../entities/diary_entry.dart';
import '../entities/tag.dart';
import '../repositories/diary_entry_repository.dart';
import '../repositories/tag_repository.dart';

/// 创建日记条目用例
@injectable
class CreateDiaryEntryUseCase {
  final DiaryEntryRepository _diaryEntryRepository;
  final TagRepository _tagRepository;

  CreateDiaryEntryUseCase(this._diaryEntryRepository, this._tagRepository);

  /// 执行创建日记条目
  Future<Result<int>> execute(CreateDiaryEntryParams params) async {
    try {
      // 非草稿模式严格校验，草稿放宽
      if (!params.isDraft) {
        if (params.title.trim().isEmpty) {
          return Result.failure('标题不能为空');
        }
        if (params.content.trim().isEmpty) {
          return Result.failure('内容不能为空');
        }
      }

      // 处理标签
      final tags = <Tag>[];
      for (final tagName in params.tagNames) {
        // 查找现有标签或创建新标签
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
          // 增加标签使用次数
          await _tagRepository.incrementTagUsage(tag.id!);
        }
      }

      // 创建日记条目
      final now = DateTime.now();
      final entry = DiaryEntry(
        title: params.title.trim(),
        content: params.content.trim(),
        createdAt: now,
        updatedAt: now,
        isFavorite: params.isFavorite,
        moodScore: params.moodScore,
        weather: params.weather,
        location: params.location,
        tags: tags,
        isDraft: params.isDraft,
      );

      final entryId = await _diaryEntryRepository.createDiaryEntry(entry);
      return Result.success(entryId);
    } catch (e) {
      return Result.failure('创建日记失败: $e');
    }
  }
}

/// 创建日记条目的参数
class CreateDiaryEntryParams {
  final String title;
  final String content;
  final bool isFavorite;
  final int? moodScore;
  final String? weather;
  final String? location;
  final List<String> tagNames;
  final String? defaultTagColor;
  final bool isDraft;

  CreateDiaryEntryParams({
    required this.title,
    required this.content,
    this.isFavorite = false,
    this.moodScore,
    this.weather,
    this.location,
    this.tagNames = const [],
    this.defaultTagColor,
    this.isDraft = false,
  });
}
