import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/facebook_colors.dart';
import '../../core/theme/facebook_sizes.dart';
import '../widgets/common/facebook_left_sidebar.dart';
import '../widgets/common/facebook_right_sidebar.dart';

/// Facebook风格的主布局
/// 实现三栏布局：左侧导航栏 + 主内容区 + 右侧栏
class FacebookLayout extends StatelessWidget {
  final Widget child;
  final bool showLeftSidebar;
  final bool showRightSidebar;

  const FacebookLayout({
    super.key,
    required this.child,
    this.showLeftSidebar = true,
    this.showRightSidebar = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // 响应式断点判断
    final bool isMobile = screenWidth < FacebookSizes.breakpointTablet;
    final bool isTablet = screenWidth >= FacebookSizes.breakpointTablet &&
                         screenWidth < FacebookSizes.breakpointDesktop;
    final bool isDesktop = screenWidth >= FacebookSizes.breakpointDesktop;

    return Scaffold(
      backgroundColor: FacebookColors.background,
      appBar: _buildAppBar(context),
      body: _buildBody(context, isMobile, isTablet, isDesktop),
      drawer: isMobile ? _buildMobileDrawer() : null,
      endDrawer: isMobile && showRightSidebar ? _buildMobileEndDrawer() : null,
    );
  }

  /// 构建Facebook风格的顶部导航栏
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: FacebookColors.primary,
      foregroundColor: FacebookColors.textOnPrimary,
      elevation: 0,
      toolbarHeight: FacebookSizes.navBarHeight,
      centerTitle: false,
      title: Row(
        children: [
          // Facebook logo
          Container(
            width: 32.w,
            height: 32.w,
            decoration: const BoxDecoration(
              color: FacebookColors.textOnPrimary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.facebook,
              color: FacebookColors.primary,
              size: FacebookSizes.iconMedium,
            ),
          ),
          SizedBox(width: FacebookSizes.spacing12),

          // 搜索框
          Expanded(
            child: Container(
              height: 36.h,
              constraints: BoxConstraints(maxWidth: 240.w),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '搜索日记内容...',
                  prefixIcon: Icon(
                    Icons.search,
                    size: FacebookSizes.iconSmall,
                    color: FacebookColors.iconGray,
                  ),
                  filled: true,
                  fillColor: FacebookColors.inputBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(FacebookSizes.radiusRound),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: FacebookSizes.spacing12,
                    vertical: FacebookSizes.spacing8,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        // 右侧图标按钮
        _buildIconButton(Icons.home, () {}),
        _buildIconButton(Icons.notifications, () {}),
        _buildIconButton(Icons.settings, () {}),
        SizedBox(width: FacebookSizes.spacing8),

        // 用户头像
        CircleAvatar(
          radius: FacebookSizes.avatarSmall / 2,
          backgroundColor: FacebookColors.textOnPrimary,
          child: Icon(
            Icons.person,
            color: FacebookColors.primary,
            size: FacebookSizes.iconMedium,
          ),
        ),
        SizedBox(width: FacebookSizes.spacing12),
      ],
    );
  }

  /// 构建图标按钮
  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 40.w,
      height: 40.w,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: FacebookColors.primaryHover,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: FacebookColors.textOnPrimary,
          size: FacebookSizes.iconMedium,
        ),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  /// 构建主体布局
  Widget _buildBody(BuildContext context, bool isMobile, bool isTablet, bool isDesktop) {
    if (isMobile) {
      // 移动端：仅显示主内容
      return _buildMainContent();
    } else if (isTablet) {
      // 平板端：显示主内容 + 可选侧边栏
      return Row(
        children: [
          if (showLeftSidebar)
            SizedBox(
              width: FacebookSizes.sidebarWidth,
              child: const FacebookLeftSidebar(),
            ),
          Expanded(child: _buildMainContent()),
        ],
      );
    } else {
      // 桌面端：完整三栏布局
      return Row(
        children: [
          // 左侧栏
          if (showLeftSidebar)
            SizedBox(
              width: FacebookSizes.sidebarWidth,
              child: const FacebookLeftSidebar(),
            ),

          // 主内容区
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: FacebookSizes.mainContentWidth,
              ),
              child: _buildMainContent(),
            ),
          ),

          // 右侧栏
          if (showRightSidebar)
            SizedBox(
              width: FacebookSizes.rightSidebarWidth,
              child: const FacebookRightSidebar(),
            ),
        ],
      );
    }
  }

  /// 构建主内容区
  Widget _buildMainContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(FacebookSizes.spacing16),
      child: child,
    );
  }

  /// 构建移动端抽屉（左侧导航）
  Widget _buildMobileDrawer() {
    return Drawer(
      backgroundColor: FacebookColors.surface,
      child: const FacebookLeftSidebar(),
    );
  }

  /// 构建移动端右侧抽屉
  Widget _buildMobileEndDrawer() {
    return Drawer(
      backgroundColor: FacebookColors.surface,
      child: const FacebookRightSidebar(),
    );
  }
}