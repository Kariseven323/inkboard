import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/domain/usecases/tag_management_usecase.dart';
import 'package:inkboard/presentation/pages/tag_management_page.dart';

import 'fakes.dart';

void main() {
  testWidgets('TagManagementPage 新建/编辑/删除 取消流程', (tester) async {
    await getIt.reset();
    final repo = InMemoryTagRepository();
    final now = DateTime.now();
    await repo.createTag(Tag(name: '自创', color: '#333333', createdAt: now));
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

    // 新建取消
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();

    // 编辑取消
    await tester.tap(find.text('自创'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();

    // 删除取消
    final delIcon = find.widgetWithIcon(IconButton, Icons.delete_outline).first;
    await tester.tap(delIcon);
    await tester.pumpAndSettle();
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
  });
}
