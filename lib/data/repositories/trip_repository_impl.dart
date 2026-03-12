import 'package:trip_packer/data/datasources/trip_local_datasource.dart';
import 'package:trip_packer/data/models/trip_model.dart';
import 'package:trip_packer/domain/entities/trip.dart';
import 'package:trip_packer/domain/repositories/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final TripLocalDataSource localDataSource;

  TripRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Trip>> getTrips() async {
    final models = await localDataSource.getAllTrips();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> createTrip(Trip trip) async {
    final model = TripModel.fromEntity(trip);
    await localDataSource.addTrip(model);
  }

}