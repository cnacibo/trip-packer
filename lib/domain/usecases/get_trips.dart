import 'package:trip_packer/domain/entities/trip.dart';
import 'package:trip_packer/domain/repositories/trip_repository.dart';

class GetTrips {
  final TripRepository repository;
  GetTrips(this.repository);

  Future<List<Trip>> call() => repository.getTrips();
}