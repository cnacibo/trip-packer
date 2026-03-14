import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_packer/core/injection.dart' as di;
import 'package:trip_packer/domain/usecases/sign_in_usecase.dart';
import 'package:trip_packer/domain/usecases/sign_up_usecase.dart';
import 'package:trip_packer/presentation/auth/auth_screen.dart';

import 'package:trip_packer/core/analytics/analytics_service.dart';

class MockSignInUseCase extends Mock implements SignInUseCase {}
class MockSignUpUseCase extends Mock implements SignUpUseCase {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

void main() {
  late MockSignInUseCase mockSignInUseCase;
  late MockSignUpUseCase mockSignUpUseCase;
  late MockNavigatorObserver mockObserver;

  late MockAnalyticsService mockAnalyticsService;

  setUp(() {
    mockSignInUseCase = MockSignInUseCase();
    mockSignUpUseCase = MockSignUpUseCase();
    mockObserver = MockNavigatorObserver();

    mockAnalyticsService = MockAnalyticsService();

    di.getIt.reset();

    di.getIt.registerFactory<SignInUseCase>(() => mockSignInUseCase);
    di.getIt.registerFactory<SignUpUseCase>(() => mockSignUpUseCase);

    di.getIt.registerSingleton<AnalyticsService>(mockAnalyticsService);

    registerFallbackValue('');

    registerFallbackValue(MaterialPageRoute(builder: (_) => const SizedBox()));

    when(() => mockSignInUseCase.execute(any(), any())).thenAnswer((_) async => false);
    when(() => mockSignUpUseCase.execute(any(), any())).thenAnswer((_) async => false);

    when(() => mockAnalyticsService.logSignIn(any())).thenAnswer((_) async => Future.value());
    when(() => mockAnalyticsService.logSignUp(any())).thenAnswer((_) async => Future.value());
    when(() => mockAnalyticsService.logSignInFailed(any(), any()))
        .thenAnswer((_) async => Future.value());
    when(() => mockAnalyticsService.logSignUpFailed(any(), any()))
        .thenAnswer((_) async => Future.value());
    when(() => mockAnalyticsService.logLogout()).thenAnswer((_) async => Future.value());
  });

  tearDown(() {
    di.getIt.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: const AuthScreen(),
      navigatorObservers: [mockObserver],
    );
  }

  group('AuthScreen', () {
      testWidgets('should show error when email is invalid', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalid-email');

      final loginButton = find.widgetWithText(ElevatedButton, 'Войти');
      await tester.tap(loginButton);
      await tester.pump(); 

      expect(find.text('Неверный email'), findsOneWidget);

      verifyNever(() => mockSignInUseCase.execute(any(), any()));
    });
  });
}