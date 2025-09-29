import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/service_locator.dart';
import '../../core/theme/facebook_colors.dart';
import '../../core/theme/facebook_sizes.dart';
import '../../core/theme/facebook_text_styles.dart';
import '../../domain/entities/tag.dart';
import '../../domain/usecases/tag_management_usecase.dart';

final _tagQueryProvider = StateProvider<String>((ref) => '');

final tagsStreamProvider = StreamProvider<List<Tag>>((ref) {
  final query = ref.watch(_tagQueryProvider);
  final useCase = getIt<TagManagementUseCase>();
  if (query.trim().isEmpty) {
    return useCase.getAllTags();
  }
  return useCase.searchTags(query.trim());
});

class TagManagementPage extends ConsumerWidget {
  const TagManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTags = ref.watch(tagsStreamProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FacebookColors.primary,
        foregroundColor: FacebookColors.textOnPrimary,
        title: const Text('标签管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '新建标签',
            onPressed: () => _showCreateTagDialog(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(ref),
          Expanded(
            child: asyncTags.when(
              data: (tags) => _buildTagList(context, ref, tags),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text(e.toString())),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(WidgetRef ref) {
    return Container(
      padding: FacebookSizes.paddingAll,
      child: TextField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: '搜索标签...',
          border: OutlineInputBorder(),
          isDense: true,
        ),
        onChanged: (v) => ref.read(_tagQueryProvider.notifier).state = v,
      ),
    );
  }

  Widget _buildTagList(BuildContext context, WidgetRef ref, List<Tag> tags) {
    if (tags.isEmpty) {
      return Center(
        child: Text(
          '暂无标签',
          style: FacebookTextStyles.bodyMedium.copyWith(
            color: FacebookColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(FacebookSizes.spacing16),
      itemBuilder: (context, index) {
        final t = tags[index];
        return ListTile(
          leading: _ColorDot(hex: t.color),
          title: Text(t.name),
          subtitle: t.description != null ? Text(t.description!) : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('使用 ${t.usageCount}'),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: t.isDefault
                    ? null
                    : () => _deleteTag(context, t.id!),
                tooltip: t.isDefault ? '系统预设不可删' : '删除',
              ),
            ],
          ),
          onTap: () => _showEditTagDialog(context, t),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemCount: tags.length,
    );
  }

  Future<void> _showCreateTagDialog(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final colorController = TextEditingController(text: '#1877F2');
    final descController = TextEditingController();
    final useCase = getIt<TagManagementUseCase>();

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新建标签'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: '名称'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: colorController,
              decoration: const InputDecoration(labelText: '颜色(HEX)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: '描述(可选)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('创建'),
          ),
        ],
      ),
    );

    if (ok == true) {
      final result = await useCase.createTag(
        CreateTagParams(
          name: nameController.text,
          color: colorController.text,
          description: descController.text.isEmpty ? null : descController.text,
        ),
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.isSuccess ? '标签已创建' : (result.error ?? '创建失败')),
          backgroundColor: result.isSuccess
              ? FacebookColors.success
              : FacebookColors.error,
        ),
      );
    }
  }

  Future<void> _showEditTagDialog(BuildContext context, Tag tag) async {
    final nameController = TextEditingController(text: tag.name);
    final colorController = TextEditingController(text: tag.color);
    final descController = TextEditingController(text: tag.description ?? '');
    final useCase = getIt<TagManagementUseCase>();

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑标签'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: '名称'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: colorController,
              decoration: const InputDecoration(labelText: '颜色(HEX)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: '描述(可选)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('保存'),
          ),
        ],
      ),
    );

    if (ok == true) {
      final result = await useCase.updateTag(
        UpdateTagParams(
          id: tag.id!,
          name: nameController.text,
          color: colorController.text,
          description: descController.text.isEmpty ? null : descController.text,
        ),
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.isSuccess ? '标签已更新' : (result.error ?? '更新失败')),
          backgroundColor: result.isSuccess
              ? FacebookColors.success
              : FacebookColors.error,
        ),
      );
    }
  }

  Future<void> _deleteTag(BuildContext context, int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除标签'),
        content: const Text('确定删除该标签？此操作不可恢复'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (ok == true) {
      final result = await getIt<TagManagementUseCase>().deleteTag(id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.isSuccess ? '已删除' : (result.error ?? '删除失败')),
          backgroundColor: result.isSuccess
              ? FacebookColors.success
              : FacebookColors.error,
        ),
      );
    }
  }
}

class _ColorDot extends StatelessWidget {
  final String hex;
  const _ColorDot({required this.hex});

  @override
  Widget build(BuildContext context) {
    Color color;
    try {
      final value = int.parse(hex.substring(1), radix: 16) | 0xFF000000;
      color = Color(value);
    } catch (_) {
      color = FacebookColors.primary;
    }

    return CircleAvatar(radius: 10, backgroundColor: color);
  }
}
