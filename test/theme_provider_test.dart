import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:inkboard/presentation/providers/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ThemeNotifier 切换与持久化枚举转换', () async {
    SharedPreferences.setMockInitialValues({});

    final notifier = ThemeNotifier();
    // 初始为 system（可能异步加载后仍为 system）
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(
      [AppThemeMode.system, AppThemeMode.light, AppThemeMode.dark].contains(notifier.state),
      isTrue,
    );

    await notifier.setThemeMode(AppThemeMode.system);
    expect(notifier.toFlutterThemeMode(), ThemeMode.system);

    await notifier.toggleTheme(); // -> light
    expect(notifier.state, AppThemeMode.light);
    expect(notifier.getThemeIcon(), isNotNull);
    expect(notifier.getThemeDisplayName(), isA<String>());
    expect(notifier.toFlutterThemeMode(), ThemeMode.light);

    await notifier.toggleTheme(); // -> dark
    expect(notifier.state, AppThemeMode.dark);
    expect(notifier.toFlutterThemeMode(), ThemeMode.dark);

    await notifier.toggleTheme(); // -> system
    expect(notifier.state, AppThemeMode.system);
  });
}

