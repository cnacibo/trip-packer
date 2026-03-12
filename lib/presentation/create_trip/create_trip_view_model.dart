import 'package:riverpod/riverpod.dart';
import 'package:trip_packer/domain/usecases/create_trip.dart';
import 'package:trip_packer/core/injection.dart';
import 'package:trip_packer/domain/entities/trip.dart';
import 'package:uuid/uuid.dart';

final createTripViewModelProvider =
    NotifierProvider<CreateTripViewModel, AsyncValue<void>>(
  CreateTripViewModel.new,
);


class CreateTripViewModel extends Notifier<AsyncValue<void>> {
  late final CreateTrip _createTrip = getIt<CreateTrip>(); 
  final _uuid = const Uuid();

  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<bool> submitTrip(String name, String destination, DateTime start, DateTime end) async {
    state = const AsyncValue.loading();
    try {
      final trip = Trip(
        id: _uuid.v4(),
        name: name,
        destination: destination,
        startDate: start,
        endDate: end,
      );
      await _createTrip(trip);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}
