import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkboard/core/theme/facebook_colors.dart';

void main() {
  test('ColorScheme 工厂方法覆盖', () {
    final light = FacebookColors.getColorScheme(isDark: false);
    final dark = FacebookColors.getColorScheme(isDark: true);
    expect(light.brightness, Brightness.light);
    expect(dark.brightness, Brightness.dark);

    final m3Light = FacebookColors.getMaterial3ColorScheme(isDark: false);
    final m3Dark = FacebookColors.getMaterial3ColorScheme(isDark: true);
    expect(m3Light.brightness, Brightness.light);
    expect(m3Dark.brightness, Brightness.dark);

    // 细化断言：验证关键字段映射
    expect(light.primary, FacebookColors.primary);
    expect(light.onPrimary, FacebookColors.textOnPrimary);
    expect(light.surface, FacebookColors.surface);
    expect(light.outline, FacebookColors.border);
    expect(light.error, FacebookColors.error);

    expect(dark.primary, FacebookColors.primary);
    expect(dark.onPrimary, FacebookColors.textOnPrimary);
    expect(dark.onSurface, const Color(0xFFE4E6EA));
    expect(dark.outline, const Color(0xFF3E4042));
    expect(dark.error, FacebookColors.error);

    // surfaceContainer 映射
    expect(light.surfaceContainer, FacebookColors.background);
    expect(dark.surfaceContainer, const Color(0xFF3A3B3C));
  });
}
