import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_packer/domain/entities/item.dart';
import 'package:trip_packer/presentation/trip_detail/trip_detail_view_model.dart';

class PackingTab extends ConsumerWidget {
  final String tripId;

  const PackingTab({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final viewModel = ref.watch(tripDetailProvider(tripId).notifier);

    return StreamBuilder<List<Item>>(
      stream: viewModel.getPackingItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: colorScheme.error.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Не удалось загрузить вещи',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return _buildEmptyState(theme, colorScheme);
        }

        final grouped = _groupByCategory(items);
        final categories = grouped.keys.toList()
          ..sort((a, b) => a.index.compareTo(b.index)); 

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = categories[index];
                    final categoryItems = grouped[category]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 16, bottom: 8),
                          child: Row(
                            children: [
                              Icon(
                                _getIconForCategory(category),
                                size: 20,
                                color: _getColorForCategory(category, colorScheme),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _getCategoryName(category),
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...categoryItems.map((item) => _buildItemCard(item, viewModel, theme, colorScheme)),
                      ],
                    );
                  },
                  childCount: categories.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildItemCard(Item item, TripDetailViewModel viewModel, ThemeData theme, ColorScheme colorScheme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: item.isPacked
            ? colorScheme.primary.withValues(alpha: 0.05)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isPacked
              ? colorScheme.primary.withValues(alpha: 0.3)
              : colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => viewModel.togglePacked(item.id, !item.isPacked),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getColorForCategory(item.category, colorScheme).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconForCategory(item.category),
                    size: 20,
                    color: _getColorForCategory(item.category, colorScheme),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          decoration: item.isPacked ? TextDecoration.lineThrough : null,
                          color: item.isPacked
                              ? colorScheme.onSurface.withValues(alpha: 0.6)
                              : colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getCategoryName(item.category),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => viewModel.togglePacked(item.id, !item.isPacked),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: item.isPacked ? colorScheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: item.isPacked ? colorScheme.primary : colorScheme.outline,
                        width: 2,
                      ),
                    ),
                    child: item.isPacked
                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 100,
              color: colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Список вещей пуст',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Добавьте предметы, которые нужно взять с собой',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Map<ItemCategory, List<Item>> _groupByCategory(List<Item> items) {
    final map = <ItemCategory, List<Item>>{};
    for (var item in items) {
      map.putIfAbsent(item.category, () => []).add(item);
    }
    return map;
  }

  String _getCategoryName(ItemCategory category) {
    switch (category) {
      case ItemCategory.clothing:
        return 'Одежда';
      case ItemCategory.electronics:
        return 'Электроника';
      case ItemCategory.documents:
        return 'Документы';
      case ItemCategory.toiletries:
        return 'Гигиена';
      case ItemCategory.other:
        return 'Прочее';
    }
  }

  IconData _getIconForCategory(ItemCategory category) {
    switch (category) {
      case ItemCategory.clothing:
        return Icons.checkroom;
      case ItemCategory.electronics:
        return Icons.electrical_services;
      case ItemCategory.documents:
        return Icons.description;
      case ItemCategory.toiletries:
        return Icons.spa;
      case ItemCategory.other:
        return Icons.category;
    }
  }

  Color _getColorForCategory(ItemCategory category, ColorScheme colorScheme) {
    switch (category) {
      case ItemCategory.clothing:
        return const Color(0xFF4A90E2); 
      case ItemCategory.electronics:
        return const Color(0xFF2C3E50); 
      case ItemCategory.documents:
        return const Color(0xFF3498DB);
      case ItemCategory.toiletries:
        return const Color(0xFF1ABC9C); 
      case ItemCategory.other:
        return const Color(0xFF95A5A6);
    }
  }
}