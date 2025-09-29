import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:inkboard/presentation/providers/settings_provider.dart';

void main() {
  test('TextScaleNotifier 加载与设置', () async {
    SharedPreferences.setMockInitialValues({'text_scale_factor': 1.2});
    final container = ProviderContainer();
    // 初始为默认1.0，等待异步加载
    expect(container.read(textScaleProvider), 1.0);
    await Future.delayed(const Duration(milliseconds: 50));
    expect(container.read(textScaleProvider), closeTo(1.2, 0.0001));

    await container.read(textScaleProvider.notifier).set(1.5);
    expect(container.read(textScaleProvider), closeTo(1.5, 0.0001));
  });
}

