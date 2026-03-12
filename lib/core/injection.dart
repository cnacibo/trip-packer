import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// // Analytics
import 'analytics/analytics_service.dart';

// Use cases
import '../domain/usecases/check_onboarding_usecase.dart';
import '../domain/usecases/complete_onboarding_usecase.dart';
import '../domain/usecases/is_logged_in_usecase.dart';
import '../domain/usecases/sign_in_usecase.dart';
import '../domain/usecases/sign_up_usecase.dart';
import 'package:trip_packer/domain/usecases/get_trips.dart';
import 'package:trip_packer/domain/usecases/create_trip.dart';

// Data sources
import '../data/datasources/auth_remote_datasource.dart';
import '../data/datasources/auth_remote_datasource_impl.dart';
import 'package:trip_packer/data/datasources/trip_local_datasource.dart';

// Repositories
import '../domain/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/onboarding_repository.dart';
import '../data/repositories/onboarding_repository_impl.dart';
import 'package:trip_packer/data/repositories/trip_repository_impl.dart';
import 'package:trip_packer/domain/repositories/trip_repository.dart';


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
  // getIt.registerLazySingleton<WeatherRemoteDataSource>(
  //   () => WeatherRemoteDataSourceImpl(httpClient: getIt(), apiKey: weatherApiKey),
  // );
  final localDataSource = TripLocalDataSourceImpl();
  await localDataSource.initHive();

  getIt.registerLazySingleton<TripLocalDataSource>(() => localDataSource);

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sharedPreferences: getIt()),
  );
  getIt.registerLazySingleton<TripRepository>(
    () => TripRepositoryImpl(localDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => SignInUseCase(getIt()));
  getIt.registerLazySingleton(() => SignUpUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckOnboardingUseCase(getIt()));
  getIt.registerLazySingleton(() => CompleteOnboardingUseCase(getIt()));
  getIt.registerLazySingleton(() => IsLoggedInUseCase(getIt()));
  getIt.registerLazySingleton(() => GetTrips(getIt()));
  getIt.registerLazySingleton(() => CreateTrip(getIt()),
);
}