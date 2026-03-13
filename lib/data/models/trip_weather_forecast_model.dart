import '../../domain/entities/trip_weather_forecast.dart';
import 'package:drift/drift.dart';
import '../datasources/local/trip_datasource.dart' as db; 

extension TripWeatherForecastMapper on db.TripWeatherData {
  TripWeatherForecast toDomain() {
    return TripWeatherForecast(
      id: id,
      tripId: tripId,
      date: date,
      temperatureAfternoon: temperatureAfternoon,
      precipitation: precipitation,
      cloudCover: cloudCover,
    );
  }
}

extension TripWeatheForecastrMapper on TripWeatherForecast {
  db.TripWeatherCompanion toCompanion() {
    return db.TripWeatherCompanion(
      id: Value(id),
      tripId: Value(tripId),
      date: Value(date),
      temperatureAfternoon: Value(temperatureAfternoon),
      precipitation: Value(precipitation),
      cloudCover: Value(cloudCover),
    );
  }
}