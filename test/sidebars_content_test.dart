import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/main.dart';

void main() {
  setUpAll(() {
    configureDependencies();
  });

  Future<void> _pumpMobile(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
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
  }

  testWidgets('左侧栏：导航菜单与底部信息（移动端抽屉打开后可见）', (WidgetTester tester) async {
    await _pumpMobile(tester);

    // 打开左侧抽屉
    final scaffoldState = tester.state(find.byType(Scaffold)) as ScaffoldState;
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('主页'), findsOneWidget);
    expect(find.text('我的日记'), findsOneWidget);
    expect(find.text('标签管理'), findsOneWidget);
    expect(find.text('收藏夹'), findsOneWidget);
    expect(find.text('统计分析'), findsOneWidget);
    expect(find.text('高级搜索'), findsOneWidget);

    // 底部信息包含版本号与版权
    expect(find.text('砚记 v1.0.0'), findsOneWidget);
    expect(find.text('© 2025 ultrathink'), findsOneWidget);
  });

  testWidgets('右侧栏：常用标签/写作统计/写作提示/历史上的今天（移动端右侧抽屉）', (WidgetTester tester) async {
    await _pumpMobile(tester);

    // 打开右侧抽屉
    final scaffoldState = tester.state(find.byType(Scaffold)) as ScaffoldState;
    scaffoldState.openEndDrawer();
    await tester.pumpAndSettle();

    // 常用标签
    for (final tag in ['工作', '生活', '学习', '旅行', '美食', '读书']) {
      expect(find.text(tag), findsOneWidget);
    }

    // 写作统计标签存在
    expect(find.text('本月日记'), findsOneWidget);
    expect(find.text('总字数'), findsOneWidget);
    expect(find.text('连续天数'), findsOneWidget);

    // 写作提示存在若干条
    expect(find.textContaining('今天有什么让你'), findsOneWidget);
    expect(find.textContaining('心情变化'), findsOneWidget);
    expect(find.textContaining('新知识'), findsOneWidget);

    // 历史上的今天模块
    expect(find.text('历史上的今天'), findsOneWidget);
    expect(find.text('查看详情'), findsOneWidget);
  });
}
