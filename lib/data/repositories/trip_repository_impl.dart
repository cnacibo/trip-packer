import '../../domain/entities/trip.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/local/trip_datasource.dart' as db;
import '../models/trip_model.dart';

class TripRepositoryImpl implements TripRepository {
  final db.AppDatabase _db;

  TripRepositoryImpl(this._db);

  @override
  Future<List<Trip>> getTrips() async {
    final trips = await _db.select(_db.trips).get();
    return trips.map((t) => t.toDomain()).toList();
  }

  @override
  Future<void> createTrip(Trip trip) async {
    await _db.into(_db.trips).insert(trip.toCompanion());
  }

}