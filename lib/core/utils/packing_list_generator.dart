import '../../domain/entities/item.dart';
import '../../domain/entities/trip.dart';
import 'package:uuid/uuid.dart';

class PackingListGenerator {
  static List<Item> generate({
    required String tripId,
    required TripType tripType,
  }) {
    final items = <Item>[];

    // Базовые вещи для всех поездок
    items.addAll([
      _createItem(tripId, 'Паспорт', ItemCategory.documents),
      _createItem(tripId, 'Билеты', ItemCategory.documents),
      _createItem(tripId, 'Деньги/карты', ItemCategory.documents),
      _createItem(tripId, 'Телефон', ItemCategory.electronics),
      _createItem(tripId, 'Зарядное устройство', ItemCategory.electronics),
    ]);
    
    // Специфичные вещи по типу поездки
    switch (tripType) {
      case TripType.beach:
        items.addAll([
          _createItem(tripId, 'Полотенце', ItemCategory.clothing),
          _createItem(tripId, 'Сланцы', ItemCategory.clothing),
          _createItem(tripId, 'Надувной круг', ItemCategory.other),
        ]);
        break;
      case TripType.mountains:
        items.addAll([
          _createItem(tripId, 'Треккинговые ботинки', ItemCategory.clothing),
          _createItem(tripId, 'Рюкзак', ItemCategory.other),
          _createItem(tripId, 'Фонарик', ItemCategory.electronics),
        ]);
        break;
      case TripType.business:
        items.addAll([
          _createItem(tripId, 'Деловой костюм', ItemCategory.clothing),
          _createItem(tripId, 'Ноутбук', ItemCategory.electronics),
          _createItem(tripId, 'Презентационные материалы', ItemCategory.documents),
        ]);
        break;
      default:
        break;
    }

    return items;
  }

  static Item _createItem(String tripId, String name, ItemCategory category) {
    return Item(
      id: const Uuid().v4(),
      tripId: tripId,
      name: name,
      category: category,
      isPacked: false,
    );
  }
}