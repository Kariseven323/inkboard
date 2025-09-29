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
  Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    int maxTicks = 60,
    Duration step = const Duration(milliseconds: 50),
  }) async {
    for (var i = 0; i < maxTicks; i++) {
      if (finder.evaluate().isNotEmpty) return;
      await tester.pump(step);
    }
  }

  setUp(() async {
    await getIt.reset();
    final repo = InMemoryTagRepository();
    // 预填充两个标签
    final now = DateTime.now();
    await repo.createTag(Tag(name: '工作', color: '#1877F2', createdAt: now));
    await repo.createTag(Tag(name: '生活', color: '#FF9800', createdAt: now));
    getIt.registerSingleton<TagManagementUseCase>(TagManagementUseCase(repo));
  });

  testWidgets('TagManagementPage 列表渲染/新建/编辑/删除', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: TagManagementPage()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('标签管理'), findsOneWidget);
    expect(find.text('工作'), findsOneWidget);
    expect(find.text('生活'), findsOneWidget);

    // 点击“新建标签”
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // 仅在对话框内输入，避免命中页面搜索框
    final createDialog = find.byType(AlertDialog);
    await tester.enterText(
      find.descendant(of: createDialog, matching: find.byType(TextField)).at(0),
      '学习',
    );
    await tester.enterText(
      find.descendant(of: createDialog, matching: find.byType(TextField)).at(1),
      '#00BCD4',
    );
    await tester.tap(
      find.descendant(of: createDialog, matching: find.text('创建')),
    );
    await tester.pumpAndSettle();

    // Snackbar 提示（可能在屏幕上出现）
    expect(find.textContaining('标签已创建'), findsOneWidget);
    // 等待新标签出现在列表中
    await pumpUntilFound(tester, find.text('学习'));

    // 点击列表项进入编辑
    await tester.tap(find.text('学习'));
    await tester.pumpAndSettle();
    final editDialog = find.byType(AlertDialog);
    await tester.enterText(
      find.descendant(of: editDialog, matching: find.byType(TextField)).at(0),
      '学习2',
    );
    await tester.tap(
      find.descendant(of: editDialog, matching: find.text('保存')),
    );
    await tester.pumpAndSettle();
    // 更稳健：校验列表项名称已更新为“学习2”
    await pumpUntilFound(tester, find.text('学习2'));
    expect(find.text('学习2'), findsOneWidget);

    // 删除刚创建的标签（非默认标签可删）
    final deleteIcon = find
        .widgetWithIcon(IconButton, Icons.delete_outline)
        .last;
    await tester.tap(deleteIcon);
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();
    // 更稳健：校验列表中已不再存在该标签
    expect(find.text('学习2'), findsNothing);
  });

  testWidgets('TagManagementPage 新建标签输入为空显示错误提示', (tester) async {
    await getIt.reset();
    final repo = InMemoryTagRepository();
    getIt.registerSingleton<TagManagementUseCase>(TagManagementUseCase(repo));

    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: TagManagementPage())),
    );
    await tester.pump(const Duration(milliseconds: 150));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    // 不输入名称，直接创建
    await tester.tap(find.text('创建'));
    await tester.pumpAndSettle();

    // 应显示用例返回的错误信息
    expect(find.textContaining('标签名称不能为空'), findsOneWidget);
  });
}
