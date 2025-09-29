import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/presentation/pages/favorites_page.dart';
import 'package:inkboard/presentation/providers/diary_provider.dart';

void main() {
  testWidgets('FavoritesPage 点击 编辑/分享 按钮可用', (tester) async {
    final now = DateTime.now();
    final entries = [
      DiaryEntry(
        id: 1,
        title: '收藏X',
        content: '内容X',
        createdAt: now,
        updatedAt: now,
        isFavorite: true,
        tags: [Tag(id: 1, name: 't', color: '#1877F2', createdAt: now)],
      ),
    ];
    final override = favoriteDiaryEntriesProvider.overrideWith(
      (ref) => Stream.value(entries),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [override],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: FavoritesPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 点击 编辑/分享 文本（触发 InkWell.onTap）
    await tester.tap(find.text('编辑').first);
    await tester.pump(const Duration(milliseconds: 150));
    await tester.tap(find.text('分享').first);
    await tester.pump(const Duration(milliseconds: 150));

    // 验证仍然在收藏页
    expect(find.text('收藏夹'), findsOneWidget);
    expect(find.text('收藏X'), findsOneWidget);
  });
}
