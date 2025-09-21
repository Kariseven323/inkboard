import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/di/service_locator.dart';
import 'package:inkboard/core/theme/facebook_colors.dart';
import 'package:inkboard/main.dart';

void main() {
  setUpAll(() {
    configureDependencies();
  });

  testWidgets('主题颜色与设计系统一致', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: InkboardApp(),
      ),
    );

    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    final theme = materialApp.theme!;

    // 主色、分割线与表面色等关键token对齐
    expect(theme.colorScheme.primary, FacebookColors.primary);
    expect(theme.dividerTheme.color, FacebookColors.divider);
    expect(theme.colorScheme.surface, FacebookColors.surface);
  });
}

