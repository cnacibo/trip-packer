import 'package:trip_packer/domain/entities/trip.dart';

abstract class TripRepository {
  Future<List<Trip>> getTrips();
  Future<void> createTrip(Trip trip);
}