import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/presentation/pages/home_page.dart';
import 'package:inkboard/presentation/providers/diary_provider.dart';

void main() {
  testWidgets('HomePage 底部操作栏 编辑按钮跳转', (tester) async {
    final now = DateTime.now();
    final entry = DiaryEntry(
      id: 12,
      title: '底栏编辑',
      content: 'c',
      createdAt: now,
      updatedAt: now,
    );
    final override = diaryEntriesProvider.overrideWith(
      (ref) => Stream.value([entry]),
    );

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
          builder: (context, _) =>
              const MaterialApp(home: Scaffold(body: HomePage())),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 150));

    await tester.tap(find.text('编辑'));
    await tester.pumpAndSettle();
    expect(find.text('编辑日记'), findsWidgets);
  });
}
