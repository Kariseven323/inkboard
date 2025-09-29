import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 应用主题模式枚举
enum AppThemeMode { system, light, dark }

/// 主题状态管理
class ThemeNotifier extends StateNotifier<AppThemeMode> {
  static const String _themeKey = 'app_theme_mode';

  ThemeNotifier() : super(AppThemeMode.system) {
    _loadTheme();
  }

  /// 加载保存的主题设置
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);

      switch (savedTheme) {
        case 'light':
          state = AppThemeMode.light;
          break;
        case 'dark':
          state = AppThemeMode.dark;
          break;
        case 'system':
        default:
          state = AppThemeMode.system;
          break;
      }
    } catch (e) {
      // 如果读取失败，使用默认的系统主题
      state = AppThemeMode.system;
    }
  }

  /// 保存主题设置
  Future<void> _saveTheme(AppThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String themeString;

      switch (mode) {
        case AppThemeMode.light:
          themeString = 'light';
          break;
        case AppThemeMode.dark:
          themeString = 'dark';
          break;
        case AppThemeMode.system:
          themeString = 'system';
          break;
      }

      await prefs.setString(_themeKey, themeString);
    } catch (e) {
      // 忽略保存错误
    }
  }

  /// 设置主题模式
  Future<void> setThemeMode(AppThemeMode mode) async {
    state = mode;
    await _saveTheme(mode);
  }

  /// 切换到下一个主题
  Future<void> toggleTheme() async {
    switch (state) {
      case AppThemeMode.system:
        await setThemeMode(AppThemeMode.light);
        break;
      case AppThemeMode.light:
        await setThemeMode(AppThemeMode.dark);
        break;
      case AppThemeMode.dark:
        await setThemeMode(AppThemeMode.system);
        break;
    }
  }

  /// 获取主题显示名称
  String getThemeDisplayName() {
    switch (state) {
      case AppThemeMode.system:
        return '跟随系统';
      case AppThemeMode.light:
        return '浅色模式';
      case AppThemeMode.dark:
        return '深色模式';
    }
  }

  /// 获取主题图标
  IconData getThemeIcon() {
    switch (state) {
      case AppThemeMode.system:
        return Icons.brightness_auto;
      case AppThemeMode.light:
        return Icons.brightness_7;
      case AppThemeMode.dark:
        return Icons.brightness_2;
    }
  }

  /// 转换为Flutter的ThemeMode
  ThemeMode toFlutterThemeMode() {
    switch (state) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }
}

/// 主题状态Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>(
  (ref) => ThemeNotifier(),
);

/// 当前是否为暗色主题的provider
final isDarkThemeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeProvider);
  // 使用MediaQuery获取系统亮度，但这需要BuildContext
  // 在实际使用时，应该在Widget中通过MediaQuery.platformBrightnessOf(context)获取
  // 这里暂时使用View.of获取
  final platformBrightness = PlatformDispatcher.instance.platformBrightness;

  switch (themeMode) {
    case AppThemeMode.system:
      return platformBrightness == Brightness.dark;
    case AppThemeMode.light:
      return false;
    case AppThemeMode.dark:
      return true;
  }
});
