import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/server_error_screen.dart';

class AppRouter {
  static Map<String, WidgetBuilder> get routes {
    return {
      '/welcome': (context) => const WelcomeScreen(),
      '/login': (context) => const LoginScreen(),
      '/signup': (context) => const SignupScreen(),
      '/dashboard': (context) => const DashboardScreen(),
      '/server_error': (context) => const ServerErrorScreen(),
    };
  }

  static Widget getInitialScreen({
    required bool isServerConnected,
    required bool isLoggedIn,
  }) {
    if (!isServerConnected) {
      return const ServerErrorScreen();
    }
    
    return isLoggedIn ? const DashboardScreen() : const WelcomeScreen();
  }
} 