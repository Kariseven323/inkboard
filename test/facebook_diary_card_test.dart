import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/presentation/widgets/common/facebook_diary_card.dart';

void main() {
  testWidgets('FacebookDiaryCard 操作菜单与回调触发', (tester) async {
    int fav = 0, edit = 0, del = 0, share = 0;
    final now = DateTime.now();

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => MaterialApp(
          home: Scaffold(
            body: SizedBox(width: 400, child: FacebookDiaryCard(
              title: '标题',
              content: '内容',
              createdAt: now.subtract(const Duration(hours: 2)),
              tags: const ['工作', '学习'],
              isFavorite: false,
              onFavoriteTap: () => fav++,
              onEditTap: () => edit++,
              onDeleteTap: () => del++,
              onShareTap: () => share++,
            )),
          ),
        ),
      ),
    );

    // 主按钮行
    await tester.tap(find.text('收藏'));
    await tester.tap(find.text('编辑'));
    await tester.tap(find.text('分享'));
    await tester.pump();
    expect(fav, 1);
    expect(edit, 1);
    expect(share, 1);

    // 更多菜单 -> 删除
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除日记'));
    await tester.pump();
    expect(del, 1);
  });

  testWidgets('FacebookDiaryCard 日期格式多分支', (tester) async {
    final dates = [
      DateTime.now(),
      DateTime.now().subtract(const Duration(minutes: 10)),
      DateTime.now().subtract(const Duration(hours: 5)),
      DateTime.now().subtract(const Duration(days: 1)),
      DateTime.now().subtract(const Duration(days: 3)),
      DateTime(2023, 1, 1),
    ];
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                for (final d in dates)
                  FacebookDiaryCard(title: 'T', content: 'C', createdAt: d),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(FacebookDiaryCard), findsWidgets);
  });
}
