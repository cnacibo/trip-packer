import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_packer/domain/entities/trip.dart';
import 'package:trip_packer/domain/usecases/get_trips.dart';
import 'package:trip_packer/domain/usecases/log_out_usecase.dart';
import 'package:trip_packer/core/injection.dart';
import 'package:trip_packer/core/analytics/analytics_service.dart';
import 'package:trip_packer/domain/usecases/delete_trip_usecase.dart';

final tripsViewModelProvider = NotifierProvider<TripsViewModel, AsyncValue<List<Trip>>>(() {
  return TripsViewModel();
});

class TripsViewModel extends Notifier<AsyncValue<List<Trip>>> {
  late final GetTrips _getTrips = getIt<GetTrips>(); 
  late final LogOutUseCase _logoutUseCase = getIt<LogOutUseCase>();
  late final DeleteTripUseCase _deleteTripUseCase = getIt<DeleteTripUseCase>();
  late final _analytics = getIt<AnalyticsService>();

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

  Future<bool> logout() async {
    try {
      final result = await _logoutUseCase.execute();
      if (result) {
        await _analytics.logLogout();
      } 
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteTrip(String tripId) async {
    try {
      await _deleteTripUseCase.execute(tripId);
      state.whenData((trips) {
        final updated = trips.where((t) => t.id != tripId).toList();
        state = AsyncValue.data(updated);
      });
    } catch (e) {
      throw Exception("Error: ${e.toString()}");
    }
  }
}