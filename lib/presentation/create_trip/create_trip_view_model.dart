import 'package:riverpod/riverpod.dart';
import 'package:trip_packer/domain/usecases/create_trip.dart';
import 'package:trip_packer/domain/usecases/create_items.dart';
import 'package:trip_packer/core/injection.dart';
import 'package:trip_packer/domain/entities/trip.dart';
import 'package:uuid/uuid.dart';
import 'package:trip_packer/core/utils/packing_list_generator.dart';

final createTripViewModelProvider =
    NotifierProvider<CreateTripViewModel, AsyncValue<void>>(
  CreateTripViewModel.new,
);


class CreateTripViewModel extends Notifier<AsyncValue<void>> {
  late final CreateTrip _createTrip = getIt<CreateTrip>(); 
  late final CreateItems _createItems = getIt<CreateItems>();
  final _uuid = const Uuid();

  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<bool> submitTrip(String name, String destination, DateTime start, DateTime end) async {
    state = const AsyncValue.loading();
    try {
      final tripId = _uuid.v4();

      final items = PackingListGenerator.generate(
        tripId: tripId,
        tripType: TripType.city,
      );

      final trip = Trip(
        id: tripId,
        name: name,
        destination: destination,
        startDate: start,
        endDate: end,
        tripType: TripType.city,
      );
      await _createTrip(trip);
      await _createItems(items);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}
