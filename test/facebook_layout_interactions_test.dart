import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/theme/facebook_colors.dart';
import 'package:inkboard/main.dart';
import 'package:inkboard/presentation/widgets/common/facebook_left_sidebar.dart';
import 'package:inkboard/presentation/widgets/common/facebook_right_sidebar.dart';
import 'package:inkboard/core/di/service_locator.dart';

void main() {
  setUpAll(() {
    configureDependencies();
  });

  testWidgets('顶部图标悬停时背景变为输入背景色', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: InkboardApp(),
      ),
    );

    await tester.pumpAndSettle();

    final homeKey = const Key('nav_icon_home');
    expect(find.byKey(homeKey), findsOneWidget);

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    final center = tester.getCenter(find.byKey(homeKey));
    await gesture.moveTo(center);
    await tester.pumpAndSettle();

    final animated = tester.widget<AnimatedContainer>(find.byKey(homeKey));
    final decoration = animated.decoration as BoxDecoration;
    expect(decoration.color, equals(FacebookColors.inputBackground));
  });

  testWidgets('搜索框聚焦后边框为主色且具有阴影', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: InkboardApp(),
      ),
    );

    await tester.pumpAndSettle();

    final searchKey = const Key('nav_search_container');
    expect(find.byKey(searchKey), findsOneWidget);

    // 点击文本框以聚焦
    await tester.tap(find.byType(TextField).first);
    await tester.pumpAndSettle();

    final animated = tester.widget<AnimatedContainer>(find.byKey(searchKey));
    final decoration = animated.decoration as BoxDecoration;
    final border = decoration.border as Border?;
    expect(border, isNotNull);
    // 边框应为主色，宽度为2
    final side = border!.top; // 四侧相同
    expect(side.color, equals(FacebookColors.primary));
    expect(side.width, equals(2));
    // 有阴影
    expect(decoration.boxShadow, isNotNull);
    expect(decoration.boxShadow!.isNotEmpty, isTrue);
  });

  testWidgets('断点行为：移动端无侧栏，桌面端有左右侧栏', (WidgetTester tester) async {
    // 设置为移动端尺寸（使用 tester.view API）
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(375, 800);

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: InkboardApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FacebookLeftSidebar), findsNothing);
    expect(find.byType(FacebookRightSidebar), findsNothing);

    // 切换为桌面端尺寸
    tester.view.devicePixelRatio = 2.0; // 桌面端常见DPR
    tester.view.physicalSize = const Size(2560, 1600); // 逻辑尺寸=1280x800
    await tester.pumpWidget(
      const ProviderScope(
        child: InkboardApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FacebookLeftSidebar), findsWidgets);
    expect(find.byType(FacebookRightSidebar), findsWidgets);
  });
}
