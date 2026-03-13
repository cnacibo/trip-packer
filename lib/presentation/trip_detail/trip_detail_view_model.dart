import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_packer/domain/entities/trip.dart';
import 'package:trip_packer/domain/entities/item.dart';
import 'package:trip_packer/domain/entities/trip_weather_forecast.dart';
import 'package:trip_packer/domain/usecases/get_trip_details.dart';
import 'package:trip_packer/domain/usecases/get_packing_items.dart';
import 'package:trip_packer/domain/usecases/update_packing_item.dart';
import 'package:trip_packer/domain/usecases/view_trip_forecast.dart';
import 'package:trip_packer/core/injection.dart';

final tripDetailProvider = NotifierProvider.family<TripDetailViewModel, AsyncValue<Trip?>, String>(
  (tripId) => TripDetailViewModel(tripId), 
);

class TripDetailViewModel extends Notifier<AsyncValue<Trip?>> {
  final String tripId;
  late final GetTripDetails _getTripDetails = getIt<GetTripDetails>();
  late final GetPackingItems _getPackingItems = getIt<GetPackingItems>();
  late final UpdatePackingItem _updatePackingItem = getIt<UpdatePackingItem>();
  late final ViewTripForecast _viewTripForecast = getIt<ViewTripForecast>();

  TripDetailViewModel(this.tripId);

  @override
  AsyncValue<Trip?> build() {
    loadTrip();
    return const AsyncValue.loading();
  }

  Future<void> loadTrip() async {
    try {
      final trip = await _getTripDetails(tripId);
      state = AsyncValue.data(trip);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Для списка вещей
  Stream<List<Item>> getPackingItems() {
    return _getPackingItems(tripId);
  }
  
  Future<void> togglePacked(String itemId, bool packed) async {
    await _updatePackingItem(itemId, packed);
  }

  // Для погоды
  Future<List<TripWeatherForecast>> viewTripForecast() async  {
    return await _viewTripForecast(tripId);
  }
}