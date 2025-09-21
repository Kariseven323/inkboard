import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkboard/core/theme/facebook_theme.dart';

class _Probe extends StatelessWidget {
  final void Function(BuildContext) onBuild;
  const _Probe(this.onBuild);
  @override
  Widget build(BuildContext context) {
    onBuild(context);
    return const SizedBox.shrink();
  }
}

void main() {
  testWidgets('isDarkTheme 与 getAdaptiveColor', (WidgetTester tester) async {
    // 直接用 Theme 包裹以控制明暗主题
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          home: Theme(
            data: FacebookTheme.getLightTheme(),
            child: _Probe((ctx) {
              expect(FacebookTheme.isDarkTheme(ctx), isFalse);
              final c = FacebookTheme.getAdaptiveColor(
                ctx,
                lightColor: Colors.white,
                darkColor: Colors.black,
              );
              expect(c, Colors.white);
            }),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          home: Theme(
            data: FacebookTheme.getDarkTheme(),
            child: _Probe((ctx) {
              expect(FacebookTheme.isDarkTheme(ctx), isTrue);
              final c = FacebookTheme.getAdaptiveColor(
                ctx,
                lightColor: Colors.white,
                darkColor: Colors.black,
              );
              expect(c, Colors.black);
            }),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  });
}
