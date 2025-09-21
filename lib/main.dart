import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/service_locator.dart';
import 'core/services/app_config_service.dart';
import 'core/theme/facebook_theme.dart';
import 'presentation/layouts/facebook_layout.dart';

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

class InkboardApp extends StatelessWidget {
  const InkboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 12 Pro 尺寸
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: getIt<AppConfigService>().appName,
          theme: FacebookTheme.getLightTheme(),
          darkTheme: FacebookTheme.getDarkTheme(),
          themeMode: ThemeMode.system,
          home: const FacebookLayout(
            child: HomePage(),
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appConfig = getIt<AppConfigService>();

    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '欢迎使用 ${appConfig.appName}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              '版本: ${appConfig.version}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 32.h),
            Container(
              padding: EdgeInsets.all(16.w),
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                'Sprint 1 任务完成情况：\n\n'
                '✅ 依赖注入框架配置完成\n'
                '✅ Riverpod状态管理集成\n'
                '✅ Facebook风格设计系统\n'
                '✅ 三栏布局框架实现\n'
                '⏳ 测试环境配置\n'
                '⏳ CI/CD流水线设置',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}