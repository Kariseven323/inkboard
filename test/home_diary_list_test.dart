import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/presentation/pages/home_page.dart';
import 'package:inkboard/presentation/providers/diary_provider.dart';

void main() {
  testWidgets('HomePage 渲染日记列表', (tester) async {
    // 构造一些假数据
    final now = DateTime.now();
    final entries = [
      DiaryEntry(
        id: 1,
        title: '第一篇',
        content: 'Hello **Markdown**',
        createdAt: now,
        updatedAt: now,
        isFavorite: true,
        tags: [Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now)],
      ),
      DiaryEntry(
        id: 2,
        title: '第二篇',
        content: '内容',
        createdAt: now,
        updatedAt: now,
      ),
    ];

    final providerOverride = diaryEntriesProvider.overrideWith((ref) {
      return Stream<List<DiaryEntry>>.value(entries);
    });

    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [providerOverride],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: HomePage()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('第一篇'), findsOneWidget);
    expect(find.text('第二篇'), findsOneWidget);
  });

  testWidgets('HomePage 空状态渲染', (tester) async {
    final emptyOverride = diaryEntriesProvider.overrideWith((ref) {
      return Stream<List<DiaryEntry>>.value(const []);
    });

    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [emptyOverride],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: HomePage()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('还没有日记内容'), findsOneWidget);
  });
}
