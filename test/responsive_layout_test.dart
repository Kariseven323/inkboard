import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/main.dart';
import 'package:inkboard/presentation/widgets/common/facebook_left_sidebar.dart';
import 'package:inkboard/presentation/widgets/common/facebook_right_sidebar.dart';

void main() {
  setUpAll(() {
    configureDependencies();
  });

  Future<void> pumpWithSize(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const ProviderScope(child: InkboardApp()));
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('移动端：可打开左右抽屉分别显示侧栏', (WidgetTester tester) async {
    await pumpWithSize(tester, const Size(390, 844)); // iPhone 12 Pro 尺寸

    final scaffoldState = tester.state(find.byType(Scaffold)) as ScaffoldState;

    // 打开左侧抽屉
    scaffoldState.openDrawer();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(Drawer), findsOneWidget);
    expect(find.byType(FacebookLeftSidebar), findsOneWidget);

    // 关闭左侧抽屉
    Navigator.of(tester.element(find.byType(Scaffold))).pop();
    await tester.pump(const Duration(milliseconds: 300));

    // 打开右侧抽屉
    scaffoldState.openEndDrawer();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(Drawer), findsOneWidget);
    expect(find.byType(FacebookRightSidebar), findsOneWidget);
  });

  // 由于断点使用了 ScreenUtil 缩放，当前布局在测试环境下会判定为移动端。
  // 这里仅验证移动端行为（存在左右抽屉）。
}
