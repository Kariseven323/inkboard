import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/theme/facebook_text_styles.dart';

void main() {
  testWidgets('覆盖 FacebookTextStyles 大部分样式 getter', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        builder: (context, child) => const SizedBox.shrink(),
      ),
    );
    await tester.pumpAndSettle();

    // 标题样式
    expect(FacebookTextStyles.headline1.fontSize, isNonZero);
    expect(FacebookTextStyles.headline2.fontSize, isNonZero);
    expect(FacebookTextStyles.headline3.fontSize, isNonZero);
    expect(FacebookTextStyles.headline4.fontSize, isNonZero);
    expect(FacebookTextStyles.headline5.fontSize, isNonZero);
    expect(FacebookTextStyles.headline6.fontSize, isNonZero);

    // 正文样式
    expect(FacebookTextStyles.bodyLarge.fontSize, isNonZero);
    expect(FacebookTextStyles.bodyMedium.fontSize, isNonZero);
    expect(FacebookTextStyles.bodySmall.fontSize, isNonZero);

    // 标签/辅助
    expect(FacebookTextStyles.caption.fontSize, isNonZero);
    expect(FacebookTextStyles.overline.fontSize, isNonZero);

    // 按钮
    expect(FacebookTextStyles.buttonLarge.fontSize, isNonZero);
    expect(FacebookTextStyles.buttonMedium.fontSize, isNonZero);
    expect(FacebookTextStyles.buttonSmall.fontSize, isNonZero);

    // 链接与衍生
    expect(FacebookTextStyles.link.fontSize, isNonZero);
    expect(
      FacebookTextStyles.linkUnderline.decoration,
      TextDecoration.underline,
    );

    // 其他
    expect(FacebookTextStyles.error.color, isNotNull);
    expect(FacebookTextStyles.success.color, isNotNull);
    expect(FacebookTextStyles.username.fontWeight, FontWeight.w600);
    expect(FacebookTextStyles.timestamp.fontSize, isNonZero);
    expect(FacebookTextStyles.placeholder.color, isNotNull);

    // TextTheme 构建
    final textTheme = FacebookTextStyles.getTextTheme();
    expect(textTheme.bodyMedium, isNotNull);
  });
}
