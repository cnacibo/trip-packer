import '../repositories/weather_repository.dart';
import '../entities/weather.dart';

class GetWeatherForecast {
  final WeatherRepository weatherRepository;

  GetWeatherForecast(this.weatherRepository);

  Future<List<Weather>> call(String cityName, DateTime start, DateTime end) async {
    return await weatherRepository.getWeatherForecast(cityName, start, end);
  }
}