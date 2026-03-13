import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_packer/presentation/trip_detail/trip_detail_view_model.dart';
import 'package:trip_packer/presentation/trip_detail/packing_tab.dart';
import 'package:trip_packer/presentation/trip_detail/weather_tab.dart';

class TripDetailScreen extends ConsumerWidget {
  final String tripId;

  const TripDetailScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripState = ref.watch(tripDetailProvider(tripId));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: tripState.when(
            data: (trip) => Text(trip?.name ?? 'Детали'),
            loading: () => Text('Загрузка...'),
            error: (_, __) => Text('Ошибка'),
          ),
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.checklist), text: 'Вещи'),
            Tab(icon: Icon(Icons.schedule), text: 'Погода'),
          ]),
        ),
        body: TabBarView(
          children: [
            PackingTab(tripId: tripId),
            WeatherTab(tripId: tripId),
          ],
        ),
      ),
    );
  }
}