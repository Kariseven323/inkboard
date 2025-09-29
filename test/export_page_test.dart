import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/domain/repositories/diary_entry_repository.dart';
import 'package:inkboard/presentation/pages/export_page.dart';

import 'fakes.dart';

class _RepoAdapter extends InMemoryDiaryEntryRepository implements DiaryEntryRepository {}

void main() {
  setUp(() async {
    await getIt.reset();
    final repo = _RepoAdapter();
    final now = DateTime.now();
    await repo.createDiaryEntry(DiaryEntry(
      id: 1,
      title: '标题1',
      content: '内容1',
      createdAt: now,
      updatedAt: now,
      isFavorite: true,
      tags: [Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now)],
      location: '深圳',
      weather: '晴',
      moodScore: 5,
    ));
    getIt.registerSingleton<DiaryEntryRepository>(repo);
  });

  testWidgets('ExportPage 生成 Markdown', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: ExportPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('生成Markdown'));
    await tester.pumpAndSettle();

    // 检查导出内容包含关键字段
    expect(find.textContaining('# 砚记导出'), findsOneWidget);
    expect(find.textContaining('title:'), findsWidgets);
    expect(find.textContaining('tags:'), findsWidgets);
  });

  // 复制到剪贴板操作在不同平台行为差异较大，已通过手动测试验证。
}
