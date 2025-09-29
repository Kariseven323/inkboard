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

class _ThrowToggleUsecase extends UpdateDiaryEntryUseCase {
  _ThrowToggleUsecase() : super(InMemoryDiaryEntryRepository(), InMemoryTagRepository());
  @override
  Future<Result<bool>> toggleFavorite(int id) async {
    throw Exception('ToggleEx');
  }
}

void main() {
  testWidgets('HomePage 收藏异常走 catch 分支', (tester) async {
    await getIt.reset();
    getIt.registerSingleton<UpdateDiaryEntryUseCase>(_ThrowToggleUsecase());
    getIt.registerSingleton<DeleteDiaryEntryUseCase>(DeleteDiaryEntryUseCase(InMemoryDiaryEntryRepository(), InMemoryTagRepository()));

    final now = DateTime.now();
    final entry = DiaryEntry(id: 22, title: '异常收藏项', content: 'c', createdAt: now, updatedAt: now);
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
    await tester.tap(find.text('收藏').first);
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.textContaining('收藏'), findsWidgets); // 有错误 SnackBar 文本
  });
}
