import 'package:flutter/material.dart';
import 'utils/app_theme.dart';
import 'utils/app_router.dart';
import 'utils/app_config.dart';

class BankingApp extends StatelessWidget {
  final AppConfig config;
  
  const BankingApp({
    Key? key,
    required this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Owner Bank',
      theme: AppTheme.defaultTheme,
      
      // Use router to determine initial screen
      home: AppRouter.getInitialScreen(
        isServerConnected: config.isServerConnected,
        isLoggedIn: config.isLoggedIn,
      ),
      
      // Register all routes
      routes: AppRouter.routes,
    );
  }
} 