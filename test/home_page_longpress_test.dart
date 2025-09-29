import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/presentation/pages/home_page.dart';
import 'package:inkboard/presentation/providers/diary_provider.dart';

void main() {
  testWidgets('HomePage 长按卡片弹出底部操作单', (tester) async {
    final now = DateTime.now();
    final entry = DiaryEntry(
      id: 1,
      title: '长按操作测试',
      content: '内容',
      createdAt: now,
      updatedAt: now,
      tags: [Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now)],
    );
    final override = diaryEntriesProvider.overrideWith((ref) => Stream.value([entry]));

    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [override],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: Scaffold(body: HomePage())),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    // 长按卡片区域（使用标题文本命中）
    await tester.longPress(find.text('长按操作测试'));
    await tester.pumpAndSettle();

    expect(find.text('编辑日记'), findsOneWidget);
    expect(find.text('删除日记'), findsOneWidget);
  });

  testWidgets('HomePage 长按后选择“编辑日记”导航至编辑页', (tester) async {
    final now = DateTime.now();
    final entry = DiaryEntry(
      id: 2,
      title: '跳转编辑页',
      content: '内容',
      createdAt: now,
      updatedAt: now,
      tags: const [],
    );
    final override = diaryEntriesProvider.overrideWith((ref) => Stream.value([entry]));

    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [override],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: Scaffold(body: HomePage())),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    await tester.longPress(find.text('跳转编辑页'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('编辑日记'));
    await tester.pumpAndSettle();

    // 编辑页 AppBar 标题
    expect(find.text('编辑日记'), findsWidgets);
  });
}
