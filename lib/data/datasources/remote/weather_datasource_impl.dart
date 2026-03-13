import '../../models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'weather_datasource.dart';

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  static const _geoBaseUrl = 'http://api.openweathermap.org/geo/1.0/direct';
  static const _weatherBaseUrl = 'https://api.openweathermap.org/data/3.0/onecall/day_summary';
  final String? _apiKey;
  final http.Client _httpClient;

  WeatherRemoteDataSourceImpl({required http.Client httpClient, String? apiKey})
      : _httpClient = httpClient,
        _apiKey = apiKey;

  @override
  Future<List<WeatherModel>> getWeatherForCity(String cityName, DateTime startDate, DateTime endDate) async {
    try {
      final coords = await _getCoordinatesFromCity(cityName);
      final lat = coords.lat;
      final lon = coords.lon;

      int days = endDate.difference(startDate).inDays;
      if (days < 0) throw Exception('End date must be after start date');
      List<WeatherModel> weatherList = [];
      
      for (int i = 0; i <= days; i++) {
        DateTime currentDate = startDate.add(Duration(days: i));
        
        String formattedDate = currentDate.toIso8601String().split('T')[0];
        
        final uri = Uri.parse('$_weatherBaseUrl').replace(
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

  Future<({double lat, double lon})> _getCoordinatesFromCity(String cityName) async {
    final uri = Uri.parse(_geoBaseUrl).replace(
      queryParameters: {
        'q': cityName,
        'limit': '1',   
        'appid': _apiKey,
      },
    );

    final response = await _httpClient.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Geocoding failed: ${response.statusCode}\n'
        'Response: ${response.body}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body);
    if (data.isEmpty) {
      throw Exception('City "$cityName" not found');
    }

    final first = data.first;
    final double lat = first['lat']?.toDouble() ?? 0.0;
    final double lon = first['lon']?.toDouble() ?? 0.0;

    if (lat == 0.0 && lon == 0.0) {
      throw Exception('Invalid coordinates for city "$cityName"');
    }

    return (lat: lat, lon: lon);
  }
}
