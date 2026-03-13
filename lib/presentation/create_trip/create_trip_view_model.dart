import 'package:riverpod/riverpod.dart';
import 'package:trip_packer/domain/usecases/create_trip.dart';
import 'package:trip_packer/domain/usecases/create_items.dart';
import 'package:trip_packer/domain/usecases/get_weather_forecast.dart';
import 'package:trip_packer/core/injection.dart';
import 'package:trip_packer/domain/entities/trip.dart';
import 'package:uuid/uuid.dart';
import 'package:trip_packer/core/utils/packing_list_generator.dart';
import 'package:trip_packer/domain/entities/trip_weather_forecast.dart';
import 'package:trip_packer/domain/usecases/add_forecast_for_trip.dart';

final createTripViewModelProvider =
    NotifierProvider<CreateTripViewModel, AsyncValue<void>>(
  CreateTripViewModel.new,
);


class CreateTripViewModel extends Notifier<AsyncValue<void>> {
  late final CreateTrip _createTrip = getIt<CreateTrip>(); 
  late final CreateItems _createItems = getIt<CreateItems>();
  late final GetWeatherForecast _getWeatherForecast = getIt<GetWeatherForecast>();
  late final AddForecastForTrip _addForecastForTrip = getIt<AddForecastForTrip>();
  final _uuid = const Uuid();

  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<bool> submitTrip(String name, String destination, DateTime start, DateTime end, TripType type) async {
    state = const AsyncValue.loading();
    try {
      final tripId = _uuid.v4();

      final forecast = await _getWeatherForecast(destination, start, end);

      final items = PackingListGenerator.generate(
        tripId: tripId,
        tripType: type,
        forecast: forecast,
      );

      final trip = Trip(
        id: tripId,
        name: name,
        destination: destination,
        startDate: start,
        endDate: end,
        tripType: type,
      );
      await _createTrip(trip);
      await _createItems(items);

      final forecastEntities = forecast.map((w) => TripWeatherForecast(
        id: _uuid.v4(),
        tripId: tripId,
        date: w.date,
        temperatureAfternoon: w.temperatureAfternoon,
        precipitation: w.precipitation,
        cloudCover: w.cloudCover,
      )).toList();

      await _addForecastForTrip(forecastEntities);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}
