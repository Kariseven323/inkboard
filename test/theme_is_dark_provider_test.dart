import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:inkboard/presentation/providers/theme_provider.dart';

void main() {
  test('isDarkThemeProvider 在不同状态下返回布尔', () async {
    final container = ProviderContainer();
    // system: 取决于平台亮度，但应返回布尔
    expect(container.read(isDarkThemeProvider), isA<bool>());
    // 切换到 light/dark
    await container
        .read(themeProvider.notifier)
        .setThemeMode(AppThemeMode.light);
    await Future<void>.delayed(const Duration(milliseconds: 1));
    expect(container.read(isDarkThemeProvider), isFalse);
    await container
        .read(themeProvider.notifier)
        .setThemeMode(AppThemeMode.dark);
    await Future<void>.delayed(const Duration(milliseconds: 1));
    expect(container.read(isDarkThemeProvider), isTrue);
  });
}
