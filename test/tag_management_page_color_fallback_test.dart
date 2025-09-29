import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/core/theme/facebook_colors.dart';
import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/domain/usecases/tag_management_usecase.dart';
import 'package:inkboard/presentation/pages/tag_management_page.dart';

import 'fakes.dart';

void main() {
  testWidgets('TagManagementPage _ColorDot 无效颜色回退', (tester) async {
    await getIt.reset();
    final repo = InMemoryTagRepository();
    final now = DateTime.now();
    await repo.createTag(Tag(name: '无效色', color: 'XYZ', createdAt: now));
    getIt.registerSingleton<TagManagementUseCase>(TagManagementUseCase(repo));

    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: TagManagementPage()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    final tile = find.widgetWithText(ListTile, '无效色');
    expect(tile, findsOneWidget);
    // 找到对应的圆点
    final avatar = find.descendant(of: tile, matching: find.byType(CircleAvatar));
    expect(avatar, findsOneWidget);
    final w = tester.widget<CircleAvatar>(avatar);
    expect(w.backgroundColor, equals(FacebookColors.primary));
  });
}

