import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'facebook_colors.dart';

/// Facebook文字样式系统
/// 遵循Facebook设计规范的字体大小、行高、字重
class FacebookTextStyles {
  FacebookTextStyles._();

  // 字体家族 - Facebook使用的字体栈
  static const String _fontFamily = 'SF Pro Display'; // iOS风格，fallback到系统字体

  /// 标题样式
  static TextStyle get headline1 => TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        height: 1.25,
        color: FacebookColors.textPrimary,
        fontFamily: _fontFamily,
      );

  static TextStyle get headline2 => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        height: 1.25,
        color: FacebookColors.textPrimary,
        fontFamily: _fontFamily,
      );

  static TextStyle get headline3 => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: FacebookColors.textPrimary,
        fontFamily: _fontFamily,
      );

  static TextStyle get headline4 => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: FacebookColors.textPrimary,
        fontFamily: _fontFamily,
      );

  static TextStyle get headline5 => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: FacebookColors.textPrimary,
        fontFamily: _fontFamily,
      );

  static TextStyle get headline6 => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        height: 1.375,
        color: FacebookColors.textPrimary,
        fontFamily: _fontFamily,
      );

  /// 正文样式
  static TextStyle get bodyLarge => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        height: 1.375,
        color: FacebookColors.textPrimary,
        fontFamily: _fontFamily,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        height: 1.43,
        color: FacebookColors.textPrimary,
        fontFamily: _fontFamily,
      );

  static TextStyle get bodySmall => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        height: 1.33,
        color: FacebookColors.textSecondary,
        fontFamily: _fontFamily,
      );

  /// 标签和辅助文字
  static TextStyle get caption => TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.normal,
        height: 1.45,
        color: FacebookColors.textSecondary,
        fontFamily: _fontFamily,
      );

  static TextStyle get overline => TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        height: 1.6,
        color: FacebookColors.textSecondary,
        fontFamily: _fontFamily,
        letterSpacing: 0.5,
      );

  /// 按钮文字
  static TextStyle get buttonLarge => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: FacebookColors.textOnPrimary,
        fontFamily: _fontFamily,
      );

  static TextStyle get buttonMedium => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        height: 1.29,
        color: FacebookColors.textOnPrimary,
        fontFamily: _fontFamily,
      );

  static TextStyle get buttonSmall => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: FacebookColors.textOnPrimary,
        fontFamily: _fontFamily,
      );

  /// 链接文字
  static TextStyle get link => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        height: 1.43,
        color: FacebookColors.primary,
        fontFamily: _fontFamily,
        decoration: TextDecoration.none,
      );

  static TextStyle get linkUnderline => link.copyWith(
        decoration: TextDecoration.underline,
      );

  /// 错误文字
  static TextStyle get error => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        height: 1.33,
        color: FacebookColors.error,
        fontFamily: _fontFamily,
      );

  /// 成功文字
  static TextStyle get success => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        height: 1.33,
        color: FacebookColors.success,
        fontFamily: _fontFamily,
      );

  /// 用户名样式（特殊加粗）
  static TextStyle get username => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        height: 1.43,
        color: FacebookColors.textPrimary,
        fontFamily: _fontFamily,
      );

  /// 时间戳样式
  static TextStyle get timestamp => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        height: 1.33,
        color: FacebookColors.textSecondary,
        fontFamily: _fontFamily,
      );

  /// 占位符文字
  static TextStyle get placeholder => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        height: 1.375,
        color: FacebookColors.textDisabled,
        fontFamily: _fontFamily,
      );

  /// 获取Material 3兼容的TextTheme
  static TextTheme getTextTheme() {
    return TextTheme(
      displayLarge: headline1,
      displayMedium: headline2,
      displaySmall: headline3,
      headlineLarge: headline3,
      headlineMedium: headline4,
      headlineSmall: headline5,
      titleLarge: headline6,
      titleMedium: bodyLarge,
      titleSmall: bodyMedium,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: buttonMedium,
      labelMedium: buttonSmall,
      labelSmall: caption,
    );
  }
}