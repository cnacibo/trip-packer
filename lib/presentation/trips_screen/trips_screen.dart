import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_packer/presentation/trips_screen/trips_view_model.dart';
import 'package:trip_packer/presentation/create_trip/create_trip_screen.dart';
import 'package:trip_packer/presentation/trip_detail/trip_detail_screen.dart';

class TripsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsState = ref.watch(tripsViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Мои поездки')),
      body: tripsState.when(
        data: (trips) {
          if (trips.isEmpty) {
            return const Center(child: Text('У вас пока нет поездок'));
          }
          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return ListTile(
                title: Text(trip.name),
                subtitle: Text('${trip.destination} · ${trip.startDate.day}.${trip.startDate.month}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TripDetailScreen(tripId: trip.id),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Ошибка: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateTripScreen()),
          );
        
          if (result == true) {
            ref.refresh(tripsViewModelProvider);
          }
        },
      ),
    );
  }
}