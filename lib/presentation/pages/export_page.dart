import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/di/service_locator.dart';
import '../../core/theme/facebook_colors.dart';
import '../../core/theme/facebook_sizes.dart';
import '../../domain/entities/diary_entry.dart';
import '../../domain/repositories/diary_entry_repository.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({super.key});

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  String? _markdown;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FacebookColors.primary,
        foregroundColor: FacebookColors.textOnPrimary,
        title: const Text('导出数据 (Markdown)'),
        actions: [
          if (_markdown != null)
            IconButton(
              icon: const Icon(Icons.copy_all),
              tooltip: '复制到剪贴板',
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                await Clipboard.setData(ClipboardData(text: _markdown!));
                messenger.showSnackBar(
                  const SnackBar(content: Text('已复制到剪贴板')),
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: FacebookSizes.paddingAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilledButton.icon(
              onPressed: _loading ? null : _export,
              icon: const Icon(Icons.file_download),
              label: const Text('生成Markdown'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _markdown == null
                      ? const Center(child: Text('点击上方按钮生成导出内容'))
                      : SelectableText(_markdown!),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _export() async {
    setState(() => _loading = true);
    try {
      final repo = getIt<DiaryEntryRepository>();
      final entries = await repo.getAllDiaryEntries().first;
      _markdown = _buildMarkdown(entries);
    } catch (e) {
      _markdown = '# 导出失败\n\n$e';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _buildMarkdown(List<DiaryEntry> entries) {
    final buf = StringBuffer();
    buf.writeln('# 砚记导出');
    buf.writeln();
    for (final e in entries) {
      buf.writeln('---');
      buf.writeln('title: ${_escape(e.title)}');
      buf.writeln('date: ${e.createdAt.toIso8601String()}');
      buf.writeln('updated: ${e.updatedAt.toIso8601String()}');
      buf.writeln('favorite: ${e.isFavorite}');
      if (e.tags.isNotEmpty) {
        buf.writeln('tags: ${e.tags.map((t) => t.name).join(', ')}');
      }
      if (e.location != null && e.location!.isNotEmpty) {
        buf.writeln('location: ${_escape(e.location!)}');
      }
      if (e.weather != null && e.weather!.isNotEmpty) {
        buf.writeln('weather: ${_escape(e.weather!)}');
      }
      if (e.moodScore != null) {
        buf.writeln('mood: ${e.moodScore}');
      }
      buf.writeln('---');
      buf.writeln();
      buf.writeln(e.content);
      buf.writeln();
    }
    return buf.toString();
  }

  String _escape(String v) => v.replaceAll('\n', ' ').replaceAll('"', '\\"');
}
