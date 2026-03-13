import 'package:equatable/equatable.dart';

enum TripType { beach, mountains, city, business, other }

class Trip {
  final String id;
  final String name;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final TripType tripType;

  Trip({
    required this.id,
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.tripType,
  });

  @override
  List<Object?> get props => [id, name, destination, startDate, endDate];
}