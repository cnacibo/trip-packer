import '../../domain/entities/item.dart';
import '../datasources/local/trip_datasource.dart' as db; 
import 'package:drift/drift.dart';

extension ItemMapper on db.Item {
  Item toDomain() {
    return Item(
      id: id,
      tripId: tripId,
      name: name,
      isPacked: isPacked,
      category: ItemCategory.values.firstWhere(
            (e) => e.index == category,
        orElse: () => ItemCategory.other,
      ),
    );
  }
}

extension ItemCompanionMapper on Item {
  db.ItemsCompanion toCompanion() {
    return db.ItemsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      name: Value(name),
      isPacked: Value(isPacked),
      category: Value(category.index),
    );
  }
}