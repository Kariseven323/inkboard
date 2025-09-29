import 'package:flutter/material.dart';
import '../../../core/theme/facebook_colors.dart';
import '../../../core/theme/facebook_sizes.dart';
import '../../../core/theme/facebook_text_styles.dart';
import '../../pages/tag_management_page.dart';
import '../../pages/favorites_page.dart';
import '../../pages/export_page.dart';
import '../../pages/settings_page.dart';

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
          _buildUserProfile(context),

          // 导航菜单
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavigationItem(
                  icon: Icons.home_outlined,
                  title: '主页',
                  isActive: true,
                  onTap: () {},
                ),
                _buildNavigationItem(
                  icon: Icons.local_offer_outlined,
                  title: '标签管理',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const TagManagementPage(),
                      ),
                    );
                  },
                ),
                _buildNavigationItem(
                  icon: Icons.favorite_border_outlined,
                  title: '收藏夹',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FavoritesPage()),
                    );
                  },
                ),
                _buildNavigationItem(
                  icon: Icons.analytics_outlined,
                  title: '统计分析',
                  onTap: () {},
                ),

                // 分割线
                Divider(
                  height: 24.0,
                  thickness: FacebookSizes.dividerThickness,
                  color: FacebookColors.divider,
                  indent: 12.0,
                  endIndent: 12.0,
                ),

                _buildNavigationItem(
                  icon: Icons.file_download_outlined,
                  title: '导出数据',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ExportPage()),
                    );
                  },
                ),
                _buildNavigationItem(
                  icon: Icons.settings_outlined,
                  title: '设置',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                ),

                // 底部信息移入可滚动区域，避免整体高度溢出
                SizedBox(height: 8),
                _buildBottomInfo(),
              ],
            ),
          ),
          // 底部留白
          SizedBox(height: 8),
        ],
      ),
    );
  }

  /// 构建用户资料信息
  Widget _buildUserProfile(BuildContext context) {
    return InkWell(
      onTap: () {
        // Sprint1：先跳转到设置页中的外观/通用，后续Sprint2替换为“编辑资料”页面
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        );
      },
      borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final avatar = const CircleAvatar(
              radius: 20.0,
              backgroundColor: FacebookColors.primary,
              child: Icon(
                Icons.person,
                color: FacebookColors.textOnPrimary,
                size: 20.0,
              ),
            );

          final texts = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '用户名',
                style: FacebookTextStyles.username,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '编辑资料',
                style: FacebookTextStyles.caption.copyWith(
                  color: FacebookColors.primary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );

          if (constraints.maxWidth < 160) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: avatar),
                const SizedBox(height: 8),
                texts,
              ],
            );
          }

          return Row(
            children: [
              avatar,
              const SizedBox(width: 12),
              Expanded(child: texts),
            ],
          );
        },
      ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 160;
        // 使用常量像素，避免在固定240px侧栏内被ScreenUtil放大导致溢出
        final horizontalPadding = compact ? 8.0 : 12.0;
        final verticalPadding = compact ? 8.0 : 12.0;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
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
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: compact
                    ? Center(
                        child: Icon(
                          icon,
                          color: isActive
                              ? FacebookColors.primary
                              : FacebookColors.iconGray,
                          size: 18.0,
                        ),
                      )
                    : Row(
                        children: [
                          Icon(
                            icon,
                            color: isActive
                                ? FacebookColors.primary
                                : FacebookColors.iconGray,
                            size: compact ? 18.0 : 20.0,
                          ),
                          const SizedBox(width: 12.0),
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
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          if (trailing != null) trailing,
                        ],
                      ),
              ),
            ),
          ),
        );
      },
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
