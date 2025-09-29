import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/domain/common/result.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/domain/repositories/diary_entry_repository.dart';
import 'package:inkboard/domain/repositories/tag_repository.dart';
import 'package:inkboard/domain/usecases/update_delete_diary_entry_usecase.dart';
import 'package:inkboard/presentation/pages/home_page.dart';
import 'package:inkboard/presentation/providers/diary_provider.dart';

import 'fakes.dart';

class _FailingDeleteUsecase extends DeleteDiaryEntryUseCase {
  // ignore: use_super_parameters
  _FailingDeleteUsecase(DiaryEntryRepository d, TagRepository t) : super(d, t);
  @override
  Future<Result<bool>> execute(int id) async => Result.failure('Boom');
}

void main() {
  testWidgets('HomePage 删除失败显示错误提示', (tester) async {
    final now = DateTime.now();
    final entry = DiaryEntry(
      id: 1,
      title: '待删',
      content: '内容',
      createdAt: now,
      updatedAt: now,
      tags: [Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now)],
    );

    await getIt.reset();
    final entryRepo = InMemoryDiaryEntryRepository();
    final tagRepo = InMemoryTagRepository();
    await entryRepo.createDiaryEntry(entry);
    getIt.registerSingleton<UpdateDiaryEntryUseCase>(UpdateDiaryEntryUseCase(entryRepo, tagRepo));
    getIt.registerSingleton<DeleteDiaryEntryUseCase>(_FailingDeleteUsecase(entryRepo, tagRepo));

    final listOverride = diaryEntriesProvider.overrideWith((ref) => Stream.value([entry]));

    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(() { tester.view.resetPhysicalSize(); tester.view.resetDevicePixelRatio(); });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [listOverride],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: Scaffold(body: HomePage())),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    // 打开底部菜单 - 选择删除
    await tester.longPress(find.text('待删'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除日记'));
    await tester.pumpAndSettle();

    // 弹出确认对话框，点击“删除”
    await tester.tap(find.text('删除'));
    await tester.pump(const Duration(milliseconds: 300));

    // 错误提示
    expect(find.textContaining('Boom'), findsOneWidget);
  });
}
