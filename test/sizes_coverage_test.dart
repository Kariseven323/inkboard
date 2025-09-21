import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/theme/facebook_sizes.dart';

void main() {
  testWidgets('覆盖 FacebookSizes 多数尺寸 getter', (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        builder: (context, child) => const SizedBox.shrink(),
      ),
    );
    await tester.pumpAndSettle();

    // 间距
    expect(FacebookSizes.spacing2, greaterThan(0));
    expect(FacebookSizes.spacing4, greaterThan(0));
    expect(FacebookSizes.spacing8, greaterThan(0));
    expect(FacebookSizes.spacing12, greaterThan(0));
    expect(FacebookSizes.spacing16, greaterThan(0));
    expect(FacebookSizes.spacing20, greaterThan(0));
    expect(FacebookSizes.spacing24, greaterThan(0));
    expect(FacebookSizes.spacing32, greaterThan(0));
    expect(FacebookSizes.spacing40, greaterThan(0));
    expect(FacebookSizes.spacing48, greaterThan(0));
    expect(FacebookSizes.spacing64, greaterThan(0));

    // 圆角
    expect(FacebookSizes.radiusSmall, greaterThan(0));
    expect(FacebookSizes.radiusMedium, greaterThan(0));
    expect(FacebookSizes.radiusLarge, greaterThan(0));
    expect(FacebookSizes.radiusRound, greaterThan(0));
    expect(FacebookSizes.radiusXLarge, greaterThan(0));

    // 头像与图标
    expect(FacebookSizes.avatarSmall, greaterThan(0));
    expect(FacebookSizes.avatarMedium, greaterThan(0));
    expect(FacebookSizes.avatarLarge, greaterThan(0));
    expect(FacebookSizes.avatarXLarge, greaterThan(0));
    expect(FacebookSizes.iconSmall, greaterThan(0));
    expect(FacebookSizes.iconMedium, greaterThan(0));
    expect(FacebookSizes.iconLarge, greaterThan(0));
    expect(FacebookSizes.iconXLarge, greaterThan(0));

    // 按钮与输入
    expect(FacebookSizes.buttonHeightSmall, greaterThan(0));
    expect(FacebookSizes.buttonHeightMedium, greaterThan(0));
    expect(FacebookSizes.buttonHeightLarge, greaterThan(0));
    expect(FacebookSizes.inputHeight, greaterThan(0));
    expect(FacebookSizes.inputBorderWidth, greaterThan(0));

    // 卡片与容器
    expect(FacebookSizes.cardElevation, greaterThan(0));
    expect(FacebookSizes.cardPadding, greaterThan(0));
    expect(FacebookSizes.containerPadding, greaterThan(0));

    // 布局与断点
    expect(FacebookSizes.navBarHeight, greaterThan(0));
    expect(FacebookSizes.navBarPadding, greaterThan(0));
    expect(FacebookSizes.listItemHeight, greaterThan(0));
    expect(FacebookSizes.listItemPadding, greaterThan(0));
    expect(FacebookSizes.dividerThickness, greaterThan(0));
    expect(FacebookSizes.borderWidth, greaterThan(0));

    expect(FacebookSizes.bottomNavHeight, greaterThan(0));
    expect(FacebookSizes.bottomNavIconSize, greaterThan(0));

    expect(FacebookSizes.fabSize, greaterThan(0));
    expect(FacebookSizes.fabMiniSize, greaterThan(0));

    expect(FacebookSizes.pageHorizontalPadding, greaterThan(0));
    expect(FacebookSizes.pageVerticalPadding, greaterThan(0));

    expect(FacebookSizes.maxContentWidth, greaterThan(0));
    expect(FacebookSizes.sidebarWidth, greaterThan(0));
    expect(FacebookSizes.rightSidebarWidth, greaterThan(0));
    expect(FacebookSizes.breakpointTablet, greaterThan(0));
    expect(FacebookSizes.breakpointDesktop, greaterThan(0));
    expect(FacebookSizes.breakpointMobile, greaterThan(0));
    expect(FacebookSizes.breakpointLarge, greaterThan(0));

    // 阴影与动画
    expect(FacebookSizes.shadowOffsetY, greaterThanOrEqualTo(0));
    expect(FacebookSizes.animationNormal.inMilliseconds, greaterThan(0));

    // 边距
    expect(FacebookSizes.paddingAll, isA<EdgeInsets>());
    expect(FacebookSizes.paddingHorizontal, isA<EdgeInsets>());
    expect(FacebookSizes.paddingVertical, isA<EdgeInsets>());
    expect(FacebookSizes.paddingSmall, isA<EdgeInsets>());
    expect(FacebookSizes.paddingLarge, isA<EdgeInsets>());

    expect(FacebookSizes.marginAll, isA<EdgeInsets>());
    expect(FacebookSizes.marginHorizontal, isA<EdgeInsets>());
    expect(FacebookSizes.marginVertical, isA<EdgeInsets>());
    expect(FacebookSizes.marginSmall, isA<EdgeInsets>());
    expect(FacebookSizes.marginLarge, isA<EdgeInsets>());
  });
}
