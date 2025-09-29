import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/main.dart';

void main() {
  setUpAll(() {
    configureDependencies();
  });

  testWidgets('FacebookLayout 顶部导航与图标存在', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: InkboardApp()));

    await tester.pump(const Duration(milliseconds: 300));

    // 顶部导航栏
    expect(find.byType(AppBar), findsOneWidget);

    // Facebook 图标与常用图标按钮（使用outlined版本）
    expect(find.byKey(const Key('appbar_fb_icon')), findsOneWidget);
    expect(find.byKey(const Key('nav_icon_home')), findsOneWidget);
    expect(find.byKey(const Key('nav_icon_notifications')), findsOneWidget);
    expect(find.byKey(const Key('nav_icon_settings')), findsOneWidget);
  });
}
