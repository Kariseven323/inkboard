import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:inkboard/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('应用可以启动并显示关键信息', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: InkboardApp(),
      ),
    );

    await tester.pumpAndSettle();

    // 首页关键文案
    expect(find.text('欢迎使用 砚记 (Inkboard)'), findsOneWidget);
    expect(find.text('版本: 1.0.0'), findsOneWidget);

    // 顶部导航（Facebook风格）存在
    expect(find.byType(AppBar), findsOneWidget);
  });
}

