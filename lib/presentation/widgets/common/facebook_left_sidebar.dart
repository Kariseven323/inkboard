import 'package:flutter/material.dart';
import '../../../core/theme/facebook_colors.dart';
import '../../../core/theme/facebook_sizes.dart';
import '../../../core/theme/facebook_text_styles.dart';

/// Facebook风格的左侧导航栏
class FacebookLeftSidebar extends StatelessWidget {
  const FacebookLeftSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: FacebookColors.surface,
      child: Column(
        children: [
          // 顶部用户信息
          _buildUserProfile(),

          // 导航菜单
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavigationItem(
                  icon: Icons.home,
                  title: '主页',
                  isActive: true,
                  onTap: () {},
                ),
                _buildNavigationItem(
                  icon: Icons.book,
                  title: '我的日记',
                  onTap: () {},
                ),
                _buildNavigationItem(
                  icon: Icons.label,
                  title: '标签管理',
                  onTap: () {},
                ),
                _buildNavigationItem(
                  icon: Icons.star,
                  title: '收藏夹',
                  onTap: () {},
                ),
                _buildNavigationItem(
                  icon: Icons.analytics,
                  title: '统计分析',
                  onTap: () {},
                ),
                _buildNavigationItem(
                  icon: Icons.search,
                  title: '高级搜索',
                  onTap: () {},
                ),

                // 分割线
                Divider(
                  height: FacebookSizes.spacing24,
                  thickness: FacebookSizes.dividerThickness,
                  color: FacebookColors.divider,
                  indent: FacebookSizes.spacing16,
                  endIndent: FacebookSizes.spacing16,
                ),

                _buildNavigationItem(
                  icon: Icons.file_download,
                  title: '导出数据',
                  onTap: () {},
                ),
                _buildNavigationItem(
                  icon: Icons.settings,
                  title: '设置',
                  onTap: () {},
                ),
              ],
            ),
          ),

          // 底部信息
          _buildBottomInfo(),
        ],
      ),
    );
  }

  /// 构建用户资料信息
  Widget _buildUserProfile() {
    return Container(
      padding: FacebookSizes.paddingAll,
      child: Row(
        children: [
          CircleAvatar(
            radius: FacebookSizes.avatarMedium / 2,
            backgroundColor: FacebookColors.primary,
            child: Icon(
              Icons.person,
              color: FacebookColors.textOnPrimary,
              size: FacebookSizes.iconLarge,
            ),
          ),
          SizedBox(width: FacebookSizes.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '用户名',
                  style: FacebookTextStyles.username,
                ),
                Text(
                  '编辑资料',
                  style: FacebookTextStyles.caption.copyWith(
                    color: FacebookColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建导航项
  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    bool isActive = false,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: FacebookSizes.spacing8,
        vertical: FacebookSizes.spacing2,
      ),
      child: Material(
        color: isActive
            ? FacebookColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: FacebookSizes.spacing12,
              vertical: FacebookSizes.spacing12,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive
                      ? FacebookColors.primary
                      : FacebookColors.iconGray,
                  size: FacebookSizes.iconMedium,
                ),
                SizedBox(width: FacebookSizes.spacing12),
                Expanded(
                  child: Text(
                    title,
                    style: FacebookTextStyles.bodyMedium.copyWith(
                      color: isActive
                          ? FacebookColors.primary
                          : FacebookColors.textPrimary,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建底部信息
  Widget _buildBottomInfo() {
    return Container(
      padding: FacebookSizes.paddingAll,
      child: Column(
        children: [
          Divider(
            height: FacebookSizes.spacing16,
            thickness: FacebookSizes.dividerThickness,
            color: FacebookColors.divider,
          ),
          Text(
            '砚记 v1.0.0',
            style: FacebookTextStyles.caption,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: FacebookSizes.spacing4),
          Text(
            '© 2025 ultrathink',
            style: FacebookTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}