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
import 'package:inkboard/presentation/widgets/common/facebook_diary_card.dart';

import 'fakes.dart';

void main() {
  Future<void> pumpUntilFound(WidgetTester tester, Finder finder, {int maxTicks = 60, Duration step = const Duration(milliseconds: 50)}) async {
    for (var i = 0; i < maxTicks; i++) {
      if (finder.evaluate().isNotEmpty) return;
      await tester.pump(step);
    }
  }

  testWidgets('HomePage 更多菜单删除成功提示', (tester) async {
    // 注册用例与数据
    await getIt.reset();
    final entryRepo = InMemoryDiaryEntryRepository();
    final tagRepo = InMemoryTagRepository();
    final updateUc = UpdateDiaryEntryUseCase(entryRepo, tagRepo);
    final deleteUc = DeleteDiaryEntryUseCase(entryRepo, tagRepo);
    getIt.registerSingleton<UpdateDiaryEntryUseCase>(updateUc);
    getIt.registerSingleton<DeleteDiaryEntryUseCase>(deleteUc);

    final now = DateTime.now();
    final entry = DiaryEntry(id: 31, title: '更多菜单删除项', content: 'c', createdAt: now, updatedAt: now, tags: [Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now)]);
    await entryRepo.createDiaryEntry(entry);

    final override = diaryEntriesProvider.overrideWith((ref) => Stream.value([entry]));

    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(() { tester.view.resetPhysicalSize(); tester.view.resetDevicePixelRatio(); });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [override],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: Scaffold(body: HomePage())),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 150));

    // 直接触发卡片的删除回调，等效于在“更多”菜单中点选“删除日记”
    final card = tester.widgetList(find.byType(FacebookDiaryCard)).cast<FacebookDiaryCard>().first;
    card.onDeleteTap?.call();
    await tester.pump(const Duration(milliseconds: 100));
    final dialogFinder = find.byType(AlertDialog);
    await pumpUntilFound(tester, dialogFinder);
    final deleteBtn = find.descendant(of: dialogFinder, matching: find.text('删除'));
    await pumpUntilFound(tester, deleteBtn);
    await tester.tap(deleteBtn, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 300));
  });
}
