import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/presentation/layouts/facebook_layout.dart';
import 'package:inkboard/presentation/widgets/common/facebook_left_sidebar.dart';
import 'package:inkboard/presentation/widgets/common/facebook_right_sidebar.dart';

void main() {
  Future<void> pumpWithSize(
    WidgetTester tester, {
    required Size size,
    required Widget child,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => MaterialApp(home: child),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
  }

  testWidgets('Tablet 断点：showLeftSidebar=false 隐藏左侧栏', (tester) async {
    await pumpWithSize(
      tester,
      size: const Size(800, 900), // 介于 768~1024 之间 -> Tablet
      child: const FacebookLayout(
        showLeftSidebar: false,
        child: Text('content'),
      ),
    );

    expect(find.byType(FacebookLeftSidebar), findsNothing);
  });

  testWidgets('Tablet 断点：showLeftSidebar=true 显示左侧栏', (tester) async {
    await pumpWithSize(
      tester,
      size: const Size(900, 900),
      child: const FacebookLayout(
        showLeftSidebar: true,
        child: Text('content'),
      ),
    );
    expect(find.byType(FacebookLeftSidebar), findsOneWidget);
  });

  testWidgets('Desktop 断点：showRightSidebar=false 隐藏右侧栏', (tester) async {
    await pumpWithSize(
      tester,
      size: const Size(1280, 900), // >=1024 -> Desktop
      child: const FacebookLayout(
        showRightSidebar: false,
        child: Text('content'),
      ),
    );

    expect(find.byType(FacebookRightSidebar), findsNothing);
  });
}
