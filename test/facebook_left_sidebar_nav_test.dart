import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/presentation/widgets/common/facebook_left_sidebar.dart';

void main() {
  testWidgets('FacebookLeftSidebar 导航至 标签管理/收藏夹/高级搜索/导出', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ScreenUtilInit(
          designSize: Size(390, 844),
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(width: 240, child: FacebookLeftSidebar()),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // 标签管理
    await tester.tap(find.text('标签管理'));
    await tester.pumpAndSettle();
    expect(find.text('标签管理'), findsWidgets);

    // 返回
    await tester.pageBack();
    await tester.pumpAndSettle();

    // 收藏夹
    await tester.tap(find.text('收藏夹'));
    await tester.pumpAndSettle();
    expect(find.text('收藏夹'), findsWidgets);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // 高级搜索
    await tester.tap(find.text('高级搜索'));
    await tester.pumpAndSettle();
    expect(find.text('输入关键词开始搜索'), findsWidgets);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // 导出数据
    await tester.tap(find.text('导出数据'));
    await tester.pumpAndSettle();
    expect(find.text('导出数据 (Markdown)'), findsWidgets);
  });
}
