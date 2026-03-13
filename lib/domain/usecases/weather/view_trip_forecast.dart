import '../../repositories/trip_repository.dart';
import '../../entities/trip_weather_forecast.dart';

class ViewTripForecast {
  final TripRepository repository;

  ViewTripForecast(this.repository);

  Future<List<TripWeatherForecast>> call(String tripId) async {
    return await repository.viewTripForecast(tripId);
  }
}