import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/service_locator.dart';
import 'core/services/app_config_service.dart';
import 'core/theme/facebook_theme.dart';
import 'presentation/layouts/facebook_layout.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/providers/theme_provider.dart';

void main() {
  // 配置依赖注入
  configureDependencies();

  // 初始化应用配置服务
  getIt<AppConfigService>().init();

  runApp(
    ProviderScope(
      child: const InkboardApp(),
    ),
  );
}

class InkboardApp extends ConsumerWidget {
  const InkboardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider.notifier);

    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 12 Pro 尺寸
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: getIt<AppConfigService>().appName,
          theme: FacebookTheme.getLightTheme(),
          darkTheme: FacebookTheme.getDarkTheme(),
          themeMode: themeNotifier.toFlutterThemeMode(),
          home: const FacebookLayout(
            child: HomePage(),
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}