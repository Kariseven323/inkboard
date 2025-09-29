import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/domain/entities/diary_entry.dart';
import 'package:inkboard/presentation/pages/home_page.dart';
import 'package:inkboard/presentation/providers/diary_provider.dart';

void main() {
  testWidgets('HomePage 加载与错误状态渲染', (tester) async {
    // 辅助：等待直到找到指定文本，避免异步/时序抖动
    Future<void> pumpUntilFound(Finder finder, {int maxTicks = 60, Duration step = const Duration(milliseconds: 50)}) async {
      for (var i = 0; i < maxTicks; i++) {
        if (finder.evaluate().isNotEmpty) return;
        await tester.pump(step);
      }
    }

    // 加载态：使用不立即发射的 Stream
    final loadingCtrl = StreamController<List<DiaryEntry>>();
    final loadingOverride = diaryEntriesProvider.overrideWith((ref) => loadingCtrl.stream);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [loadingOverride],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: Scaffold(body: HomePage())),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('正在加载日记...'), findsOneWidget);
    await loadingCtrl.close();

    // 错误态：在 overrideWith 中构造一个流，并在 microtask 中立即抛错，
    // 避免监听时序导致的不确定性，且兼容不支持 overrideWithValue 的 Riverpod 版本。
    final errorOverride = diaryEntriesProvider.overrideWith((ref) {
      late final StreamController<List<DiaryEntry>> ctrl;
      ctrl = StreamController<List<DiaryEntry>>(
        // 当有监听者时立即抛出错误，确保不会丢失事件
        onListen: () => ctrl.addError('ERR'),
      );
      ref.onDispose(() => ctrl.close());
      return ctrl.stream;
    });
    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        overrides: [errorOverride],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: Scaffold(body: HomePage())),
        ),
      ),
    );
    // 等待错误态文本稳定出现
    await pumpUntilFound(find.text('加载失败'));
    expect(find.text('加载失败'), findsOneWidget);
    expect(find.textContaining('ERR'), findsOneWidget);
  });
}
