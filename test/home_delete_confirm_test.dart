import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/domain/usecases/update_delete_diary_entry_usecase.dart';
import 'package:inkboard/presentation/pages/home_page.dart';
import 'package:inkboard/presentation/providers/diary_provider.dart';
import 'package:inkboard/presentation/layouts/facebook_layout.dart';

import 'fakes.dart';

void main() {
  testWidgets('HomePage 删除确认对话框并调用用例', (tester) async {
    // 准备假数据与用例（内存仓储）
    final entryRepo = InMemoryDiaryEntryRepository();
    final tagRepo = InMemoryTagRepository();
    final delUsecase = DeleteDiaryEntryUseCase(entryRepo, tagRepo);

    final now = DateTime.now();
    final t = Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now);
    // 预放入仓储，确保用例查询到该条目
    final entry = DiaryEntry(
      id: 1,
      title: '待删除',
      content: '内容',
      createdAt: now,
      updatedAt: now,
      tags: [t],
    );
    await entryRepo.createDiaryEntry(entry);

    // 重置并注册 DI
    await getIt.reset();
    getIt.registerSingleton<DeleteDiaryEntryUseCase>(delUsecase);

    // 覆盖 Provider 提供相同 ID 的条目（用于渲染卡片）
    final providerOverride = diaryEntriesProvider.overrideWith((ref) {
      return Stream<List<DiaryEntry>>.value([entry]);
    });

    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(375, 800);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [providerOverride],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) =>
              const MaterialApp(home: FacebookLayout(child: HomePage())),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    // 打开更多菜单并点击“删除日记”
    final more = find.byIcon(Icons.more_horiz).first;
    await tester.ensureVisible(more);
    await tester.tap(more, warnIfMissed: false);
    await tester.pumpAndSettle();
    final deleteItem = find.text('删除日记');
    await tester.tap(deleteItem, warnIfMissed: false);
    await tester.pumpAndSettle();

    // 点击确认删除按钮
    await tester.tap(find.text('删除'));
    await tester.pump(const Duration(milliseconds: 300));

    // 仓储中应已删除
    final e = await entryRepo.getDiaryEntryById(1);
    expect(e, isNull);
  });
}
