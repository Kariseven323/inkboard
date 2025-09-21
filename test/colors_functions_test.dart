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
  });
}
