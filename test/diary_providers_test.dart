import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/entities/tag.dart';
import 'package:inkboard/domain/usecases/get_diary_entries_usecase.dart';
import 'package:inkboard/presentation/providers/diary_provider.dart';

import 'fakes.dart';

void main() {
  testWidgets('diaryStatisticsProvider 返回统计信息', (tester) async {
    await getIt.reset();
    final repo = InMemoryDiaryEntryRepository();
    final now = DateTime.now();
    await repo.createDiaryEntry(
      DiaryEntry(
        id: 1,
        title: 'A',
        content: 'A',
        createdAt: now,
        updatedAt: now,
        isFavorite: true,
      ),
    );
    await repo.createDiaryEntry(
      DiaryEntry(
        id: 2,
        title: 'B',
        content: 'B',
        createdAt: now,
        updatedAt: now,
      ),
    );
    getIt.registerSingleton<GetDiaryEntriesUseCase>(
      GetDiaryEntriesUseCase(repo),
    );

    late AsyncValue<dynamic> asyncStats;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) {
                asyncStats = ref.watch(diaryStatisticsProvider);
                final data = asyncStats.asData?.value;
                if (data == null) return const Text('loading');
                return Column(
                  children: [
                    Text('total:${data.totalCount}'),
                    Text('fav:${data.favoriteCount}'),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('total:2'), findsOneWidget);
    expect(find.text('fav:1'), findsOneWidget);
  });

  testWidgets('diaryEntriesByTagsProvider 与日期范围 Provider', (tester) async {
    await getIt.reset();
    final repo = InMemoryDiaryEntryRepository();
    final now = DateTime.now();
    final t1 = Tag(id: 1, name: 'X', color: '#1877F2', createdAt: now);
    await repo.createDiaryEntry(
      DiaryEntry(
        id: 1,
        title: 'A',
        content: 'A',
        createdAt: now,
        updatedAt: now,
        tags: [t1],
      ),
    );
    getIt.registerSingleton<GetDiaryEntriesUseCase>(
      GetDiaryEntriesUseCase(repo),
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              final byTags = ref.watch(diaryEntriesByTagsProvider(const [1]));
              final byDate = ref.watch(
                diaryEntriesByDateRangeProvider(
                  DateRange(
                    startDate: now.subtract(const Duration(days: 1)),
                    endDate: now.add(const Duration(days: 1)),
                  ),
                ),
              );
              return Column(
                children: [
                  Text('tags:${byTags.asData?.value.length ?? 0}'),
                  Text('date:${byDate.asData?.value.length ?? 0}'),
                ],
              );
            },
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.textContaining('tags:1'), findsOneWidget);
    expect(find.textContaining('date:1'), findsOneWidget);
  });
}
