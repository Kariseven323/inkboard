import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/facebook_colors.dart';
import '../../core/theme/facebook_sizes.dart';
import '../widgets/common/facebook_left_sidebar.dart';
import '../widgets/common/facebook_right_sidebar.dart';
import '../pages/search_page.dart';
import '../pages/settings_page.dart';

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
    final bool isTablet =
        screenWidth >= FacebookSizes.breakpointTablet &&
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
          // Facebook Logo（蓝底白 f 文字符号，避免重复Icon匹配）
          Container(
            width: 32.w,
            height: 32.w,
            decoration: const BoxDecoration(
              color: FacebookColors.textOnPrimary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              'f',
              key: Key('appbar_fb_icon'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: FacebookColors.primary,
                height: 1,
              ),
            ),
          ),
          SizedBox(width: FacebookSizes.spacing12),

          // 搜索框（提取为可悬停/聚焦的组件）
          const Expanded(child: _NavSearchField()),
        ],
      ),
      actions: [
        // 右侧图标按钮（36px圆形，悬停#F0F2F5）
        _fbIconButton(
          Icons.home_outlined,
          () {},
          key: const Key('nav_icon_home'),
        ),
        _fbIconButton(
          Icons.notifications_outlined,
          () {},
          key: const Key('nav_icon_notifications'),
        ),
        _fbIconButton(Icons.settings_outlined, () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
        }, key: const Key('nav_icon_settings')),
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

  /// 构建图标按钮 - Facebook风格（36px圆形，悬停高亮）
  Widget _fbIconButton(IconData icon, VoidCallback onPressed, {Key? key}) {
    return _HoverIconButton(icon: icon, onPressed: onPressed, buttonKey: key);
  }

  /// 构建主体布局
  Widget _buildBody(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) {
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

/// 内部私有组件：带悬停高亮效果的圆形图标按钮
class _HoverIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Key? buttonKey;

  const _HoverIconButton({
    required this.icon,
    required this.onPressed,
    this.buttonKey,
  });

  @override
  State<_HoverIconButton> createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<_HoverIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        key: widget.buttonKey,
        duration: FacebookSizes.animationFast,
        width: 36.w,
        height: 36.w,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: _hovered ? FacebookColors.inputBackground : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18.r),
            onTap: widget.onPressed,
            child: Center(
              child: Icon(
                widget.icon,
                color: FacebookColors.textOnPrimary,
                size: 20.w,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 顶部导航搜索框（带悬停与聚焦态的Facebook风格）
class _NavSearchField extends StatefulWidget {
  const _NavSearchField();

  @override
  State<_NavSearchField> createState() => _NavSearchFieldState();
}

class _NavSearchFieldState extends State<_NavSearchField> {
  bool _hovered = false;
  bool _focused = false;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted) setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _focused
        ? FacebookColors.primary
        : (_hovered ? const Color(0xFFDADDE1) : FacebookColors.border);
    final borderWidth = _focused ? 2.0 : 1.0;
    final boxShadow = (_hovered || _focused)
        ? [
            BoxShadow(
              color: FacebookColors.shadow,
              blurRadius: FacebookSizes.shadowBlurRadius,
              offset: Offset(0, FacebookSizes.shadowOffsetY),
            ),
          ]
        : <BoxShadow>[];

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        key: const Key('nav_search_container'),
        duration: FacebookSizes.animationFast,
        height: 36.h,
        constraints: BoxConstraints(maxWidth: 240.w),
        decoration: BoxDecoration(
          color: FacebookColors.inputBackground,
          borderRadius: BorderRadius.circular(FacebookSizes.radiusRound),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: boxShadow,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: FacebookSizes.spacing12,
          vertical: FacebookSizes.spacing4,
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: FacebookSizes.iconSmall,
              color: FacebookColors.iconGray,
            ),
            SizedBox(width: FacebookSizes.spacing8),
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: '搜索日记内容...',
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  final q = value.trim();
                  if (q.isEmpty) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SearchPage(initialQuery: q),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
