import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:inkboard/main.dart';
import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/presentation/providers/diary_provider.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';

void main() {
  setUpAll(() {
    // 在测试前配置依赖注入
    configureDependencies();
  });

  testWidgets('App启动测试', (WidgetTester tester) async {
    // 构建应用并触发一帧
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          diaryEntriesProvider.overrideWith((ref) => Stream<List<DiaryEntry>>.value(const [])),
        ],
        child: const InkboardApp(),
      ),
    );

    // 等待ScreenUtilInit初始化完成
    await tester.pump(const Duration(milliseconds: 400));

    // 验证Facebook风格首页内容
    expect(find.textContaining('今天你想记录什么'), findsOneWidget);

    // 验证占位内容
    expect(find.textContaining('还没有日记内容'), findsOneWidget);

    // 验证Facebook布局组件
    expect(find.byType(AppBar), findsOneWidget);
  });
}
