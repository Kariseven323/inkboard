import 'package:flutter/material.dart';
import '../../../core/theme/facebook_colors.dart';
import '../../../core/theme/facebook_sizes.dart';
import '../../../core/theme/facebook_text_styles.dart';

/// Facebook风格的日记卡片组件
/// 用于显示时间线中的日记内容
class FacebookDiaryCard extends StatelessWidget {
  final String title;
  final String content;
  final DateTime createdAt;
  final List<String>? tags;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onEditTap;
  final VoidCallback? onDeleteTap;
  final VoidCallback? onShareTap;

  const FacebookDiaryCard({
    super.key,
    required this.title,
    required this.content,
    required this.createdAt,
    this.tags,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
    this.onEditTap,
    this.onDeleteTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: FacebookSizes.spacing16),
      child: Card(
        elevation: FacebookSizes.cardElevation,
        shadowColor: FacebookColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
          side: const BorderSide(
            color: FacebookColors.border,
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
          child: Padding(
            padding: FacebookSizes.paddingAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 卡片头部
                _buildCardHeader(),

                SizedBox(height: FacebookSizes.spacing12),

                // 内容区域
                _buildContent(),

                // 标签区域
                if (tags != null && tags!.isNotEmpty) ...[
                  SizedBox(height: FacebookSizes.spacing12),
                  _buildTags(),
                ],

                SizedBox(height: FacebookSizes.spacing12),

                // 分割线
                Divider(
                  height: FacebookSizes.spacing16,
                  thickness: FacebookSizes.dividerThickness,
                  color: FacebookColors.divider,
                ),

                // 操作按钮
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建卡片头部
  Widget _buildCardHeader() {
    return Row(
      children: [
        // 日记图标（替代用户头像）
        Container(
          width: FacebookSizes.avatarMedium,
          height: FacebookSizes.avatarMedium,
          decoration: BoxDecoration(
            color: FacebookColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: FacebookColors.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.edit_note,
            color: FacebookColors.primary,
            size: FacebookSizes.iconMedium,
          ),
        ),

        SizedBox(width: FacebookSizes.spacing12),

        // 标题和时间
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: FacebookTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: FacebookColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: FacebookSizes.spacing4),
              Text(
                _formatDate(createdAt),
                style: FacebookTextStyles.caption.copyWith(
                  color: FacebookColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        // 更多操作按钮
        _buildMoreActionsButton(),
      ],
    );
  }

  /// 构建内容区域
  Widget _buildContent() {
    return SizedBox(
      width: double.infinity,
      child: Text(
        content,
        style: FacebookTextStyles.bodyMedium.copyWith(
          color: FacebookColors.textPrimary,
          height: 1.4,
        ),
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// 构建标签区域
  Widget _buildTags() {
    return Wrap(
      spacing: FacebookSizes.spacing8,
      runSpacing: FacebookSizes.spacing4,
      children: tags!.map((tag) => _buildTag(tag)).toList(),
    );
  }

  /// 构建单个标签
  Widget _buildTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: FacebookSizes.spacing8,
        vertical: FacebookSizes.spacing4,
      ),
      decoration: BoxDecoration(
        color: FacebookColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(FacebookSizes.radiusRound),
        border: Border.all(
          color: FacebookColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        '#$tag',
        style: FacebookTextStyles.caption.copyWith(
          color: FacebookColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: isFavorite ? Icons.favorite : Icons.favorite_border,
            label: isFavorite ? '已收藏' : '收藏',
            color: isFavorite ? FacebookColors.error : FacebookColors.iconGray,
            onTap: onFavoriteTap,
          ),
        ),

        SizedBox(width: FacebookSizes.spacing8),

        Expanded(
          child: _buildActionButton(
            icon: Icons.edit_outlined,
            label: '编辑',
            color: FacebookColors.iconGray,
            onTap: onEditTap,
          ),
        ),

        SizedBox(width: FacebookSizes.spacing8),

        Expanded(
          child: _buildActionButton(
            icon: Icons.share_outlined,
            label: '分享',
            color: FacebookColors.iconGray,
            onTap: onShareTap,
          ),
        ),
      ],
    );
  }

  /// 构建单个操作按钮
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: FacebookSizes.spacing8,
            vertical: FacebookSizes.spacing8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: FacebookSizes.iconMedium,
              ),
              SizedBox(width: FacebookSizes.spacing4),
              Flexible(
                child: Text(
                  label,
                  style: FacebookTextStyles.bodySmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建更多操作按钮
  Widget _buildMoreActionsButton() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_horiz,
        color: FacebookColors.iconGray,
        size: FacebookSizes.iconMedium,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                color: FacebookColors.iconGray,
                size: FacebookSizes.iconMedium,
              ),
              SizedBox(width: FacebookSizes.spacing8),
              Text('编辑日记'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                color: FacebookColors.error,
                size: FacebookSizes.iconMedium,
              ),
              SizedBox(width: FacebookSizes.spacing8),
              Text(
                '删除日记',
                style: TextStyle(color: FacebookColors.error),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEditTap?.call();
            break;
          case 'delete':
            onDeleteTap?.call();
            break;
        }
      },
    );
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return '刚刚';
        }
        return '${difference.inMinutes}分钟前';
      }
      return '${difference.inHours}小时前';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${date.year}年${date.month}月${date.day}日';
    }
  }
}
