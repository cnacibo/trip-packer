import '../../domain/entities/weather.dart';
class WeatherModel extends Weather {
  WeatherModel({
    required super.date,
    required super.temperatureMax,
    required super.temperatureMin,
    required super.temperatureAfternoon,

    required super.windSpeed,

    required super.pressure,
    required super.humidity,
    required super.precipitation,
    required super.cloudCover,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['date'] as String);

    final temperatureMax =
        (json['temperature']?['max'] as num?)?.toDouble() ?? 0.0;
    
    final temperatureMin =
        (json['temperature']?['min'] as num?)?.toDouble() ?? 0.0;

    final temperatureAfternoon =
        (json['temperature']?['afternoon'] as num?)?.toDouble() ?? 0.0;

    final windSpeed =
        (json['wind']?['max']?['speed'] as num?)?.toDouble() ?? 0.0;

    final pressure = json['pressure']?['afternoon'] as int? ?? 0;

    final humidity = json['humidity']?['afternoon'] as int? ?? 0;

    final precipitation = json['precipitation']?['total'] as int? ?? 0;

    final cloudCover = json['cloud_cover']?['afternoon'] as int? ?? 0;
    

    return WeatherModel(
      date: date,
      temperatureMax: temperatureMax,
      temperatureMin: temperatureMin,
      temperatureAfternoon: temperatureAfternoon,
      windSpeed: windSpeed,
      pressure: pressure,
      humidity: humidity,
      precipitation: precipitation,
      cloudCover: cloudCover,
    );
  }
}