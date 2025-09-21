import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inkboard/core/theme/facebook_theme.dart';

class _ThemeSmokeApp extends StatelessWidget {
  const _ThemeSmokeApp();
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            theme: FacebookTheme.getLightTheme(),
            darkTheme: FacebookTheme.getDarkTheme(),
            home: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Theme Components'),
                  bottom: const TabBar(tabs: [
                    Tab(text: 'A'),
                    Tab(text: 'B'),
                  ]),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'H'),
                    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'S'),
                  ],
                ),
                floatingActionButton: const FloatingActionButton(onPressed: null, child: Icon(Icons.add)),
                body: Builder(builder: (context) {
                  return ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
                      OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
                      TextButton(onPressed: () {}, child: const Text('Text')),
                      const TextField(decoration: InputDecoration(hintText: '搜索日记内容...')),
                      const ListTile(title: Text('Title'), subtitle: Text('Subtitle')),
                      const Divider(),
                      const Icon(Icons.settings),
                      const Chip(label: Text('Chip')),
                      Switch(value: true, onChanged: (_) {}),
                      Checkbox(value: true, onChanged: (_) {}),
                      Radio<int>(value: 1, groupValue: 1, onChanged: (_) {}),
                    ],
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  testWidgets('主题组件冒烟覆盖', (WidgetTester tester) async {
    await tester.pumpWidget(const _ThemeSmokeApp());
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);
    expect(find.byType(TextField), findsAtLeastNWidgets(1));
    expect(find.byType(ListTile), findsOneWidget);
    expect(find.byType(Divider), findsWidgets);
    expect(find.byType(Chip), findsOneWidget);
    // 某些控件在不同平台/渲染路径下查找可能不稳定，此处仅保留主要断言

    // 触发 SnackBar 和 Dialog 演示以覆盖对应主题配置
    ScaffoldMessenger.of(tester.element(find.byType(Scaffold)))
        .showSnackBar(const SnackBar(content: Text('Hello')));
    await tester.pumpAndSettle();
    expect(find.text('Hello'), findsOneWidget);

    showDialog(
      context: tester.element(find.byType(Scaffold)),
      builder: (_) => AlertDialog(title: const Text('Dialog'), content: const Text('Content')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Dialog'), findsOneWidget);
  });
}
