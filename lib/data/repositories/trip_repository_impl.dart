import 'package:drift/drift.dart';
import 'package:trip_packer/data/models/item_model.dart';
import 'package:trip_packer/data/models/trip_weather_forecast_model.dart';
import '../../domain/entities/trip.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/trip_weather_forecast.dart';
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
  Future<Trip> getTrip(String id) async {
    final query = _db.select(_db.trips)..where((t) => t.id.equals(id));
    final trip = await query.getSingleOrNull();
    if (trip == null) {
      throw Exception('Trip not found');
    }
    return trip.toDomain();
  }

  @override
  Future<void> createTrip(Trip trip) async {
    await _db.into(_db.trips).insert(trip.toCompanion());
  }

  @override
  Future<void> createItems(List<Item> items) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.items,
        items.map((i) => i.toCompanion()).toList(),
      );
    });
  }

  @override
  Stream<List<Item>> getPackingItemsForTrip(String tripId) {
    final query = _db.select(_db.items)..where((t) => t.tripId.equals(tripId));
    return query.watch().map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  @override
  Future<void> updatePackingItem(String itemId, bool isPacked) async {
    await (_db.update(_db.items)..where((t) => t.id.equals(itemId)))
        .write(db.ItemsCompanion(isPacked: Value(isPacked)));
  }

  @override
  Future<void> addForecastForTrip(List<TripWeatherForecast> forecast) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.tripWeather,
        forecast.map((i) => i.toCompanion()).toList(),
      );
    });
  }

  @override
  Future<List<TripWeatherForecast>> viewTripForecast(String tripId) async {
    final query = _db.select(_db.tripWeather)..where((t) => t.tripId.equals(tripId));
    final rows = await query.get(); 
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<void> deleteTrip(String tripId) async {
    await (_db.delete(_db.trips)..where((t) => t.id.equals(tripId))).go();
  }

}