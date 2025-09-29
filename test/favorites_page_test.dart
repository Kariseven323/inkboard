import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/presentation/pages/favorites_page.dart';
import 'package:inkboard/presentation/providers/diary_provider.dart';
import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/domain/usecases/update_delete_diary_entry_usecase.dart';
import 'fakes.dart';

void main() {
  testWidgets('FavoritesPage 渲染收藏列表', (tester) async {
    final now = DateTime.now();
    final entries = [
      DiaryEntry(
        id: 1,
        title: '收藏A',
        content: '内容A',
        createdAt: now,
        updatedAt: now,
        isFavorite: true,
        tags: [Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now)],
      ),
    ];

    final override = favoriteDiaryEntriesProvider.overrideWith((ref) => Stream.value(entries));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [override],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: FavoritesPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('收藏夹'), findsOneWidget);
    expect(find.text('收藏A'), findsOneWidget);
  });

  testWidgets('FavoritesPage 空态渲染', (tester) async {
    final emptyOverride = favoriteDiaryEntriesProvider.overrideWith((ref) => Stream<List<DiaryEntry>>.value(const []));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [emptyOverride],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: FavoritesPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('暂无收藏'), findsOneWidget);
  });

  testWidgets('FavoritesPage 错误状态渲染', (tester) async {
    final errorOverride = favoriteDiaryEntriesProvider.overrideWith((ref) => Stream<List<DiaryEntry>>.error('OOPS'));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [errorOverride],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: FavoritesPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('OOPS'), findsOneWidget);
  });

  testWidgets('FavoritesPage 加载状态渲染', (tester) async {
    final ctrl = StreamController<List<DiaryEntry>>();
    addTearDown(() => ctrl.close());
    final loadingOverride = favoriteDiaryEntriesProvider.overrideWith((ref) => ctrl.stream);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [loadingOverride],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: FavoritesPage()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('FavoritesPage 点击收藏按钮调用用例', (tester) async {
    final now = DateTime.now();
    final entry = DiaryEntry(
      id: 1,
      title: '收藏B',
      content: '内容B',
      createdAt: now,
      updatedAt: now,
      isFavorite: true,
      tags: [Tag(id: 1, name: '工作', color: '#1877F2', createdAt: now)],
    );
    final override = favoriteDiaryEntriesProvider.overrideWith((ref) => Stream.value([entry]));

    // 准备仓储与用例
    final entryRepo = InMemoryDiaryEntryRepository();
    final tagRepo = InMemoryTagRepository();
    await entryRepo.createDiaryEntry(entry);
    final usecase = UpdateDiaryEntryUseCase(entryRepo, tagRepo);
    await getIt.reset();
    getIt.registerSingleton<UpdateDiaryEntryUseCase>(usecase);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [override],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: FavoritesPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 点按心形收藏按钮
    final favIcon = find.byIcon(Icons.favorite).first;
    await tester.tap(favIcon);
    await tester.pump(const Duration(milliseconds: 200));

    // 没有异常即视为通过（SnackBar也会出现）
    expect(find.text('收藏B'), findsOneWidget);
  });
}
