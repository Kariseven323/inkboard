import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/facebook_colors.dart';
import '../../core/theme/facebook_sizes.dart';
import '../../core/theme/facebook_text_styles.dart';
import '../providers/theme_provider.dart';
import '../providers/settings_provider.dart';
import 'export_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final textScale = ref.watch(textScaleProvider);

    return Scaffold(
      backgroundColor: FacebookColors.background,
      appBar: AppBar(
        backgroundColor: FacebookColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('设置'),
      ),
      body: ListView(
        padding: EdgeInsets.all(FacebookSizes.spacing16),
        children: [
          _sectionTitle('外观'),
          _card(
            children: [
              ListTile(
                title: const Text('主题模式'),
                subtitle: Text(_displayTheme(themeMode)),
                trailing: SegmentedButton<AppThemeMode>(
                  segments: const [
                    ButtonSegment(value: AppThemeMode.system, icon: Icon(Icons.brightness_auto)),
                    ButtonSegment(value: AppThemeMode.light, icon: Icon(Icons.light_mode)),
                    ButtonSegment(value: AppThemeMode.dark, icon: Icon(Icons.dark_mode)),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (s) {
                    HapticFeedback.selectionClick();
                    ref.read(themeProvider.notifier).setThemeMode(s.first);
                  },
                ),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('字体大小'),
                subtitle: Text('当前：${textScale.toStringAsFixed(2)}x'),
                contentPadding: EdgeInsets.only(
                  left: FacebookSizes.spacing16,
                  right: FacebookSizes.spacing8,
                  top: FacebookSizes.spacing8,
                  bottom: FacebookSizes.spacing4,
                ),
                trailing: SizedBox(
                  width: 200,
                  child: Slider(
                    value: textScale,
                    min: 0.8,
                    max: 1.6,
                    divisions: 8,
                    label: '${textScale.toStringAsFixed(2)}x',
                    onChanged: (v) {
                      HapticFeedback.selectionClick();
                      ref.read(textScaleProvider.notifier).set(v);
                    },
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: FacebookSizes.spacing16),
          _sectionTitle('数据'),
          _card(
            children: [
              ListTile(
                leading: const Icon(Icons.file_upload_outlined),
                title: const Text('导出日记'),
                subtitle: const Text('导出为Markdown或JSON'),
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ExportPage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _displayTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return '跟随系统';
      case AppThemeMode.light:
        return '浅色模式';
      case AppThemeMode.dark:
        return '深色模式';
    }
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: FacebookSizes.spacing8),
      child: Text(
        title,
        style: FacebookTextStyles.subtitle1.copyWith(
          color: FacebookColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Card(
      elevation: FacebookSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FacebookSizes.radiusLarge),
        side: const BorderSide(color: FacebookColors.border),
      ),
      child: Column(children: children),
    );
  }
}

