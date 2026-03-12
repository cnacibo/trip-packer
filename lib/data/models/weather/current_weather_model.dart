import 'weather_condition_model.dart';

class CurrentWeatherModel {
  final DateTime dt;
  final DateTime? sunrise;
  final DateTime? sunset;
  final double temp;
  final double feelsLike;
  final int pressure;
  final int humidity;
  final double dewPoint;
  final double uvi;
  final int clouds;
  final int visibility;
  final double windSpeed;
  final int windDeg;
  final List<WeatherConditionModel> weather;

  CurrentWeatherModel({
    required this.dt,
    this.sunrise,
    this.sunset,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.uvi,
    required this.clouds,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.weather,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      dt: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      sunrise: json['sunrise'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['sunrise'] * 1000) 
          : null,
      sunset: json['sunset'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['sunset'] * 1000) 
          : null,
      temp: json['temp'].toDouble(),
      feelsLike: json['feels_like'].toDouble(),
      pressure: json['pressure'],
      humidity: json['humidity'],
      dewPoint: json['dew_point'].toDouble(),
      uvi: json['uvi'].toDouble(),
      clouds: json['clouds'],
      visibility: json['visibility'],
      windSpeed: json['wind_speed'].toDouble(),
      windDeg: json['wind_deg'],
      weather: List<WeatherConditionModel>.from(
          json['weather'].map((x) => WeatherConditionModel.fromJson(x))),
    );
  }
}