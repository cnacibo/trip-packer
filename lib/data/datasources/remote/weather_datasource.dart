import '../../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<List<WeatherModel>> getWeatherForCity(String cityName, DateTime startDate, DateTime endDate);
}