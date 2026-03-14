# ✈️ Trip Packer

**Trip Packer** — умный помощник для подготовки к поездкам: автоматически генерирует список вещей, подстраивает его под прогноз погоды и тип поездки а также локально хранит данные.

---

## ⭐ Что делает приложение
- Автогенерация списка вещей на основе места назначения, типа поездки и прогноза погоды.
- Интерактивный чек-лист с возможностью отмечать собранные предметы.
- Интеграция с погодным API (получение координат города и прогноза).
- Локальное хранение поездок, вещей и прогнозов (доступ офлайн).

## 🛠️ Структура проекта 

```
mariia_vlasova@MacBook-Air-Maria-5 lib % tree
.
├── core
│   ├── analytics/
│   ├── utils/
│   └── injection.dart
├── data
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── main.dart
└── presentation
    ├── auth/
    ├── create_trip/
    ├── home/
    ├── cats/
    ├── onboarding/
    ├── trip_detail/
    └──trips_screen/

```
---

## ⚙️ CI/CD

В проекте настроен **GitHub Actions** pipeline. 

При работе с веткой `main`:
- `push`
- `pull request`

Запускаются:
- `flutter analyze`
- `flutter test`

---

## ⚙️ Шаги запуска/сборки

1. Клонируйте репозиторий:

```
git clone git@github.com:cnacibo/trip-packer.git
cd trip-packer
```

2. Установите зависимости:
```
flutter pub get
```

3. Запуск с API ключом репозиторий:

```
flutter run --dart-define=WEATHER_API_KEY="ключ_от_openweathermap"
```

---

## 📦 Ссылка на скачивание APK
