import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/api_service.dart';
import '../components/custom_button.dart';

class ServerErrorScreen extends StatefulWidget {
  const ServerErrorScreen({Key? key}) : super(key: key);

  @override
  _ServerErrorScreenState createState() => _ServerErrorScreenState();
}

class _ServerErrorScreenState extends State<ServerErrorScreen> {
  bool _isRetrying = false;

  Future<void> _retryConnection() async {
    setState(() {
      _isRetrying = true;
    });

    final bool isConnected = await ApiService.isServerRunning();

    setState(() {
      _isRetrying = false;
    });

    if (isConnected && mounted) {
      // Server is now connected, check login status
      final bool isLoggedIn = await ApiService.isLoggedIn();
      
      Navigator.pushReplacementNamed(
        context, 
        isLoggedIn ? '/dashboard' : '/welcome',
      );
    } else if (mounted) {
      // Still not connected, show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not connect to server. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _openTerminalInstructions() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Server Setup Instructions'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'To start the backend server:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('1. Open a terminal or command prompt'),
              const Text('2. Navigate to your project directory'),
              const Text('3. Run the batch file:'),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey[200],
                child: const Text(
                  r'.\run_django.bat',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Backend URL:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                ApiService.baseUrl,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off,
                size: 80,
                color: AppColors.error,
              ),
              const SizedBox(height: 24),
              const Text(
                'Backend Server Not Found',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Could not connect to the banking backend server. Please make sure it\'s running and try again.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Server URL: ${ApiService.baseUrl}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              CustomButton(
                text: 'RETRY CONNECTION',
                onPressed: _isRetrying ? null : _retryConnection,
                isLoading: _isRetrying,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'HOW TO START SERVER',
                onPressed: _openTerminalInstructions,
                backgroundColor: AppColors.backgroundLight,
                textColor: AppColors.textPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 