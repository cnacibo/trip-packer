import 'package:trip_packer/domain/entities/trip.dart';
import 'package:trip_packer/domain/entities/item.dart';
import '../entities/trip_weather_forecast.dart';

abstract class TripRepository {
  Future<List<Trip>> getTrips();
  Future<Trip> getTrip(String id);
  Future<void> createTrip(Trip trip);
  Future<void> createItems(List<Item> items);
  Future<void> updatePackingItem(String itemId, bool isPacked);
  Stream<List<Item>> getPackingItemsForTrip(String tripId);
  Future<void> addForecastForTrip(List<TripWeatherForecast> forecast);
  Future<List<TripWeatherForecast>> viewTripForecast(String tripId);
}