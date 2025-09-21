import 'package:flutter/material.dart';

/// Facebook官方色彩系统
/// 参考: https://www.facebook.com/brand/resources/
class FacebookColors {
  FacebookColors._();

  // Facebook主要颜色
  static const Color primary = Color(0xFF1877F2);           // Facebook主蓝色
  static const Color primaryHover = Color(0xFF166FE5);      // 悬停蓝色
  static const Color primaryPressed = Color(0xFF1464CC);    // 按下蓝色

  // 背景颜色
  static const Color background = Color(0xFFF0F2F5);        // 主背景灰色
  static const Color surface = Color(0xFFFFFFFF);           // 卡片白色
  static const Color surfaceHover = Color(0xFFF7F8FA);      // 悬停表面色

  // 边框和分割线
  static const Color border = Color(0xFFE4E6EA);            // 边框颜色
  static const Color divider = Color(0xFFDDDFE2);           // 分割线颜色

  // 文字颜色
  static const Color textPrimary = Color(0xFF050505);       // 主要文字
  static const Color textSecondary = Color(0xFF65676B);     // 次要文字
  static const Color textDisabled = Color(0xFFBCC0C4);      // 禁用文字
  static const Color textOnPrimary = Color(0xFFFFFFFF);     // 主色上的文字

  // 状态颜色
  static const Color success = Color(0xFF42B883);           // 成功绿色
  static const Color error = Color(0xFFE41E3F);             // 错误红色
  static const Color warning = Color(0xFFFFB800);           // 警告黄色
  static const Color info = Color(0xFF1877F2);              // 信息蓝色

  // 阴影颜色
  static const Color shadow = Color(0x1A000000);            // 卡片阴影 rgba(0,0,0,0.1)
  static const Color shadowLight = Color(0x0D000000);       // 轻阴影 rgba(0,0,0,0.05)
  static const Color shadowDark = Color(0x33000000);        // 深阴影 rgba(0,0,0,0.2)

  // 特殊组件颜色
  static const Color inputBackground = Color(0xFFF0F2F5);   // 输入框背景
  static const Color inputBorder = Color(0xFFE4E6EA);       // 输入框边框
  static const Color iconGray = Color(0xFF8A8D91);          // 图标灰色

  // 在线状态
  static const Color online = Color(0xFF44D362);            // 在线绿点
  static const Color away = Color(0xFFFFB800);              // 离开黄点
  static const Color offline = Color(0xFFBCC0C4);           // 离线灰点

  /// 根据明暗主题返回相应的颜色方案
  static ColorScheme getColorScheme({bool isDark = false}) {
    if (isDark) {
      return const ColorScheme.dark(
        primary: primary,
        secondary: success,
        surface: Color(0xFF242526),
        surfaceContainer: Color(0xFF3A3B3C),
        onSurface: Color(0xFFE4E6EA),
        onPrimary: textOnPrimary,
        error: error,
        outline: Color(0xFF3E4042),
      );
    } else {
      return const ColorScheme.light(
        primary: primary,
        secondary: success,
        surface: surface,
        surfaceContainer: background,
        onSurface: textPrimary,
        onPrimary: textOnPrimary,
        error: error,
        outline: border,
      );
    }
  }

  /// 获取Material 3颜色种子
  static ColorScheme getMaterial3ColorScheme({bool isDark = false}) {
    return ColorScheme.fromSeed(
      seedColor: primary,
      brightness: isDark ? Brightness.dark : Brightness.light,
    );
  }
}