import '../../domain/entities/trip.dart';
import '../datasources/local/trip_datasource.dart' as db; 
import 'package:drift/drift.dart';

extension TripMapper on db.Trip {
  Trip toDomain() {
    return Trip(
      id: id,
      name: name,
      destination: destination,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

extension TripCompanionMapper on Trip {
  db.TripsCompanion toCompanion() {
    return db.TripsCompanion(
      id: Value(id),
      name: Value(name),
      destination: Value(destination),
      startDate: Value(startDate),
      endDate: Value(endDate),
    );
  }
}