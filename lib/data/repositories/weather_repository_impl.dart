import '../../domain/repositories/weather_repository.dart';
import '../models/weather_model.dart';
import '../datasources/remote/weather_datasource.dart';

class WeatherRepositoryImpl implements WeatherRepository {

  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<WeatherModel>> getWeatherForecast(String cityName, DateTime start, DateTime end) async {
    try {
      final List<WeatherModel> forecart = await remoteDataSource.getWeatherForCity(cityName, start,  end);
      return forecart; 
    } catch (e) {
      throw Exception('Failed to get weather: $e');
    }

  }

}