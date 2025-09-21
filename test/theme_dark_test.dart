import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkboard/core/theme/facebook_colors.dart';
import 'package:inkboard/core/theme/facebook_theme.dart';

void main() {
  testWidgets('暗色主题分支：颜色与卡片表面色', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        builder: (context, child) {
          return const SizedBox.shrink();
        },
      ),
    );

    // 经过 ScreenUtilInit 初始化后再获取主题
    final dark = FacebookTheme.getDarkTheme();
    expect(dark.colorScheme.primary, FacebookColors.primary);
    // 暗色卡片颜色应为深色 0xFF242526
    expect(dark.cardTheme.color, const Color(0xFF242526));
  });
}
