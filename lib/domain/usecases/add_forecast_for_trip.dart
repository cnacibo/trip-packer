import '../repositories/trip_repository.dart';
import '../entities/trip_weather_forecast.dart';

class AddForecastForTrip {
  final TripRepository repository;

  AddForecastForTrip(this.repository);

  Future<void> call(List<TripWeatherForecast> forecast) async {
    return await repository.addForecastForTrip(forecast);
  }
}