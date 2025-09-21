import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:inkboard/main.dart';
import 'package:inkboard/core/di/service_locator.dart';

void main() {
  setUpAll(() {
    // 在测试前配置依赖注入
    configureDependencies();
  });

  testWidgets('App启动测试', (WidgetTester tester) async {
    // 构建应用并触发一帧
    await tester.pumpWidget(
      const ProviderScope(
        child: InkboardApp(),
      ),
    );

    // 等待ScreenUtilInit初始化完成
    await tester.pumpAndSettle();

    // 验证应用名称显示
    expect(find.text('欢迎使用 砚记 (Inkboard)'), findsOneWidget);

    // 验证版本信息显示
    expect(find.text('版本: 1.0.0'), findsOneWidget);

    // 验证Sprint 1任务完成情况显示
    expect(find.textContaining('Sprint 1 任务完成情况'), findsOneWidget);
  });
}