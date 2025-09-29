import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/domain/repositories/diary_entry_repository.dart';
import 'package:inkboard/presentation/pages/recycle_bin_page.dart';

class _RepoFake implements DiaryEntryRepository {
  final _deletedCtrl = StreamController<List<DiaryEntry>>.broadcast();
  bool restored = false;
  bool purged = false;

  void emitDeleted(List<DiaryEntry> items) => _deletedCtrl.add(items);

  @override
  Stream<List<DiaryEntry>> getDeletedDiaryEntries() => _deletedCtrl.stream;

  @override
  Future<bool> restoreDiaryEntry(int id) async {
    restored = true;
    return true;
  }

  @override
  Future<bool> purgeDiaryEntry(int id) async {
    purged = true;
    return true;
  }

  // Unused members for this test suite
  @override
  Future<bool> addTagToEntry(int entryId, int tagId) async => true;

  @override
  Future<int> createDiaryEntry(DiaryEntry entry) async => 1;

  @override
  Future<bool> deleteDiaryEntries(List<int> ids) async => true;

  @override
  Future<bool> deleteDiaryEntry(int id) async => true;

  @override
  Future<DiaryEntry?> getDiaryEntryById(int id) async => null;

  @override
  Stream<List<DiaryEntry>> getDiaryEntriesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async* {}

  @override
  Stream<List<DiaryEntry>> getDiaryEntriesByTags(List<int> tagIds) async* {}

  @override
  Stream<List<DiaryEntry>> getAllDiaryEntries() async* {}

  @override
  Stream<List<DiaryEntry>> getFavoriteDiaryEntries() async* {}

  @override
  Stream<List<DiaryEntry>> searchDiaryEntries(String query) async* {}

  @override
  Future<Map<String, int>> getDiaryStatistics() async => {};

  @override
  Future<bool> removeTagFromEntry(int entryId, int tagId) async => true;

  @override
  Future<bool> restoreDiaryEntries(List<int> ids) async => true;

  @override
  Future<bool> softDeleteDiaryEntries(List<int> ids) async => true;

  @override
  Future<bool> softDeleteDiaryEntry(int id) async => true;

  @override
  Future<bool> toggleFavorite(int id) async => true;

  @override
  Future<bool> updateDiaryEntry(DiaryEntry entry) async => true;

  @override
  Future<bool> purgeDiaryEntries(List<int> ids) async => true;
}

void main() {
  late _RepoFake repo;

  setUp(() async {
    await getIt.reset(dispose: true);
    repo = _RepoFake();
    getIt.registerLazySingleton<DiaryEntryRepository>(() => repo);
  });

  testWidgets('RecycleBinPage 空状态与标题', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(800, 1200);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => const MaterialApp(home: RecycleBinPage()),
      ),
    );
    // 初始为空
    repo.emitDeleted(const []);
    await tester.pump();

    expect(find.text('回收站'), findsOneWidget);
    expect(find.text('回收站空空如也'), findsOneWidget);
  });

  testWidgets('RecycleBinPage 恢复与彻底删除流程', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1000, 1600);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final e = DiaryEntry(
      id: 1,
      title: '已删除的日记',
      content: '内容内容',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => const MaterialApp(home: RecycleBinPage()),
      ),
    );
    // 推送一个含有条目的回收站列表
    repo.emitDeleted([e]);
    await tester.pump();

    expect(find.text('已删除的日记'), findsOneWidget);

    // 点击 恢复
    await tester.tap(find.widgetWithText(OutlinedButton, '恢复'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(repo.restored, isTrue);

    // 点击 彻底删除 -> 弹窗 -> 确认 删除
    await tester.tap(find.widgetWithText(TextButton, '彻底删除'));
    await tester.pump(); // 等待对话框出现
    expect(find.text('彻底删除？'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, '删除'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(repo.purged, isTrue);

    // SnackBar 提示
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
