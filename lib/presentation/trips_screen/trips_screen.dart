import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_packer/presentation/trips_screen/trips_view_model.dart';
import 'package:trip_packer/presentation/create_trip/create_trip_screen.dart';
import 'trip_card.dart';
import '../auth/auth_screen.dart';

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tripsState = ref.watch(tripsViewModelProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateTripScreen()),
          );
          if (result == true) {
            ref.refresh(tripsViewModelProvider);
          }
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(tripsViewModelProvider.notifier).refresh(),
        color: theme.colorScheme.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              actions: [
                _LogoutButton(),
              ],
              expandedHeight: 100,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Мои путешествия',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary.withValues(alpha: 0.8),
                        theme.colorScheme.primary,
                      ],
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        right: -20,
                        top: -20,
                        child: Icon(
                          Icons.trip_origin,
                          size: 140,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      Positioned(
                        left: -30,
                        bottom: -30,
                        child: Icon(
                          Icons.map,
                          size: 180,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            tripsState.when(
              data: (trips) {
                if (trips.isEmpty) {
                  return SliverFillRemaining(
                    child: _buildEmptyState(theme),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final trip = trips[index];
                        return Dismissible(
                          key: Key(trip.id),
                          direction: DismissDirection.endToStart, 
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Удаление поездки'),
                                content: Text('Вы уверены, что хотите удалить "${trip.name}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(false),
                                    child: const Text('Отмена'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(true),
                                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                                    child: const Text('Удалить'),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (direction) async {
                            try {
                              await ref.read(tripsViewModelProvider.notifier).deleteTrip(trip.id);
                              if (context.mounted) {
                                final messenger = ScaffoldMessenger.of(context);
                                messenger.showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 3),
                                    content: Text('Поездка "${trip.name}" удалена'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Ошибка при удалении: $e'),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          },
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 300 + index * 50),
                            opacity: 1.0,
                            child: TripCard(trip: trip),
                          ),
                        );
                      },
                      childCount: trips.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Ошибка загрузки: $err',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.luggage,
              size: 120,
              color: theme.colorScheme.primary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 24),
            Text(
              'У вас пока нет поездок',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Нажмите на кнопку "+", чтобы спланировать своё следующее путешествие',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.logout, color: Colors.white),
      onPressed: () => _showLogoutDialog(context, ref),
      tooltip: 'Выйти',
    );
  }

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      final success = await ref.read(tripsViewModelProvider.notifier).logout();
      if (success && context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка при выходе')),
        );
      }
    }
  }
}

