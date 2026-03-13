import '../repositories/weather_repository.dart';
import '../entities/weather.dart';

class AddForecastForTrip {
  final WeatherRepository weatherRepository;

  AddForecastForTrip(this.weatherRepository);

  Future<List<Weather>> call(String cityName, DateTime start, DateTime end) async {
    return await weatherRepository.getWeatherForecast(cityName, start, end);
  }
}