import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:inkboard/presentation/providers/theme_provider.dart';

void main() {
  test('ThemeNotifier set/toggle/名称与图标与模式', () async {
    final container = ProviderContainer();
    final notifier = container.read(themeProvider.notifier);
    // 等待构造时的 _loadTheme 完成，避免竞态覆盖
    await Future<void>.delayed(const Duration(milliseconds: 50));

    await notifier.setThemeMode(AppThemeMode.light);
    await Future<void>.delayed(const Duration(milliseconds: 1));
    expect(container.read(themeProvider), AppThemeMode.light);
    expect(notifier.getThemeDisplayName(), '浅色模式');
    expect(notifier.getThemeIcon(), Icons.brightness_7);
    expect(notifier.toFlutterThemeMode(), ThemeMode.light);

    await notifier.toggleTheme(); // -> dark
    await Future<void>.delayed(const Duration(milliseconds: 1));
    expect(container.read(themeProvider), AppThemeMode.dark);
    expect(notifier.getThemeDisplayName(), '深色模式');
    expect(notifier.getThemeIcon(), Icons.brightness_2);
    expect(notifier.toFlutterThemeMode(), ThemeMode.dark);

    await notifier.toggleTheme(); // -> system
    await Future<void>.delayed(const Duration(milliseconds: 1));
    expect(container.read(themeProvider), AppThemeMode.system);
    expect(notifier.getThemeDisplayName(), '跟随系统');
    expect(notifier.getThemeIcon(), Icons.brightness_auto);
    expect(notifier.toFlutterThemeMode(), ThemeMode.system);
  });
}
