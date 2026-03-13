import 'package:trip_packer/domain/repositories/trip_repository.dart';

class DeleteTripUseCase {
  final TripRepository repository;

  DeleteTripUseCase(this.repository);

  Future<void> execute(String tripId) {
    return repository.deleteTrip(tripId);
  }
}