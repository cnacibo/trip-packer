import 'package:hive_ce/hive_ce.dart';
import 'package:trip_packer/data/models/trip_model.dart';

abstract class TripLocalDataSource {
  Future<void> initHive();
  Box<TripModel> get tripBox;
  Future<List<TripModel>> getAllTrips();
  Future<void> addTrip(TripModel model);
}

class TripLocalDataSourceImpl implements TripLocalDataSource {
  static const String boxName = 'trips_box';

  @override
  Future<void> initHive() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TripModelAdapter());
    }
    await Hive.openBox<TripModel>(boxName);
  }

  @override
  Box<TripModel> get tripBox => Hive.box<TripModel>(boxName);

@override 
  Future<List<TripModel>> getAllTrips() async {
    final b = tripBox;
    return b.values.toList();
  }

  @override
  Future<void> addTrip(TripModel model) async {
    await tripBox.put(model.id, model);
  }

}