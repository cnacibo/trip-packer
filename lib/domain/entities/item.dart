import 'package:equatable/equatable.dart';

enum ItemCategory { clothing, electronics, documents, toiletries, other }

class Item extends Equatable {
  final String id;
  final String tripId;
  final String name;
  final bool isPacked;
  final ItemCategory category;

  const Item({
    required this.id,
    required this.tripId,
    required this.name,
    this.isPacked = false,
    required this.category,
  });

  @override
  List<Object?> get props => [id, tripId, name, isPacked, category];
}