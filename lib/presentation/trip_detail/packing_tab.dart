import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_packer/presentation/trip_detail/trip_detail_view_model.dart';

class PackingTab extends ConsumerWidget {
  final String tripId;

  const PackingTab({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(tripDetailProvider(tripId).notifier);
    return StreamBuilder<List>(
      stream: viewModel.getPackingItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return const Center(child: Text('Нет вещей'));
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return CheckboxListTile(
              title: Text(item.name),
              subtitle: Text(item.category.toString().split('.').last), 
              value: item.isPacked,
              onChanged: (value) async {
                await viewModel.togglePacked(item.id, value!);
              },
            );
          },
        );
      }
    );
  }
}