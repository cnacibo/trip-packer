import '../../domain/entities/item.dart';
import '../../domain/entities/trip.dart';
import '../../domain/entities/weather.dart';
import 'package:uuid/uuid.dart';

class PackingListGenerator {
  static List<Item> generate({
    required String tripId,
    required TripType tripType,
    required List<Weather> forecast,
  }) {
    final items = <Item>[];

    items.addAll([
      _createItem(tripId, 'Паспорт', ItemCategory.documents),
      _createItem(tripId, 'Билеты', ItemCategory.documents),
      _createItem(tripId, 'Деньги/карты', ItemCategory.documents),
      _createItem(tripId, 'Телефон', ItemCategory.electronics),
      _createItem(tripId, 'Зарядное устройство', ItemCategory.electronics),
    ]);
    
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

    _addWeatherBasedItems(tripId, forecast, items);

    return items;
  }

  static void _addWeatherBasedItems(String tripId, List<Weather> forecast, List<Item> items) {
    const double rainThreshold = 0.0;
    const double hotThreshold = 25.0;
    const double coldThreshold = 10.0;
    const double windThreshold = 10.0;

    bool hasRain = forecast.any((w) => w.precipitation > rainThreshold);
    bool hasHot = forecast.any((w) => w.temperatureAfternoon > hotThreshold);
    bool hasCold = forecast.any((w) => w.temperatureAfternoon < coldThreshold);
    bool hasWind = forecast.any((w) => w.windSpeed > windThreshold);
    bool hasLargeTempRange = forecast.any((w) => (w.temperatureMax - w.temperatureMin) > 15);

    if (hasRain) {
      items.add(_createItem(tripId, 'Зонт', ItemCategory.other));
      items.add(_createItem(tripId, 'Дождевик', ItemCategory.clothing));
    }
    if (hasHot) {
      items.add(_createItem(tripId, 'Солнцезащитный крем', ItemCategory.other));
      items.add(_createItem(tripId, 'Головной убор', ItemCategory.clothing));
      items.add(_createItem(tripId, 'Солнечные очки', ItemCategory.other));
    }
    if (hasCold) {
      items.add(_createItem(tripId, 'Тёплая куртка', ItemCategory.clothing));
      items.add(_createItem(tripId, 'Термобельё', ItemCategory.clothing));
    }
    if (hasWind) {
      items.add(_createItem(tripId, 'Ветровка', ItemCategory.clothing));
    }
    if (hasLargeTempRange) {
      items.add(_createItem(tripId, 'Многослойная одежда', ItemCategory.clothing));
    }
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