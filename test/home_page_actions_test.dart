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

import 'fakes.dart';

void main() {
  testWidgets('HomePage 收藏与分享 SnackBar', (tester) async {
    // 准备数据与用例
    final now = DateTime.now();
    var entry = DiaryEntry(
      id: 10,
      title: '收藏与分享用例',
      content: '内容',
      createdAt: now,
      updatedAt: now,
      isFavorite: false,
      tags: [Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now)],
    );
    // 注册 Toggle 用例（内存实现）
    await getIt.reset();
    final entryRepo = InMemoryDiaryEntryRepository();
    final tagRepo = InMemoryTagRepository();
    final newId = await entryRepo.createDiaryEntry(entry);
    entry = entry.copyWith(id: newId);
    final listOverride = diaryEntriesProvider.overrideWith((ref) => Stream.value([entry]));
    final updateUsecase = UpdateDiaryEntryUseCase(entryRepo, tagRepo);
    final deleteUsecase = DeleteDiaryEntryUseCase(entryRepo, tagRepo);
    getIt.registerSingleton<UpdateDiaryEntryUseCase>(updateUsecase);
    getIt.registerSingleton<DeleteDiaryEntryUseCase>(deleteUsecase);

    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [listOverride],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: Scaffold(body: HomePage())),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('收藏与分享用例'), findsOneWidget);

    // 点击收藏按钮
    final favLabel = find.text('收藏').first;
    await tester.ensureVisible(favLabel);
    await tester.tap(favLabel, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 300));
    final updated = await entryRepo.getDiaryEntryById(newId);
    expect(updated?.isFavorite, isTrue);

    // 再次点击切换为未收藏（直接点击同一文案区域，避免依赖UI图标更新）
    await tester.tap(favLabel, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 300));
    final updated2 = await entryRepo.getDiaryEntryById(newId);
    expect(updated2?.isFavorite, isFalse);

    // 点击分享按钮（应出现提示）
    final shareIcon = find.byIcon(Icons.share_outlined).first;
    await tester.ensureVisible(shareIcon);
    await tester.tap(shareIcon, warnIfMissed: false);
    // 给 Snackbar 动画充分时间
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
