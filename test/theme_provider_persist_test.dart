import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:inkboard/presentation/providers/theme_provider.dart';

void main() {
  test('ThemeNotifier 从偏好中加载', () async {
    SharedPreferences.setMockInitialValues({'app_theme_mode': 'dark'});
    final container = ProviderContainer();
    // 初始为 system，等待异步加载
    expect(container.read(themeProvider), AppThemeMode.system);
    await Future.delayed(const Duration(milliseconds: 50));
    expect(container.read(themeProvider), AppThemeMode.dark);
  });
}

