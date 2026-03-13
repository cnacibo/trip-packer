import 'package:trip_packer/domain/entities/trip.dart';
import 'package:trip_packer/domain/repositories/trip_repository.dart';

class CreateTrip {
  final TripRepository repository;

  CreateTrip(this.repository);

  Future<void> call(Trip trip) async {
    return repository.createTrip(trip);
  }
}