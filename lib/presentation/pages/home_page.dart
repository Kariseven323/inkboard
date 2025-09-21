import 'package:flutter/material.dart';
import '../widgets/common/facebook_post_composer.dart';
import '../../core/theme/facebook_colors.dart';
import '../../core/theme/facebook_sizes.dart';

/// 主页面 - 显示发布器和时间线内容
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                // TODO: 打开日记编辑页面
                _showCreateDiaryDialog(context);
              },
              onPhotoTap: () {
                // TODO: 选择照片
                _showSnackBar(context, '选择照片功能开发中...');
              },
              onMoodTap: () {
                // TODO: 选择心情
                _showSnackBar(context, '心情选择功能开发中...');
              },
              onLocationTap: () {
                // TODO: 选择位置
                _showSnackBar(context, '位置选择功能开发中...');
              },
            ),

            // 时间线内容区域（暂时显示占位内容）
            _buildTimelinePlaceholder(),
          ],
        ),
      ),
    );
  }

  /// 构建时间线占位内容
  Widget _buildTimelinePlaceholder() {
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

  /// 显示创建日记对话框（占位实现）
  void _showCreateDiaryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('创建新日记'),
        content: const Text('日记编辑功能将在后续Sprint中实现'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示消息提示
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}