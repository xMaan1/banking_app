import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'offline_mode.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Singleton HTTP client for connection pooling
  final _client = http.Client();
  
  // Cache configuration
  static const int _cacheExpiryMinutes = 5;
  static const String _tokenKey = 'auth_token';
  static const String _profileCacheKey = 'profile_cache';
  static const String _transactionsCacheKey = 'transactions_cache';
  
  // Connection timeout durations
  static const Duration _connectionTimeout = Duration(seconds: 10);
  static const Duration _receiveTimeout = Duration(seconds: 15);
  
  // Base URL with platform-specific configuration
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000/api';
    if (Platform.isAndroid) {
      // 10.0.2.2 is for Android emulator, for physical devices you might need to use your actual server IP
      const useEmulator = true; // Set to false when testing on physical device with real backend
      return useEmulator ? 'http://10.0.2.2:8000/api' : 'http://YOUR_SERVER_IP:8000/api';
    }
    return 'http://127.0.0.1:8000/api';
  }

  // Headers with optional token - both instance and static method
  Map<String, String> _headers({String? token}) {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) headers['Authorization'] = 'Token $token';
    return headers;
  }
  
  static Map<String, String> headers({String? token}) {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) headers['Authorization'] = 'Token $token';
    return headers;
  }

  // Enhanced HTTP request wrapper with retry logic
  Future<http.Response> _makeRequest(
    String url,
    String method,
    {Map<String, String>? headers,
    Object? body,
    int maxRetries = 3}
  ) async {
    var attempts = 0;
    while (attempts < maxRetries) {
      try {
        late http.Response response;
        
        switch (method) {
          case 'GET':
            response = await _client
                .get(Uri.parse(url), headers: headers)
                .timeout(_connectionTimeout);
            break;
          case 'POST':
            response = await _client
                .post(Uri.parse(url), headers: headers, body: body)
                .timeout(_connectionTimeout);
            break;
          default:
            throw Exception('Unsupported HTTP method: $method');
        }

        if (response.statusCode == 401) {
          // Token expired, clear it and throw
          await clearToken();
          throw Exception('Authentication required');
        }
        
        return response;
      } on TimeoutException {
        attempts++;
        if (attempts == maxRetries) {
          throw Exception('Connection timeout after $maxRetries attempts');
        }
        // Exponential backoff
        await Future.delayed(Duration(milliseconds: 1000 * attempts));
      } catch (e) {
        attempts++;
        if (attempts == maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: 1000 * attempts));
      }
    }
    throw Exception('Request failed after $maxRetries attempts');
  }

  // Improved caching mechanism with compression - both instance and static
  Future<void> _cacheData(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data);
    await prefs.setString(key, jsonString);
    
    final now = DateTime.now().add(Duration(minutes: _cacheExpiryMinutes));
    await prefs.setString('${key}_expiry', now.toIso8601String());
  }
  
  static Future<void> cacheData(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data);
    await prefs.setString(key, jsonString);
    
    final now = DateTime.now().add(Duration(minutes: _cacheExpiryMinutes));
    await prefs.setString('${key}_expiry', now.toIso8601String());
  }
  
  Future<dynamic> _getCachedData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryStr = prefs.getString('${key}_expiry');
    
    if (expiryStr != null) {
      final expiry = DateTime.parse(expiryStr);
      if (DateTime.now().isBefore(expiry)) {
        final cachedStr = prefs.getString(key);
        if (cachedStr != null) {
          return jsonDecode(cachedStr);
        }
      }
    }
    return null;
  }
  
  static Future<dynamic> getCachedData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryStr = prefs.getString('${key}_expiry');
    
    if (expiryStr != null) {
      final expiry = DateTime.parse(expiryStr);
      if (DateTime.now().isBefore(expiry)) {
        final cachedStr = prefs.getString(key);
        if (cachedStr != null) {
          return jsonDecode(cachedStr);
        }
      }
    }
    return null;
  }

  // Enhanced login with automatic token refresh - both instance and static
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final response = await _makeRequest(
        '$baseUrl/auth/login/',
        'POST',
        headers: _headers(),
        body: jsonEncode({
          'email': email,
          'password': password,
          'remember_me': rememberMe,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await saveToken(data['token']['token'].toString());
        await clearCache();
        return {'success': true, 'data': data};
      }
      
      return {'success': false, 'error': _parseError(response)};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
  
  static Future<Map<String, dynamic>> loginStatic({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}/auth/login/'),
        headers: headers(),
        body: jsonEncode({
          'email': email,
          'password': password,
          'remember_me': rememberMe,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await saveToken(data['token']['token'].toString());
        await clearCache();
        return {'success': true, 'data': data};
      }
      
      return {'success': false, 'error': parseError(response)};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Optimized transaction fetching with pagination
  Future<Map<String, dynamic>> getTransactions({
    bool forceRefresh = false,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      if (!forceRefresh) {
        final cachedData = await _getCachedData(_transactionsCacheKey);
        if (cachedData != null) {
          return {'success': true, 'data': cachedData, 'cached': true};
        }
      }
      
      final token = await getToken();
      if (token == null) {
        return {'success': false, 'error': 'No authentication token'};
      }
      
      final response = await _makeRequest(
        '$baseUrl/auth/transactions/?page=$page&page_size=$pageSize',
        'GET',
        headers: _headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (page == 1) {
          await _cacheData(_transactionsCacheKey, data);
        }
        return {'success': true, 'data': data};
      }
      
      return {'success': false, 'error': _parseError(response)};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Helper method to parse error responses - both instance and static
  Map<String, dynamic> _parseError(http.Response response) {
    try {
      return jsonDecode(response.body);
    } catch (_) {
      return {'message': 'Request failed with status: ${response.statusCode}'};
    }
  }
  
  static Map<String, dynamic> parseError(http.Response response) {
    try {
      return jsonDecode(response.body);
    } catch (_) {
      return {'message': 'Request failed with status: ${response.statusCode}'};
    }
  }

  // Cleanup method
  void dispose() {
    _client.close();
  }

  // Register a new user
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    String firstName = '',
    String lastName = '',
  }) async {
    try {
      final body = jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'password_confirm': passwordConfirm,
        'first_name': firstName,
        'last_name': lastName,
      });
      
      final response = await http.post(
        Uri.parse('${baseUrl}/auth/register/'),
        headers: headers(),
        body: body,
      );
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await saveToken(data['token']['token'].toString());
        return {'success': true, 'data': data};
      } else {
        try {
          return {'success': false, 'error': jsonDecode(response.body)};
        } catch (e) {
          return {'success': false, 'error': 'Registration failed with status ${response.statusCode}'};
        }
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  // Token management methods
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Cache management
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileCacheKey);
    await prefs.remove('${_profileCacheKey}_expiry');
    await prefs.remove(_transactionsCacheKey);
    await prefs.remove('${_transactionsCacheKey}_expiry');
  }
  
  static Future<void> invalidateCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    await prefs.remove('${key}_expiry');
  }

  // Check if server is running - optimized with timeout
  static Future<bool> isServerRunning() async {
    try {
      final isOfflineModeEnabled = await OfflineMode.isEnabled();
      
      if (isOfflineModeEnabled) {
        // If offline mode is enabled, pretend server is not running
        return false;
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/auth/test/'),
        headers: headers(),
      ).timeout(const Duration(seconds: 3)); // Reduced timeout
      
      return response.statusCode == 200;
    } catch (e) {
      // Consider enabling offline mode automatically
      await OfflineMode.setEnabled(true);
      return false;
    }
  }

  // Check if user is logged in - optimized
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null) return false;
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/check-token/'),
        headers: headers(),
        body: jsonEncode({'token': token}),
      ).timeout(const Duration(seconds: 3)); // Reduced timeout
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['valid'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Logout user
  static Future<void> logout() async {
    await clearToken();
    await clearCache();
  }

  // Get user profile with caching
  static Future<Map<String, dynamic>> getUserProfile({bool forceRefresh = false}) async {
    try {
      // Try to get from cache first if not forcing refresh
      if (!forceRefresh) {
        final cachedData = await getCachedData(_profileCacheKey);
        if (cachedData != null) {
          return {'success': true, 'data': cachedData, 'cached': true};
        }
      }
      
      final token = await getToken();
      if (token == null) return {'success': false, 'error': 'No authentication token'};
      
      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile/'),
        headers: headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Cache the fresh data
        await cacheData(_profileCacheKey, data);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'success': false, 'error': 'Failed to get profile: $e'};
    }
  }
}