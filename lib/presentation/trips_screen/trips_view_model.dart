import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_packer/domain/entities/trip.dart';
import 'package:trip_packer/domain/usecases/get_trips.dart';
import 'package:trip_packer/core/injection.dart';

final tripsViewModelProvider = NotifierProvider<TripsViewModel, AsyncValue<List<Trip>>>(() {
  return TripsViewModel();
});

class TripsViewModel extends Notifier<AsyncValue<List<Trip>>> {
  late final GetTrips _getTrips = getIt<GetTrips>(); 

  @override
  AsyncValue<List<Trip>> build() {
    loadTrips(); 
    return const AsyncValue.loading();
  }

  Future<void> loadTrips() async {
    try {
      final trips = await _getTrips();
      state = AsyncValue.data(trips);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() => loadTrips();
}