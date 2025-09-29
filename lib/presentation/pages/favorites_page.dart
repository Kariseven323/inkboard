import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/facebook_colors.dart';
import '../../core/theme/facebook_sizes.dart';
import '../providers/diary_provider.dart';
import '../../core/di/service_locator.dart';
import '../../domain/usecases/update_delete_diary_entry_usecase.dart';
import '../widgets/common/facebook_diary_card.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFavorites = ref.watch(favoriteDiaryEntriesProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FacebookColors.primary,
        foregroundColor: FacebookColors.textOnPrimary,
        title: const Text('收藏夹'),
      ),
      body: asyncFavorites.when(
        data: (entries) => entries.isEmpty
            ? const Center(child: Text('暂无收藏'))
            : ListView.separated(
                padding: EdgeInsets.all(FacebookSizes.spacing16),
                itemBuilder: (context, index) {
                  final e = entries[index];
                  return FacebookDiaryCard(
                    title: e.title,
                    content: e.content,
                    createdAt: e.createdAt,
                    tags: e.tags.map((t) => t.name).toList(),
                    isFavorite: e.isFavorite,
                    onTap: () {},
                    onFavoriteTap: () async {
                      await getIt<UpdateDiaryEntryUseCase>().toggleFavorite(
                        e.id!,
                      );
                    },
                    onEditTap: () {},
                    onDeleteTap: () {},
                    onShareTap: () {},
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: entries.length,
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
    );
  }
}
