import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/main.dart';

void main() {
  setUpAll(() {
    configureDependencies();
  });

  testWidgets('FacebookLayout 顶部仅保留搜索框，无多余图标', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: InkboardApp()));

    await tester.pump(const Duration(milliseconds: 300));

    // 顶部导航栏
    expect(find.byType(AppBar), findsOneWidget);

    // 仅保留搜索框容器
    expect(find.byKey(const Key('nav_search_container')), findsOneWidget);
    // 不应存在Facebook f图标与其他导航图标
    expect(find.byKey(const Key('appbar_fb_icon')), findsNothing);
    expect(find.byKey(const Key('nav_icon_home')), findsNothing);
    expect(find.byKey(const Key('nav_icon_notifications')), findsNothing);
    expect(find.byKey(const Key('nav_icon_settings')), findsNothing);
  });
}
