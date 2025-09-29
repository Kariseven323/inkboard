import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/domain/usecases/soft_delete_diary_entry_usecase.dart';
import 'package:inkboard/presentation/pages/home_page.dart';
import 'package:inkboard/presentation/providers/diary_provider.dart';

import 'fakes.dart';

void main() {
  testWidgets('HomePage 删除 -> 软删除并提示移入回收站', (tester) async {
    await getIt.reset();
    final entryRepo = InMemoryDiaryEntryRepository();
    final _ = InMemoryTagRepository(); // 占位以兼容用例初始化
    final softDeleteUc = SoftDeleteDiaryEntryUseCase(entryRepo);
    getIt.registerSingleton<SoftDeleteDiaryEntryUseCase>(softDeleteUc);

    final now = DateTime.now();
    final entry = DiaryEntry(
      id: 101,
      title: '软删除条目',
      content: 'c',
      createdAt: now,
      updatedAt: now,
      tags: [Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now)],
    );
    await entryRepo.createDiaryEntry(entry);

    final override = diaryEntriesProvider.overrideWith(
      (ref) => Stream.value([entry]),
    );

    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [override],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) =>
              const MaterialApp(home: Scaffold(body: HomePage())),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 150));

    // 打开长按菜单并点击 删除日记
    await tester.longPress(find.text('软删除条目'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除日记'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除'));
    await tester.pump(const Duration(milliseconds: 300));

    // 提示
    expect(find.text('日记已移入回收站'), findsOneWidget);
    // 仓储中已不可见（内存实现软删=硬删）
    final after = await entryRepo.getDiaryEntryById(101);
    expect(after, isNull);
  });
}
