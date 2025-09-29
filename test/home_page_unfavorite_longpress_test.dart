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
  testWidgets('HomePage 长按取消收藏显示提示', (tester) async {
    await getIt.reset();
    final entryRepo = InMemoryDiaryEntryRepository();
    final tagRepo = InMemoryTagRepository();
    final updateUc = UpdateDiaryEntryUseCase(entryRepo, tagRepo);
    final deleteUc = DeleteDiaryEntryUseCase(entryRepo, tagRepo);
    getIt.registerSingleton<UpdateDiaryEntryUseCase>(updateUc);
    getIt.registerSingleton<DeleteDiaryEntryUseCase>(deleteUc);

    final now = DateTime.now();
    final entry = DiaryEntry(id: 9, title: '已收藏项', content: 'c', createdAt: now, updatedAt: now, isFavorite: true, tags: [Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now)]);
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
    await tester.pump(const Duration(milliseconds: 200));

    await tester.longPress(find.text('已收藏项'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('取消收藏'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('已取消收藏'), findsOneWidget);
  });
}

