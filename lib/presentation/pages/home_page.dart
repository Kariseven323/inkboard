import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/common/facebook_post_composer.dart';
import '../widgets/common/facebook_diary_card.dart';
import '../providers/diary_provider.dart';
import 'diary_edit_page.dart';
import '../../core/di/service_locator.dart';
import '../../core/theme/facebook_colors.dart';
import '../../core/theme/facebook_sizes.dart';
import '../../core/theme/facebook_text_styles.dart';
import '../../domain/entities/diary_entry.dart';
import '../../domain/usecases/update_delete_diary_entry_usecase.dart';

/// 主页面 - 显示发布器和时间线内容
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: FacebookColors.background,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(FacebookSizes.spacing16),
        child: Column(
          children: [
            // 发布器组件
            FacebookPostComposer(
              placeholder: '今天你想记录什么？',
              onTap: () {
                // 打开日记编辑页面
                _openDiaryEditPage(context);
              },
              onPhotoTap: () {
                // TODO: 选择照片
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('选择照片功能开发中...'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              onMoodTap: () {
                // TODO: 选择心情
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('心情选择功能开发中...'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              onLocationTap: () {
                // TODO: 选择位置
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('位置选择功能开发中...'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),

            SizedBox(height: FacebookSizes.spacing16),

            // 日记列表区域
            _buildDiaryList(context, ref),
          ],
        ),
      ),
    );
  }

  /// 构建日记列表
  Widget _buildDiaryList(BuildContext context, WidgetRef ref) {
    final diaryEntriesAsync = ref.watch(diaryEntriesProvider);

    return diaryEntriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return _buildEmptyState();
        }
        return Column(
          children: entries.map((entry) => _buildDiaryCard(context, entry)).toList(),
        );
      },
      loading: () => _buildLoadingState(),
      error: (error, stackTrace) => _buildErrorState(error.toString()),
    );
  }

  /// 构建日记卡片
  Widget _buildDiaryCard(BuildContext context, DiaryEntry entry) {
    return FacebookDiaryCard(
      title: entry.title,
      content: entry.content,
      createdAt: entry.createdAt,
      tags: entry.tags.map((tag) => tag.name).toList(),
      isFavorite: entry.isFavorite,
      onTap: () {
        // TODO: 打开日记详情页面
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('日记详情功能开发中...'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      onFavoriteTap: () {
        // TODO: 切换收藏状态
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('收藏功能开发中...'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      onEditTap: () {
        // 打开编辑页面
        _openDiaryEditPage(context, entry);
      },
      onDeleteTap: () {
        // 显示删除确认对话框
        _showDeleteConfirmDialog(context, entry);
      },
      onShareTap: () {
        // TODO: 分享日记
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('分享功能开发中...'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Container(
      padding: FacebookSizes.paddingAll,
      child: Card(
        elevation: FacebookSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
          side: const BorderSide(
            color: FacebookColors.border,
            width: 1,
          ),
        ),
        child: Padding(
          padding: FacebookSizes.paddingAll,
          child: Column(
            children: [
              Icon(
                Icons.article_outlined,
                size: 64,
                color: FacebookColors.iconGray,
              ),
              SizedBox(height: FacebookSizes.spacing16),
              Text(
                '还没有日记内容',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: FacebookColors.textPrimary,
                ),
              ),
              SizedBox(height: FacebookSizes.spacing8),
              Text(
                '点击上方的输入框开始记录你的第一篇日记吧！',
                style: TextStyle(
                  fontSize: 14,
                  color: FacebookColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建加载状态
  Widget _buildLoadingState() {
    return Container(
      padding: FacebookSizes.paddingAll,
      child: Card(
        elevation: FacebookSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
          side: const BorderSide(
            color: FacebookColors.border,
            width: 1,
          ),
        ),
        child: Padding(
          padding: FacebookSizes.paddingAll,
          child: Column(
            children: [
              CircularProgressIndicator(
                color: FacebookColors.primary,
              ),
              SizedBox(height: FacebookSizes.spacing16),
              Text(
                '正在加载日记...',
                style: TextStyle(
                  fontSize: 16,
                  color: FacebookColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建错误状态
  Widget _buildErrorState(String error) {
    return Container(
      padding: FacebookSizes.paddingAll,
      child: Card(
        elevation: FacebookSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
          side: const BorderSide(
            color: FacebookColors.border,
            width: 1,
          ),
        ),
        child: Padding(
          padding: FacebookSizes.paddingAll,
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: FacebookColors.error,
              ),
              SizedBox(height: FacebookSizes.spacing16),
              Text(
                '加载失败',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: FacebookColors.textPrimary,
                ),
              ),
              SizedBox(height: FacebookSizes.spacing8),
              Text(
                error,
                style: TextStyle(
                  fontSize: 14,
                  color: FacebookColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 打开日记编辑页面
  Future<void> _openDiaryEditPage(BuildContext context, [DiaryEntry? diaryEntry]) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => DiaryEditPage(diaryEntry: diaryEntry),
      ),
    );

    // 如果保存成功，刷新数据
    if (result == true) {
      // Provider会自动刷新，无需手动操作
    }
  }

  /// 显示删除确认对话框
  Future<void> _showDeleteConfirmDialog(BuildContext context, DiaryEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_outlined,
              color: FacebookColors.error,
              size: FacebookSizes.iconMedium,
            ),
            SizedBox(width: FacebookSizes.spacing8),
            Text(
              '删除日记',
              style: FacebookTextStyles.headline6.copyWith(
                color: FacebookColors.textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '确定要删除这篇日记吗？',
              style: FacebookTextStyles.bodyMedium.copyWith(
                color: FacebookColors.textPrimary,
              ),
            ),
            SizedBox(height: FacebookSizes.spacing8),
            Container(
              padding: FacebookSizes.paddingAll,
              decoration: BoxDecoration(
                color: FacebookColors.background,
                borderRadius: BorderRadius.circular(FacebookSizes.radiusMedium),
                border: Border.all(color: FacebookColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: FacebookTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: FacebookColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: FacebookSizes.spacing4),
                  Text(
                    entry.content,
                    style: FacebookTextStyles.bodySmall.copyWith(
                      color: FacebookColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(height: FacebookSizes.spacing8),
            Text(
              '此操作无法撤销',
              style: FacebookTextStyles.bodySmall.copyWith(
                color: FacebookColors.error,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              '取消',
              style: FacebookTextStyles.bodyMedium.copyWith(
                color: FacebookColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              backgroundColor: FacebookColors.error.withValues(alpha: 0.1),
            ),
            child: Text(
              '删除',
              style: FacebookTextStyles.bodyMedium.copyWith(
                color: FacebookColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (context.mounted) {
        await _deleteDiary(context, entry);
      }
    }
  }

  /// 删除日记
  Future<void> _deleteDiary(BuildContext context, DiaryEntry entry) async {
    try {
      final deleteUseCase = getIt<DeleteDiaryEntryUseCase>();
      final result = await deleteUseCase.execute(entry.id!);

      if (result.isSuccess) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: FacebookSizes.iconSmall,
                  ),
                  SizedBox(width: FacebookSizes.spacing8),
                  Text('日记已删除'),
                ],
              ),
              backgroundColor: FacebookColors.success,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(FacebookSizes.radiusMedium),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: FacebookSizes.iconSmall,
                  ),
                  SizedBox(width: FacebookSizes.spacing8),
                  Expanded(
                    child: Text(result.error ?? '删除失败'),
                  ),
                ],
              ),
              backgroundColor: FacebookColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(FacebookSizes.radiusMedium),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: FacebookSizes.iconSmall,
                ),
                SizedBox(width: FacebookSizes.spacing8),
                Expanded(
                  child: Text('删除失败：$e'),
                ),
              ],
            ),
            backgroundColor: FacebookColors.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(FacebookSizes.radiusMedium),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}