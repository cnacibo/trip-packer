import '../../entities/item.dart';
import '../../repositories/trip_repository.dart';

class GetPackingItems {
  final TripRepository repository;
  GetPackingItems(this.repository);

  Stream<List<Item>> call(String tripId) => repository.getPackingItemsForTrip(tripId);
}