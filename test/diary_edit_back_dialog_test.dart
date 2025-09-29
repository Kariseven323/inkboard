import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/presentation/pages/diary_edit_page.dart';

void main() {
  Future<void> pumpEditor(WidgetTester tester, {Size size = const Size(390, 800)}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: size,
          builder: (context, child) => const MaterialApp(home: DiaryEditPage()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 150));
  }

  testWidgets('DiaryEditPage 返回按钮弹窗：继续编辑与放弃', (tester) async {
    await pumpEditor(tester);

    // 输入标题以触发弹窗
    final titleField = find.byType(TextFormField).first;
    await tester.enterText(titleField, '临时标题');
    await tester.pump(const Duration(milliseconds: 50));

    // 点击关闭 -> 弹出确认
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('放弃编辑？'), findsOneWidget);

    // 继续编辑
    await tester.tap(find.text('继续编辑'));
    await tester.pumpAndSettle();
    expect(find.byType(DiaryEditPage), findsOneWidget);

    // 再次关闭 -> 放弃
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    await tester.tap(find.text('放弃'));
    await tester.pumpAndSettle();
    expect(find.byType(DiaryEditPage), findsNothing);
  });
}

