import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

// Screens
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/server_error_screen.dart';

// Utils
import 'utils/app_colors.dart';
import 'utils/api_service.dart';

// Memory-optimized app initialization
Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock the orientation early to avoid rebuilds
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Precache shared preferences instance for faster access
  await SharedPreferences.getInstance();
  
  // Initialize app with concurrent server/login checks
  final appState = await _initializeApp();
  
  // Enable optimized rendering
  runApp(MyApp(
    isLoggedIn: appState['isLoggedIn']!,
    isServerConnected: appState['isServerConnected']!,
  ));
}

// Optimized parallel initialization with error handling
Future<Map<String, bool>> _initializeApp() async {
  try {
    // Check server status first - fail fast approach
    final isServerConnected = await ApiService.isServerRunning();
    
    // Only check login if server is connected (avoid unnecessary network calls)
    final isLoggedIn = isServerConnected 
        ? await ApiService.isLoggedIn() 
        : false;
    
    return {
      'isServerConnected': isServerConnected,
      'isLoggedIn': isLoggedIn,
    };
  } catch (e) {
    // Graceful fallback on initialization error
    return {
      'isServerConnected': false,
      'isLoggedIn': false,
    };
  }
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isServerConnected;
  
  const MyApp({
    super.key, 
    this.isLoggedIn = false,
    this.isServerConnected = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Owner Bank',
      theme: _buildAppTheme(),
      home: _determineHomeScreen(),
      routes: _buildAppRoutes(),
      builder: (context, child) {
        // Apply text scaling to improve readability but limit maximum size
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
          ),
          child: child!,
        );
      },
    );
  }
  
  // Memory optimized theme construction
  ThemeData _buildAppTheme() {
    // Define colors once to avoid recreating color objects
    const primaryColor = AppColors.primary;
    const white = Colors.white;
    final borderRadius = BorderRadius.circular(15);
    
    return ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: white,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundDark,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }
  
  // Optimized home screen selection
  Widget _determineHomeScreen() {
    if (!isServerConnected) {
      return const ServerErrorScreen();
    }
    
    return isLoggedIn ? const DashboardScreen() : const WelcomeScreen();
  }
  
  // Lazily build routes to improve startup time
  Map<String, WidgetBuilder> _buildAppRoutes() {
    return {
      '/welcome': (context) => const WelcomeScreen(),
      '/login': (context) => const LoginScreen(),
      '/signup': (context) => const SignupScreen(),
      '/dashboard': (context) => const DashboardScreen(),
      '/server_error': (context) => const ServerErrorScreen(),
    };
  }
}
