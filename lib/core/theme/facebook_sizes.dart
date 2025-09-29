import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Facebook设计系统中的尺寸规范
/// 基于4px的网格系统
class FacebookSizes {
  FacebookSizes._();

  // 基础单位 - Facebook使用4px作为基础设计单位
  static double get unit => 4.w;

  /// 间距系统 (基于4px倍数)
  static double get spacing2 => 2.w; // 2px
  static double get spacing4 => 4.w; // 4px
  static double get spacing8 => 8.w; // 8px
  static double get spacing12 => 12.w; // 12px
  static double get spacing16 => 16.w; // 16px - 标准间距
  static double get spacing20 => 20.w; // 20px
  static double get spacing24 => 24.w; // 24px
  static double get spacing32 => 32.w; // 32px
  static double get spacing40 => 40.w; // 40px
  static double get spacing48 => 48.w; // 48px
  static double get spacing64 => 64.w; // 64px

  /// 圆角系统
  static double get radiusSmall => 4.r; // 小圆角
  static double get radiusMedium => 6.r; // 中圆角 - 按钮标准
  static double get radiusLarge => 8.r; // 大圆角 - 卡片标准
  static double get radiusXLarge => 12.r; // 超大圆角
  static double get radiusRound => 20.r; // 搜索框等圆形元素

  /// 头像尺寸
  static double get avatarSmall => 32.w; // 小头像
  static double get avatarMedium => 40.w; // 中等头像
  static double get avatarLarge => 56.w; // 大头像
  static double get avatarXLarge => 80.w; // 超大头像

  /// 图标尺寸
  static double get iconSmall => 16.w; // 小图标
  static double get iconMedium => 20.w; // 中等图标
  static double get iconLarge => 24.w; // 大图标
  static double get iconXLarge => 32.w; // 超大图标

  /// 按钮尺寸
  static double get buttonHeightSmall => 32.h; // 小按钮高度
  static double get buttonHeightMedium => 36.h; // 中等按钮高度
  static double get buttonHeightLarge => 40.h; // 大按钮高度

  /// 输入框尺寸
  static double get inputHeight => 40.h; // 输入框标准高度
  static double get inputBorderWidth => 1.w; // 输入框边框宽度

  /// 卡片和容器
  static double get cardElevation => 1.0; // 卡片阴影高度
  static double get cardPadding => spacing16; // 卡片内边距
  static double get containerPadding => spacing16; // 容器内边距

  /// 顶部导航栏
  static double get navBarHeight => 44.h; // 导航栏高度（Facebook标准）
  static double get navBarPadding => spacing12; // 导航栏内边距

  /// 列表项
  static double get listItemHeight => 56.h; // 列表项标准高度
  static double get listItemPadding => spacing16; // 列表项内边距

  /// 分割线
  static double get dividerThickness => 1.w; // 分割线厚度
  static double get borderWidth => 1.w; // 边框标准宽度

  /// 底部导航
  static double get bottomNavHeight => 60.h; // 底部导航高度
  static double get bottomNavIconSize => iconLarge; // 底部导航图标大小

  /// 悬浮按钮
  static double get fabSize => 56.w; // 悬浮按钮标准尺寸
  static double get fabMiniSize => 40.w; // 小悬浮按钮尺寸

  /// 页面布局
  static double get pageHorizontalPadding => spacing16; // 页面水平内边距
  static double get pageVerticalPadding => spacing16; // 页面垂直内边距

  /// 最大宽度（响应式设计：遵循Facebook桌面端固定像素）
  static double get maxContentWidth => 1200.0; // 内容最大宽度
  static double get sidebarWidth => 240.0; // 左侧栏宽度
  static double get mainContentWidth => 590.0; // 主内容区宽度
  static double get rightSidebarWidth => 280.0; // 右侧栏宽度

  /// 断点（响应式，使用逻辑像素，不参与缩放）
  static double get breakpointMobile => 480.0; // 移动端断点
  static double get breakpointTablet => 768.0; // 平板断点
  static double get breakpointDesktop => 1024.0; // 桌面端断点
  static double get breakpointLarge => 1440.0; // 大屏断点

  /// 阴影偏移
  static double get shadowOffsetY => 1.h; // 阴影Y偏移
  static double get shadowBlurRadius => 2.r; // 阴影模糊半径

  /// 动画时长常量
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 400);

  /// 通用边距快捷方式
  static EdgeInsets get paddingAll => EdgeInsets.all(spacing16);
  static EdgeInsets get paddingHorizontal =>
      EdgeInsets.symmetric(horizontal: spacing16);
  static EdgeInsets get paddingVertical =>
      EdgeInsets.symmetric(vertical: spacing16);
  static EdgeInsets get paddingSmall => EdgeInsets.all(spacing8);
  static EdgeInsets get paddingLarge => EdgeInsets.all(spacing24);

  /// 边距
  static EdgeInsets get marginAll => EdgeInsets.all(spacing16);
  static EdgeInsets get marginHorizontal =>
      EdgeInsets.symmetric(horizontal: spacing16);
  static EdgeInsets get marginVertical =>
      EdgeInsets.symmetric(vertical: spacing16);
  static EdgeInsets get marginSmall => EdgeInsets.all(spacing8);
  static EdgeInsets get marginLarge => EdgeInsets.all(spacing24);
}
