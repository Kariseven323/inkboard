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
  testWidgets('TagManagementPage 搜索过滤结果', (tester) async {
    await getIt.reset();
    final repo = InMemoryTagRepository();
    final now = DateTime.now();
    await repo.createTag(Tag(name: '工作', color: '#1877F2', createdAt: now));
    await repo.createTag(Tag(name: '学习', color: '#FF9800', createdAt: now));
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
    expect(find.text('工作'), findsOneWidget);
    expect(find.text('学习'), findsOneWidget);

    // 输入过滤
    await tester.enterText(find.byType(TextField).first, '工');
    await tester.pumpAndSettle();

    expect(find.text('工作'), findsOneWidget);
    expect(find.text('学习'), findsNothing);
  });
}
