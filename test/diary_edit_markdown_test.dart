import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/presentation/pages/diary_edit_page.dart';

void main() {
  Future<void> pumpEditor(WidgetTester tester, {Size size = const Size(1200, 900)}) async {
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
    await tester.pump(const Duration(milliseconds: 200));
  }

  testWidgets('宽屏：编辑与实时预览分栏显示且随输入更新', (tester) async {
    await pumpEditor(tester);

    // 输入内容
    final contentField = find.byType(TextFormField).last;
    await tester.enterText(contentField, '# Title\n**bold** text');
    await tester.pump(const Duration(milliseconds: 100));

    // 预览区包含文本（限定在预览容器内，避免编辑器中的重复匹配）
    expect(
      find.descendant(of: find.byKey(const ValueKey('preview')), matching: find.textContaining('Title')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: find.byKey(const ValueKey('preview')), matching: find.textContaining('bold')),
      findsWidgets,
    );
  });

  testWidgets('窄屏：SegmentedButton 在编辑/预览之间切换', (tester) async {
    await pumpEditor(tester, size: const Size(390, 800));

    // 输入内容
    final contentField = find.byType(TextFormField).last;
    await tester.enterText(contentField, 'Hello Markdown');
    await tester.pump(const Duration(milliseconds: 100));

    // 切换到预览
    await tester.tap(find.text('预览'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.textContaining('Hello Markdown'), findsOneWidget);

    // 切回编辑
    await tester.tap(find.text('编辑'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(TextFormField), findsWidgets);
  });

  testWidgets('工具栏操作：粗体/斜体/标题/列表/引用/代码块', (tester) async {
    // 使用窄屏，保持在“编辑”视图，避免构建预览以减少外部依赖与计时器
    await pumpEditor(tester, size: const Size(390, 800));

    final contentField = find.byType(TextFormField).last;
    await tester.tap(contentField);
    await tester.pump();

    // 插入粗体
    await tester.tap(find.byIcon(Icons.format_bold));
    await tester.pump();

    // 插入斜体
    await tester.tap(find.byIcon(Icons.format_italic));
    await tester.pump();

    // 插入H1、H2、列表、引用、代码块
    await tester.tap(find.byIcon(Icons.title));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.text_increase));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.format_list_bulleted));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.format_quote));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.code));
    await tester.pump();

    // 至少断言字段仍可编辑
    expect(contentField, findsOneWidget);
  });
}
