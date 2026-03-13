import '../entities/item.dart';
import '../repositories/trip_repository.dart';

class CreateItems {
  final TripRepository repository;

  CreateItems(this.repository);

  Future<void> call(List<Item> items) async {
    return await repository.createItems(items);
  }
}