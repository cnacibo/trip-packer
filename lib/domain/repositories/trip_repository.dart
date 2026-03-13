import 'package:trip_packer/domain/entities/trip.dart';
import 'package:trip_packer/domain/entities/item.dart';

abstract class TripRepository {
  Future<List<Trip>> getTrips();
  Future<Trip> getTrip(String id);
  Future<void> createTrip(Trip trip);
  Future<void> createItems(List<Item> items);
  Future<void> updatePackingItem(String itemId, bool isPacked);
  Stream<List<Item>> getPackingItemsForTrip(String tripId);
}