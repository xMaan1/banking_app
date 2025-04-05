import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineMode {
  static const String _offlineModeKey = 'offline_mode_enabled';
  static const String _offlineUserKey = 'offline_user_data';

  // Check if offline mode is enabled
  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_offlineModeKey) ?? false;
  }

  // Enable or disable offline mode
  static Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_offlineModeKey, enabled);
  }

  // Get mock user data for offline testing
  static Future<Map<String, dynamic>> getMockUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_offlineUserKey);
    
    // If we have stored user data, use it
    if (userData != null) {
      return {
        'id': 1,
        'username': 'test_user',
        'email': 'test@example.com',
        'first_name': 'Test',
        'last_name': 'User',
        'profile': {
          'balance': 267345.00,
          'phone_number': '555-123-4567',
          'address': '123 Test Street',
        }
      };
    }
    
    // Otherwise use default mock data
    return {
      'id': 1,
      'username': 'offline_user',
      'email': 'offline@example.com',
      'first_name': 'Offline',
      'last_name': 'User',
      'profile': {
        'balance': 267345.00,
        'phone_number': '555-123-4567',
        'address': '123 Test Street',
      }
    };
  }
  
  // Get mock transactions for offline testing
  static Future<List<Map<String, dynamic>>> getMockTransactions() async {
    return [
      {
        'id': 1,
        'title': 'Salary Deposit',
        'amount': 5000.00,
        'type': 'deposit',
        'date': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        'description': 'Monthly salary payment',
      },
      {
        'id': 2,
        'title': 'Amazon Purchase',
        'amount': 123.45,
        'type': 'withdrawal',
        'date': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'description': 'Online shopping',
      },
      {
        'id': 3,
        'title': 'Transfer to John',
        'amount': 500.00,
        'type': 'transfer',
        'date': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        'description': 'Rent payment',
      },
      {
        'id': 4,
        'title': 'Starbucks',
        'amount': 4.50,
        'type': 'withdrawal',
        'date': DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
        'description': 'Coffee',
      },
    ];
  }
  
  // Get mock cards for offline testing
  static Future<List<Map<String, dynamic>>> getMockCards() async {
    return [
      {
        'id': 1,
        'card_number': '4242424242424242',
        'card_holder_name': 'Test User',
        'expiry_date': '12/25',
        'card_type': 'VISA Platinum',
        'balance': 153229.00,
      },
      {
        'id': 2,
        'card_number': '5353535353535353',
        'card_holder_name': 'Test User',
        'expiry_date': '08/27',
        'card_type': 'Mastercard Gold',
        'balance': 114116.00,
      },
    ];
  }
} 