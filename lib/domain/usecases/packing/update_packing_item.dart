import '../../repositories/trip_repository.dart';

class UpdatePackingItem {
  final TripRepository repository;
  UpdatePackingItem(this.repository);

  Future<void> call(String itemId, bool isPacked) => repository.updatePackingItem(itemId, isPacked);
}