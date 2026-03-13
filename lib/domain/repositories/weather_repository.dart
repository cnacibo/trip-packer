import '../entities/weather.dart';

abstract class WeatherRepository {
  Future<List<Weather>> getWeatherForecast(String cityName, DateTime start, DateTime end);
}
