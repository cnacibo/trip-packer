import 'current_weather_model.dart';

class WeatherModel {
  final double? lat;
  final double? lon;
  final String? timezone;
  final int? timezoneOffset;
  final CurrentWeatherModel? data;

  WeatherModel({
    this.lat,
    this.lon,
    this.timezone,
    this.timezoneOffset,
    this.data,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      lat: json['lat']?.toDouble(),
      lon: json['lon']?.toDouble(),
      timezone: json['timezone'],
      timezoneOffset: json['timezone_offset'],
      data: json['data'] != null ? CurrentWeatherModel.fromJson(json['data']) : null,
    );
  }
}