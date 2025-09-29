import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/presentation/pages/home_page.dart';
import 'package:inkboard/presentation/providers/diary_provider.dart';

void main() {
  testWidgets('HomePage 删除对话框取消', (tester) async {
    final now = DateTime.now();
    final entry = DiaryEntry(id: 11, title: '取消删除项', content: 'c', createdAt: now, updatedAt: now);
    final override = diaryEntriesProvider.overrideWith((ref) => Stream.value([entry]));

    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(() { tester.view.resetPhysicalSize(); tester.view.resetDevicePixelRatio(); });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [override],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: Scaffold(body: HomePage())),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 150));

    await tester.longPress(find.text('取消删除项'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除日记'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('取消'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('取消删除项'), findsWidgets);
  });
}
