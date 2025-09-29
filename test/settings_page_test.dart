import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/presentation/pages/settings_page.dart';

void main() {
  testWidgets('SettingsPage 主题切换与字体大小调节', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => const MaterialApp(home: SettingsPage()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    // 找到主题分段控件，点击切换到深色
    final darkIcon = find.byIcon(Icons.dark_mode);
    expect(darkIcon, findsOneWidget);
    await tester.tap(darkIcon);
    await tester.pump(const Duration(milliseconds: 100));

    // 调整字体大小滑块
    final slider = find.byType(Slider);
    expect(slider, findsOneWidget);
    await tester.drag(slider, const Offset(50, 0));
    await tester.pump(const Duration(milliseconds: 100));
  });
}
