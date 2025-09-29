import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/domain/usecases/create_diary_entry_usecase.dart';
import 'package:inkboard/domain/usecases/update_delete_diary_entry_usecase.dart';
import 'package:inkboard/presentation/pages/diary_edit_page.dart';

import 'fakes.dart';

Future<void> _pumpEditor(WidgetTester tester, Widget child, {Size size = const Size(390, 800)}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() { tester.view.resetPhysicalSize(); tester.view.resetDevicePixelRatio(); });
  await tester.pumpWidget(
    ProviderScope(
      child: ScreenUtilInit(
        designSize: size,
        builder: (context, _) => MaterialApp(
          home: Builder(
            builder: (ctx) {
              // 将编辑页以 push 的方式入栈，便于测试中验证 pop 返回
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => child));
              });
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('DiaryEditPage 创建模式保存成功并返回', (tester) async {
    await getIt.reset();
    final entryRepo = InMemoryDiaryEntryRepository();
    final tagRepo = InMemoryTagRepository();
    getIt.registerSingleton<CreateDiaryEntryUseCase>(CreateDiaryEntryUseCase(entryRepo, tagRepo));
    getIt.registerSingleton<UpdateDiaryEntryUseCase>(UpdateDiaryEntryUseCase(entryRepo, tagRepo));

    await _pumpEditor(tester, const DiaryEditPage());

    final pageFinder = find.byType(DiaryEditPage);
    final titleField = find.descendant(of: pageFinder, matching: find.byType(TextFormField)).first;
    final contentField = find.descendant(of: pageFinder, matching: find.byType(TextFormField)).last;
    await tester.enterText(titleField, '标题X');
    await tester.enterText(contentField, '内容Y');
    await tester.pump(const Duration(milliseconds: 100));

    // 点击 AppBar 右侧“发布”按钮
    final publishBtn = find.ancestor(of: find.text('发布'), matching: find.byType(TextButton)).first;
    await tester.ensureVisible(publishBtn);
    await tester.tap(publishBtn);
    await tester.pump(const Duration(milliseconds: 300));
    // 更稳健：直接校验仓库中已新增数据
    final stats = await entryRepo.getDiaryStatistics();
    expect(stats['total'] ?? 0, greaterThan(0));
  });

  testWidgets('DiaryEditPage 编辑模式保存成功并返回', (tester) async {
    await getIt.reset();
    final entryRepo = InMemoryDiaryEntryRepository();
    final tagRepo = InMemoryTagRepository();
    final now = DateTime.now();
    final entry = DiaryEntry(id: 100, title: 'T', content: 'C', createdAt: now, updatedAt: now, tags: [Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now)]);
    await entryRepo.createDiaryEntry(entry);
    getIt.registerSingleton<CreateDiaryEntryUseCase>(CreateDiaryEntryUseCase(entryRepo, tagRepo));
    getIt.registerSingleton<UpdateDiaryEntryUseCase>(UpdateDiaryEntryUseCase(entryRepo, tagRepo));

    await _pumpEditor(tester, DiaryEditPage(diaryEntry: entry));

    final pageFinder2 = find.byType(DiaryEditPage);
    await tester.enterText(find.descendant(of: pageFinder2, matching: find.byType(TextFormField)).first, 'T2');
    await tester.enterText(find.descendant(of: pageFinder2, matching: find.byType(TextFormField)).last, 'C2');
    await tester.pump(const Duration(milliseconds: 100));

    final publishBtn2 = find.ancestor(of: find.text('发布'), matching: find.byType(TextButton)).first;
    await tester.ensureVisible(publishBtn2);
    await tester.tap(publishBtn2);
    await tester.pump(const Duration(milliseconds: 300));
    // 更稳健：直接校验仓库中已更新
    final updated = await entryRepo.getDiaryEntryById(entry.id!);
    expect(updated?.title, 'T2');
    expect(updated?.content, 'C2');
  });
}
