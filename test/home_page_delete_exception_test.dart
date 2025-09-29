import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/domain/common/result.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/usecases/update_delete_diary_entry_usecase.dart';
import 'package:inkboard/presentation/pages/home_page.dart';
import 'package:inkboard/presentation/providers/diary_provider.dart';

import 'fakes.dart';

class _ThrowingDeleteUsecase extends DeleteDiaryEntryUseCase {
  _ThrowingDeleteUsecase()
    : super(InMemoryDiaryEntryRepository(), InMemoryTagRepository());
  @override
  Future<Result<bool>> execute(int id) async {
    throw Exception('ExBoom');
  }
}

void main() {
  testWidgets('HomePage 删除异常走 catch 分支', (tester) async {
    await getIt.reset();
    getIt.registerSingleton<DeleteDiaryEntryUseCase>(_ThrowingDeleteUsecase());
    getIt.registerSingleton<UpdateDiaryEntryUseCase>(
      UpdateDiaryEntryUseCase(
        InMemoryDiaryEntryRepository(),
        InMemoryTagRepository(),
      ),
    );

    final now = DateTime.now();
    final entry = DiaryEntry(
      id: 21,
      title: '异常删除项',
      content: 'c',
      createdAt: now,
      updatedAt: now,
    );
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

    await tester.longPress(find.text('异常删除项'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除日记'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.textContaining('删除失败：'), findsOneWidget);
  });
}
