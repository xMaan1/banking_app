import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api_service.dart';

class AppConfig {
  bool isServerConnected = false;
  bool isLoggedIn = false;
  
  /// Initialize app configuration
  static Future<AppConfig> initialize() async {
    final config = AppConfig();

    // Ensure Flutter is initialized
    WidgetsFlutterBinding.ensureInitialized();
    
    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Check server connection and login status
    config.isServerConnected = await ApiService.isServerRunning();
    if (config.isServerConnected) {
      config.isLoggedIn = await ApiService.isLoggedIn();
    }
    
    return config;
  }
} 