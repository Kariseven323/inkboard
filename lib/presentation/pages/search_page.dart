import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/facebook_colors.dart';
import '../../core/theme/facebook_sizes.dart';
import '../../core/theme/facebook_text_styles.dart';
import '../../core/di/service_locator.dart';
import '../../domain/services/search_service.dart';
import '../../domain/usecases/search_diary_usecase.dart';
import '../../domain/entities/diary_entry.dart';
import '../widgets/common/facebook_diary_card.dart';
import '../../domain/usecases/update_delete_diary_entry_usecase.dart';

/// 搜索结果Provider（基于查询词）
final searchResultsProvider = FutureProvider.family<List<SearchResult>, String>((ref, query) async {
  final useCase = getIt<SearchDiaryUseCase>();
  final result = await useCase.globalSearch(query);
  return result.dataOrThrow;
});

/// 高级搜索结果Provider（基于参数）
final advancedSearchProvider = StreamProvider.family<List<DiaryEntry>, AdvancedSearchParams>((ref, params) {
  final useCase = getIt<SearchDiaryUseCase>();
  return useCase.advancedSearch(params);
});

class SearchPage extends ConsumerStatefulWidget {
  final String initialQuery;

  const SearchPage({super.key, this.initialQuery = ''});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late final TextEditingController _controller;
  bool _showAdvanced = false;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _onlyFavorite = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FacebookColors.primary,
        foregroundColor: FacebookColors.textOnPrimary,
        title: _buildSearchField(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: '高级筛选',
            onPressed: () => setState(() => _showAdvanced = !_showAdvanced),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showAdvanced) _buildAdvancedFilters(context),
          Expanded(
            child: query.isEmpty
                ? _buildEmptyState()
                : _buildResults(query),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: widget.initialQuery.isEmpty,
      decoration: const InputDecoration(
        hintText: '搜索日记与标签...',
        border: InputBorder.none,
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => setState(() {}),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildAdvancedFilters(BuildContext context) {
    return Container(
      padding: FacebookSizes.paddingAll,
      decoration: BoxDecoration(
        color: FacebookColors.surface,
        border: Border(
          bottom: BorderSide(color: FacebookColors.border, width: 1),
        ),
      ),
      child: Wrap(
        spacing: FacebookSizes.spacing12,
        runSpacing: FacebookSizes.spacing8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          FilterChip(
            selected: _onlyFavorite,
            onSelected: (v) => setState(() => _onlyFavorite = v),
            label: const Text('仅收藏'),
            selectedColor: FacebookColors.primary.withValues(alpha: 0.15),
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.date_range),
            label: Text(_dateRangeLabel()),
            onPressed: () async {
              final now = DateTime.now();
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(now.year - 5),
                lastDate: DateTime(now.year + 1),
                initialDateRange: (_startDate != null && _endDate != null)
                    ? DateTimeRange(start: _startDate!, end: _endDate!)
                    : null,
              );
              if (picked != null) {
                setState(() {
                  _startDate = picked.start;
                  _endDate = picked.end;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  String _dateRangeLabel() {
    if (_startDate == null || _endDate == null) return '选择日期范围';
    return '${_startDate!.toString().split(' ').first} ~ ${_endDate!.toString().split(' ').first}';
  }

  Widget _buildResults(String query) {
    if (_showAdvanced) {
      final params = AdvancedSearchParams(
        titleQuery: query,
        contentQuery: query,
        startDate: _startDate,
        endDate: _endDate,
        isFavorite: _onlyFavorite ? true : null,
      );
      final asyncEntries = ref.watch(advancedSearchProvider(params));
      return asyncEntries.when(
        data: (entries) => _buildDiaryEntries(entries),
        loading: () => _buildLoading(),
        error: (e, st) => _buildError(e.toString()),
      );
    }

    final asyncResults = ref.watch(searchResultsProvider(query));
    return asyncResults.when(
      data: (results) => _buildSearchResultsList(results),
      loading: () => _buildLoading(),
      error: (e, st) => _buildError(e.toString()),
    );
  }

  Widget _buildSearchResultsList(List<SearchResult> results) {
    if (results.isEmpty) return _buildEmptyList('没有找到匹配的结果');

    return ListView.separated(
      padding: FacebookSizes.paddingAll,
      itemBuilder: (context, index) {
        final r = results[index];
        switch (r.type) {
          case SearchResultType.diaryEntry:
            final entry = r.data as DiaryEntry;
            return _SearchResultDiaryCard(entry: entry, snippet: r.snippet);
          case SearchResultType.tag:
            final tag = r.data;
            return ListTile(
              leading: const Icon(Icons.local_offer_outlined),
              title: Text(tag.name),
              subtitle: Text(r.snippet),
            );
        }
      },
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: results.length,
    );
  }

  Widget _buildDiaryEntries(List<DiaryEntry> entries) {
    if (entries.isEmpty) return _buildEmptyList('没有符合条件的日记');

    return ListView(
      padding: EdgeInsets.all(FacebookSizes.spacing16),
      children: entries
          .map((e) => FacebookDiaryCard(
                title: e.title,
                content: e.content,
                createdAt: e.createdAt,
                tags: e.tags.map((t) => t.name).toList(),
                isFavorite: e.isFavorite,
                onTap: () {},
                onFavoriteTap: () {},
                onEditTap: () {},
                onDeleteTap: () {},
                onShareTap: () {},
              ))
          .toList(),
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());

  Widget _buildError(String error) => Center(
        child: Text(
          error,
          style: FacebookTextStyles.bodyMedium,
        ),
      );

  Widget _buildEmptyState() => Center(
        child: Text(
          '输入关键词开始搜索',
          style: FacebookTextStyles.bodyMedium.copyWith(color: FacebookColors.textSecondary),
        ),
      );

  Widget _buildEmptyList(String message) => Center(
        child: Padding(
          padding: FacebookSizes.paddingAll,
          child: Text(
            message,
            style: FacebookTextStyles.bodyMedium.copyWith(color: FacebookColors.textSecondary),
          ),
        ),
      );
}

/// 搜索结果中的日记卡片，附带片段
class _SearchResultDiaryCard extends StatelessWidget {
  final DiaryEntry entry;
  final String snippet;

  const _SearchResultDiaryCard({required this.entry, required this.snippet});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FacebookDiaryCard(
          title: entry.title,
          content: entry.content,
          createdAt: entry.createdAt,
          tags: entry.tags.map((t) => t.name).toList(),
          isFavorite: entry.isFavorite,
          onTap: () {},
          onFavoriteTap: () async {
            final useCase = getIt<UpdateDiaryEntryUseCase>();
            await useCase.toggleFavorite(entry.id!);
          },
          onEditTap: () {},
          onDeleteTap: () {},
          onShareTap: () {},
        ),
        Padding(
          padding: EdgeInsets.only(
            left: FacebookSizes.spacing8,
            right: FacebookSizes.spacing8,
            bottom: FacebookSizes.spacing8,
          ),
          child: _HighlightedText(snippet: snippet),
        ),
      ],
    );
  }
}

/// 简单的高亮文本渲染：将 **词** 渲染为加粗
class _HighlightedText extends StatelessWidget {
  final String snippet;
  const _HighlightedText({required this.snippet});

  @override
  Widget build(BuildContext context) {
    final parts = snippet.split('**');
    final spans = <TextSpan>[];
    for (var i = 0; i < parts.length; i++) {
      final isBold = i % 2 == 1;
      spans.add(TextSpan(
        text: parts[i],
        style: isBold
            ? const TextStyle(fontWeight: FontWeight.w600, color: FacebookColors.textPrimary)
            : const TextStyle(color: FacebookColors.textSecondary),
      ));
    }
    return RichText(text: TextSpan(style: FacebookTextStyles.bodySmall, children: spans));
  }
}
