import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/facebook_colors.dart';
import '../../../core/theme/facebook_sizes.dart';
import '../../../core/theme/facebook_text_styles.dart';
import '../../providers/theme_provider.dart';

/// Facebook风格的右侧栏
class FacebookRightSidebar extends ConsumerWidget {
  const FacebookRightSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: FacebookColors.surface,
      child: ListView(
        // 使用常量间距，避免在固定宽侧栏内被放大
        padding: const EdgeInsets.all(12.0),
        children: [
          // 设置区块
          _buildSection(
            title: '设置',
            child: _buildSettingsSection(context, ref),
          ),

          const SizedBox(height: 24.0),

          // 常用标签
          _buildSection(title: '常用标签', child: _buildTagsList()),

          const SizedBox(height: 24.0),

          // 写作统计
          _buildSection(title: '写作统计', child: _buildWritingStats()),

          const SizedBox(height: 24.0),

          // 写作提示
          _buildSection(title: '写作提示', child: _buildWritingTips()),

          const SizedBox(height: 24.0),

          // 历史上的今天
          _buildSection(title: '历史上的今天', child: _buildHistoryToday()),
        ],
      ),
    );
  }

  /// 构建设置区块
  Widget _buildSettingsSection(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider.notifier);

    return Container(
      padding: FacebookSizes.paddingAll,
      decoration: BoxDecoration(
        color: FacebookColors.background,
        borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
        border: Border.all(color: FacebookColors.border, width: 1),
      ),
      child: Column(
        children: [
          // 主题切换
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await themeNotifier.toggleTheme();
              },
              borderRadius: BorderRadius.circular(FacebookSizes.radiusMedium),
              child: Padding(
                // 使用常量像素，避免在测试环境下缩放导致行内元素过大
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32.0,
                      height: 32.0,
                      decoration: BoxDecoration(
                        color: FacebookColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        themeNotifier.getThemeIcon(),
                        color: FacebookColors.primary,
                        size: 16.0,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '主题模式',
                            style: FacebookTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            themeNotifier.getThemeDisplayName(),
                            style: FacebookTextStyles.caption.copyWith(
                              color: FacebookColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: FacebookColors.iconGray,
                      size: 16.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建区块标题
  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: FacebookTextStyles.headline6.copyWith(fontSize: 16)),
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
          margin: const EdgeInsets.only(bottom: 8.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color: FacebookColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(tag, style: FacebookTextStyles.bodySmall),
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
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: FacebookColors.background,
        borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
        border: Border.all(color: FacebookColors.border, width: 1),
      ),
      child: Column(
        children: const [
          // 使用常量间距，避免在固定宽度内溢出
          // ignore: prefer_const_constructors
          _StatRow(label: '本月日记', value: '12', unit: '篇'),
          SizedBox(height: 12.0),
          _StatRow(label: '总字数', value: '8.5k', unit: '字'),
          SizedBox(height: 12.0),
          _StatRow(label: '连续天数', value: '7', unit: '天'),
        ],
      ),
    );
  }

  /// 构建统计项（使用自定义小部件，减少行内复杂度）
  // 保持样式不变，仅控制布局间距为常量

  /// 构建写作提示
  Widget _buildWritingTips() {
    final tips = ['今天有什么让你印象深刻的事情吗？', '尝试描述一下今天的心情变化', '记录一下今天学到的新知识'];

    return Column(
      children: tips.map((tip) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          padding: const EdgeInsets.all(8.0),
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
                size: 16.0,
              ),
              const SizedBox(width: 8.0),
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
      padding: const EdgeInsets.all(12.0),
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
                size: 16.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                '12月25日',
                style: FacebookTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: FacebookColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            '去年的今天，你写下了关于圣诞节的美好回忆...',
            style: FacebookTextStyles.bodySmall.copyWith(
              color: FacebookColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8.0),
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

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  const _StatRow({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: FacebookTextStyles.bodySmall),
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
              TextSpan(text: ' $unit', style: FacebookTextStyles.caption),
            ],
          ),
        ),
      ],
    );
  }
}
