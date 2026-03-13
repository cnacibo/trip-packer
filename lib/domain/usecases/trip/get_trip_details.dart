import '../../entities/trip.dart';
import '../../repositories/trip_repository.dart';

class GetTripDetails {
  final TripRepository repository;
  GetTripDetails(this.repository);

  Future<Trip?> call(String id) => repository.getTrip(id);
}