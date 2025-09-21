import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/facebook_colors.dart';
import '../../../core/theme/facebook_sizes.dart';
import '../../../core/theme/facebook_text_styles.dart';

/// Facebook风格的右侧栏
class FacebookRightSidebar extends StatelessWidget {
  const FacebookRightSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: FacebookColors.surface,
      child: ListView(
        padding: FacebookSizes.paddingAll,
        children: [
          // 常用标签
          _buildSection(
            title: '常用标签',
            child: _buildTagsList(),
          ),

          SizedBox(height: FacebookSizes.spacing24),

          // 写作统计
          _buildSection(
            title: '写作统计',
            child: _buildWritingStats(),
          ),

          SizedBox(height: FacebookSizes.spacing24),

          // 写作提示
          _buildSection(
            title: '写作提示',
            child: _buildWritingTips(),
          ),

          SizedBox(height: FacebookSizes.spacing24),

          // 历史上的今天
          _buildSection(
            title: '历史上的今天',
            child: _buildHistoryToday(),
          ),
        ],
      ),
    );
  }

  /// 构建区块标题
  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: FacebookTextStyles.headline6.copyWith(
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: FacebookSizes.spacing12),
        child,
      ],
    );
  }

  /// 构建标签列表
  Widget _buildTagsList() {
    final tags = ['工作', '生活', '学习', '旅行', '美食', '读书'];

    return Column(
      children: tags.map((tag) {
        return Container(
          margin: EdgeInsets.only(bottom: FacebookSizes.spacing8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: FacebookSizes.spacing8,
                  horizontal: FacebookSizes.spacing4,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: FacebookColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: FacebookSizes.spacing8),
                    Expanded(
                      child: Text(
                        tag,
                        style: FacebookTextStyles.bodySmall,
                      ),
                    ),
                    Text(
                      '${(tags.indexOf(tag) + 1) * 3}',
                      style: FacebookTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 构建写作统计
  Widget _buildWritingStats() {
    return Container(
      padding: FacebookSizes.paddingAll,
      decoration: BoxDecoration(
        color: FacebookColors.background,
        borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
        border: Border.all(
          color: FacebookColors.border,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildStatItem('本月日记', '12', '篇'),
          SizedBox(height: FacebookSizes.spacing12),
          _buildStatItem('总字数', '8.5k', '字'),
          SizedBox(height: FacebookSizes.spacing12),
          _buildStatItem('连续天数', '7', '天'),
        ],
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem(String label, String value, String unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: FacebookTextStyles.bodySmall,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: FacebookTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: FacebookColors.primary,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: FacebookTextStyles.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建写作提示
  Widget _buildWritingTips() {
    final tips = [
      '今天有什么让你印象深刻的事情吗？',
      '尝试描述一下今天的心情变化',
      '记录一下今天学到的新知识',
    ];

    return Column(
      children: tips.map((tip) {
        return Container(
          margin: EdgeInsets.only(bottom: FacebookSizes.spacing8),
          padding: FacebookSizes.paddingSmall,
          decoration: BoxDecoration(
            color: FacebookColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
            border: Border.all(
              color: FacebookColors.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: FacebookColors.primary,
                size: FacebookSizes.iconSmall,
              ),
              SizedBox(width: FacebookSizes.spacing8),
              Expanded(
                child: Text(
                  tip,
                  style: FacebookTextStyles.bodySmall.copyWith(
                    color: FacebookColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 构建历史上的今天
  Widget _buildHistoryToday() {
    return Container(
      padding: FacebookSizes.paddingAll,
      decoration: BoxDecoration(
        color: FacebookColors.success.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
        border: Border.all(
          color: FacebookColors.success.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: FacebookColors.success,
                size: FacebookSizes.iconSmall,
              ),
              SizedBox(width: FacebookSizes.spacing8),
              Text(
                '12月25日',
                style: FacebookTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: FacebookColors.success,
                ),
              ),
            ],
          ),
          SizedBox(height: FacebookSizes.spacing8),
          Text(
            '去年的今天，你写下了关于圣诞节的美好回忆...',
            style: FacebookTextStyles.bodySmall.copyWith(
              color: FacebookColors.textSecondary,
            ),
          ),
          SizedBox(height: FacebookSizes.spacing8),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              '查看详情',
              style: FacebookTextStyles.caption.copyWith(
                color: FacebookColors.success,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}