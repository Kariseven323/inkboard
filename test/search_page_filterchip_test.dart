import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/presentation/pages/search_page.dart';

void main() {
  testWidgets('SearchPage 高级筛选 FilterChip 选中切换', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ScreenUtilInit(
          designSize: Size(390, 844),
          child: MaterialApp(home: SearchPage(initialQuery: 'x')),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byIcon(Icons.tune));
    await tester.pump(const Duration(milliseconds: 100));
    final chipFinder = find.byType(FilterChip);
    var chip = tester.widget<FilterChip>(chipFinder);
    expect(chip.selected, isFalse);
    await tester.tap(chipFinder);
    await tester.pump(const Duration(milliseconds: 100));
    chip = tester.widget<FilterChip>(chipFinder);
    expect(chip.selected, isTrue);
  });
}
