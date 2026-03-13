import 'package:flutter/material.dart';
import 'presentation/home/initial_screen.dart';
import 'core/injection.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const apiKey = String.fromEnvironment('WEATHER_API_KEY');
  await di.init(weatherApiKey: apiKey.isNotEmpty ? apiKey : null);
  runApp(
    ProviderScope(
      child: TripPacker(),
    ),
  );
}

class TripPacker extends StatefulWidget {
  const TripPacker({super.key});
  @override
  State<TripPacker> createState() => _TripPackerState();
}

class _TripPackerState extends State<TripPacker> {
  static const _navBarColor = Color(0x00000000); 
  static const _navBarIconBrightness = Brightness.dark;

  @override
  void initState() {super.initState();}

  @override
  Widget build(BuildContext context) {
    final myTheme = ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: const Color(0xFF89CFF0),    
          onPrimary: const Color(0xFF000000),
          secondary: const Color(0xFFE5E4E2), 
          onSecondary: const Color(0xFF000000),
          error: Colors.red,
          onError: Colors.white,
          surface: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF000000),
          tertiary: const Color(0xFFF0F8FF), 
          onTertiary: const Color(0xFF000000),
          surfaceContainerHighest: const Color(0xFFF0F8FF),
          outline: const Color(0xFFE5E4E2), 
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F8FF),
        useMaterial3: true,
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000),
          ),
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Color(0xFF000000),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFFFFFF),
          foregroundColor: Color(0xFF000000),
          elevation: 2,
          centerTitle: true,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Color(0xFF89CFF0).withValues(alpha: 0.9),
          indicatorColor: Color(0xFFF0F8FF),
          surfaceTintColor: const Color(0xFF89CFF0), 
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 4,
            backgroundColor: const Color(0xFF89CFF0),
            foregroundColor: const Color(0xFF000000), 
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
        ),
      );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: _navBarColor,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: _navBarIconBrightness,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: MaterialApp(
        title: 'Trip Packer',
        theme: myTheme,
        home: const InitialScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

