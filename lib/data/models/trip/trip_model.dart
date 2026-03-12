import 'package:hive/hive.dart';
import '../weather/weather_model.dart';

enum TripType { beach, mountains, city, business }

@HiveType(typeId: 0)
class TripModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String destination;
  @HiveField(3)
  final DateTime startDate;
  @HiveField(4)
  final DateTime endDate;
  @HiveField(5)
  final TripType tripType;
  @HiveField(6)
  final WeatherModel? weather;

  TripModel({
    required this.id,
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.tripType,
    this.weather,
  });
}