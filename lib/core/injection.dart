import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// // Analytics
import 'analytics/analytics_service.dart';

// Use cases
import '../domain/usecases/auth/check_onboarding_usecase.dart';
import '../domain/usecases/auth/complete_onboarding_usecase.dart';
import '../domain/usecases/auth/is_logged_in_usecase.dart';
import '../domain/usecases/auth/sign_in_usecase.dart';
import '../domain/usecases/auth/sign_up_usecase.dart';
import 'package:trip_packer/domain/usecases/trip/get_trips.dart';
import 'package:trip_packer/domain/usecases/trip/create_trip.dart';
import '../domain/usecases/packing/create_items.dart';
import '../domain/usecases/packing/get_packing_items.dart';
import '../domain/usecases/packing/update_packing_item.dart';
import '../domain/usecases/trip/get_trip_details.dart';
import 'package:trip_packer/domain/usecases/weather/get_weather_forecast.dart';
import 'package:trip_packer/domain/usecases/weather/add_forecast_for_trip.dart';
import 'package:trip_packer/domain/usecases/weather/view_trip_forecast.dart';

// Data sources
import '../data/datasources/remote/auth_datasource.dart';
import '../data/datasources/remote/auth_datasource_impl.dart';
import 'package:trip_packer/data/datasources/local/trip_datasource.dart';
import '../data/datasources/remote/weather_datasource.dart';
import '../data/datasources/remote/weather_datasource_impl.dart';

// Repositories
import '../domain/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/onboarding_repository.dart';
import '../data/repositories/onboarding_repository_impl.dart';
import 'package:trip_packer/data/repositories/trip_repository_impl.dart';
import 'package:trip_packer/domain/repositories/trip_repository.dart';
import 'package:trip_packer/data/repositories/weather_repository_impl.dart';
import 'package:trip_packer/domain/repositories/weather_repository.dart';


final getIt = GetIt.instance;

Future<void> init({String? weatherApiKey}) async {
  // External 
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Analytics
  getIt.registerLazySingleton<FirebaseAnalytics>(() => FirebaseAnalytics.instance);
  getIt.registerLazySingleton<AnalyticsService>(() => AnalyticsService(getIt<FirebaseAnalytics>()));

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: getIt()),
  );
  getIt.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(httpClient: getIt(), apiKey: weatherApiKey),
  );
  final appDatabase = AppDatabase(); 
  getIt.registerLazySingleton<AppDatabase>(() => appDatabase);

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sharedPreferences: getIt()),
  );
 getIt.registerLazySingleton<TripRepository>(
    () => TripRepositoryImpl(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => SignInUseCase(getIt()));
  getIt.registerLazySingleton(() => SignUpUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckOnboardingUseCase(getIt()));
  getIt.registerLazySingleton(() => CompleteOnboardingUseCase(getIt()));
  getIt.registerLazySingleton(() => IsLoggedInUseCase(getIt()));
  getIt.registerLazySingleton(() => GetTrips(getIt()));
  getIt.registerLazySingleton(() => CreateTrip(getIt()));
  getIt.registerLazySingleton(() => CreateItems(getIt()));
  getIt.registerLazySingleton(() => GetPackingItems(getIt()));
  getIt.registerLazySingleton(() => UpdatePackingItem(getIt()));
  getIt.registerLazySingleton(() => GetTripDetails(getIt()));
  getIt.registerLazySingleton(() => GetWeatherForecast(getIt()));
  getIt.registerLazySingleton(() => AddForecastForTrip(getIt()));
  getIt.registerLazySingleton(() => ViewTripForecast(getIt()));
}