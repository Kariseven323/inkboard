import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/di/service_locator.dart';
import '../../core/theme/facebook_colors.dart';
import '../../core/theme/facebook_sizes.dart';
import '../../core/theme/facebook_text_styles.dart';
import '../../domain/entities/diary_entry.dart';
import '../../domain/repositories/diary_entry_repository.dart';

class RecycleBinPage extends StatefulWidget {
  const RecycleBinPage({super.key});

  @override
  State<RecycleBinPage> createState() => _RecycleBinPageState();
}

class _RecycleBinPageState extends State<RecycleBinPage> {
  final repo = getIt<DiaryEntryRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FacebookColors.background,
      appBar: AppBar(
        backgroundColor: FacebookColors.primary,
        foregroundColor: Colors.white,
        title: const Text('回收站'),
      ),
      body: StreamBuilder<List<DiaryEntry>>(
        stream: repo.getDeletedDiaryEntries(),
        builder: (context, snapshot) {
          final items = snapshot.data ?? const [];
          if (items.isEmpty) {
            return Center(
              child: Text(
                '回收站空空如也',
                style: FacebookTextStyles.bodyMedium.copyWith(
                  color: FacebookColors.textSecondary,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(FacebookSizes.spacing16),
            itemBuilder: (context, index) {
              final e = items[index];
              return ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    FacebookSizes.radiusLarge,
                  ),
                  side: const BorderSide(color: FacebookColors.border),
                ),
                title: Text(e.title, style: FacebookTextStyles.bodyLarge),
                subtitle: Text(
                  e.excerpt,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Wrap(
                  spacing: FacebookSizes.spacing8,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        HapticFeedback.selectionClick();
                        await repo.restoreDiaryEntry(e.id!);
                        if (!context.mounted) return;
                        final messenger = ScaffoldMessenger.of(context);
                        messenger.showSnackBar(
                          const SnackBar(content: Text('已恢复')),
                        );
                      },
                      child: const Text('恢复'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('彻底删除？'),
                            content: const Text('此操作不可恢复，确定删除该日记？'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text(
                                  '删除',
                                  style: TextStyle(color: FacebookColors.error),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (ok == true) {
                          await repo.purgeDiaryEntry(e.id!);
                          if (!context.mounted) return;
                          final messenger2 = ScaffoldMessenger.of(context);
                          messenger2.showSnackBar(
                            const SnackBar(content: Text('已彻底删除')),
                          );
                        }
                      },
                      child: Text(
                        '彻底删除',
                        style: TextStyle(color: FacebookColors.error),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) =>
                SizedBox(height: FacebookSizes.spacing12),
            itemCount: items.length,
          );
        },
      ),
    );
  }
}
