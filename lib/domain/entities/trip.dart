import 'package:equatable/equatable.dart';

class Trip {
  final String id;
  final String name;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;

  Trip({
    required this.id,
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [id, name, destination, startDate, endDate];
}