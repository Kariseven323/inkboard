import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/domain/common/result.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/domain/usecases/update_delete_diary_entry_usecase.dart';
import 'package:inkboard/presentation/pages/home_page.dart';
import 'package:inkboard/presentation/providers/diary_provider.dart';
import 'fakes.dart';

class _FailToggleUsecase extends UpdateDiaryEntryUseCase {
  _FailToggleUsecase()
    : super(InMemoryDiaryEntryRepository(), InMemoryTagRepository());
  @override
  Future<Result<bool>> toggleFavorite(int id) async =>
      Result.failure('ToggleOops');
}

void main() {
  testWidgets('HomePage 收藏切换失败显示错误提示', (tester) async {
    await getIt.reset();
    getIt.registerSingleton<UpdateDiaryEntryUseCase>(_FailToggleUsecase());
    // Delete 用例可不触发
    getIt.registerSingleton<DeleteDiaryEntryUseCase>(_FakeDeleteUsecase());

    final now = DateTime.now();
    final entry = DiaryEntry(
      id: 5,
      title: '收藏失败用例',
      content: '内容',
      createdAt: now,
      updatedAt: now,
      isFavorite: false,
      tags: [Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now)],
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
    await tester.pump(const Duration(milliseconds: 200));

    await tester.tap(find.text('收藏').first, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('ToggleOops'), findsOneWidget);
  });
}

class _FakeDeleteUsecase extends DeleteDiaryEntryUseCase {
  _FakeDeleteUsecase()
    : super(InMemoryDiaryEntryRepository(), InMemoryTagRepository());
}
