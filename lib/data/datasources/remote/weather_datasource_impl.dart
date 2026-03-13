import '../../models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'weather_datasource.dart';
import 'package:geocoding/geocoding.dart';

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  static const _baseUrl = 'https://api.openweathermap.org/data/3.0/onecall/day_summary';
  final String? _apiKey;
  final http.Client _httpClient;

  WeatherRemoteDataSourceImpl({required http.Client httpClient, String? apiKey})
      : _httpClient = httpClient,
        _apiKey = apiKey;

  @override
  Future<List<WeatherModel>> getWeatherForCity(String cityName, DateTime startDate, DateTime endDate) async {
    try {
      List<Location> locations = await locationFromAddress(cityName);
      if (locations.isEmpty) throw Exception('Город не найден');
      double lat = locations.first.latitude;
      double lon = locations.first.longitude;

      int days = endDate.difference(startDate).inDays;
      if (days < 0) throw Exception('End date must be after start date');
      List<WeatherModel> weatherList = [];
      
      for (int i = 0; i <= days; i++) {
        DateTime currentDate = startDate.add(Duration(days: i));
        
        String formattedDate = currentDate.toIso8601String().split('T')[0];
        
        final uri = Uri.parse('$_baseUrl').replace(
          queryParameters: {
            'lat': lat.toString(),
            'lon': lon.toString(),
            'date': formattedDate,
            'appid': _apiKey,
            'units': 'metric',
            'lang': 'ru',
          },
        );

        final response = await _httpClient.get(uri);

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          weatherList.add(WeatherModel.fromJson(data));
        } else {
          throw Exception(
            'Failed to load weather: ${response.statusCode}\n'
            'Response: ${response.body}\n'
          );
        }
      }
       if (weatherList.isEmpty) {
        throw Exception('No weather data found for the specified date range');
      }
      return weatherList;
      
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
