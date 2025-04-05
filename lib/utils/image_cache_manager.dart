import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Optimized image caching system with memory and disk caching
class ImageCacheManager {
  static final ImageCacheManager _instance = ImageCacheManager._internal();
  factory ImageCacheManager() => _instance;
  ImageCacheManager._internal();

  // Memory cache for frequently accessed images
  final Map<String, Uint8List> _memoryCache = {};
  
  // LRU tracking for memory cache management
  final List<String> _lruKeys = [];
  
  // Maximum memory cache size (in items)
  static const int _maxMemoryCacheSize = 50;
  
  // Custom cache manager for disk caching
  final CacheManager _cacheManager = CacheManager(
    Config(
      'banking_app_images',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: 'banking_app_images_cache'),
      fileService: HttpFileService(),
    ),
  );

  /// Get image from cache or network with optimized loading
  Future<Uint8List?> getImage(String url, {bool forceRefresh = false}) async {
    if (url.isEmpty) return null;
    
    // Generate cache key from URL
    final String cacheKey = _generateCacheKey(url);
    
    // Try memory cache first (fastest)
    if (!forceRefresh && _memoryCache.containsKey(cacheKey)) {
      _updateLRU(cacheKey);
      return _memoryCache[cacheKey];
    }
    
    try {
      // Try disk cache next
      if (!forceRefresh) {
        final fileInfo = await _cacheManager.getFileFromCache(url);
        if (fileInfo != null) {
          final bytes = await fileInfo.file.readAsBytes();
          _addToMemoryCache(cacheKey, bytes);
          return bytes;
        }
      }
      
      // Download if not in cache
      final fileInfo = await _cacheManager.downloadFile(url);
      final bytes = await fileInfo.file.readAsBytes();
      
      // Add to memory cache
      _addToMemoryCache(cacheKey, bytes);
      
      return bytes;
    } catch (e) {
      debugPrint('Error loading image: $e');
      return null;
    }
  }

  /// Load and cache image for a network request
  Future<ImageProvider> getImageProvider(String url) async {
    final bytes = await getImage(url);
    if (bytes != null) {
      return MemoryImage(bytes);
    }
    return const AssetImage('assets/images/placeholder.png');
  }

  /// Optimized image widget with placeholder and error handling
  Widget optimizedImage({
    required String url,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return FutureBuilder<Uint8List?>(
      future: getImage(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder ?? 
            Container(
              width: width,
              height: height,
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            );
        }
        
        if (snapshot.hasError || snapshot.data == null) {
          return errorWidget ?? 
            Container(
              width: width,
              height: height,
              color: Colors.grey[200],
              child: const Icon(Icons.error, color: Colors.red),
            );
        }
        
        return Image.memory(
          snapshot.data!,
          width: width,
          height: height,
          fit: fit,
          gaplessPlayback: true, // Prevent flicker on reload
          errorBuilder: (context, error, stackTrace) {
            return errorWidget ?? 
              Container(
                width: width,
                height: height,
                color: Colors.grey[200],
                child: const Icon(Icons.error, color: Colors.red),
              );
          },
        );
      },
    );
  }

  /// Add image to memory cache with LRU management
  void _addToMemoryCache(String key, Uint8List bytes) {
    // Evict LRU images if cache is full
    if (_memoryCache.length >= _maxMemoryCacheSize && !_memoryCache.containsKey(key)) {
      final lruKey = _lruKeys.removeAt(0);
      _memoryCache.remove(lruKey);
    }
    
    // Add to cache and update LRU
    _memoryCache[key] = bytes;
    _updateLRU(key);
  }

  /// Update LRU order when image is accessed
  void _updateLRU(String key) {
    _lruKeys.remove(key);
    _lruKeys.add(key);
  }

  /// Generate a consistent cache key from URL
  String _generateCacheKey(String url) {
    final bytes = utf8.encode(url);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// Clear all caches
  Future<void> clearCache() async {
    _memoryCache.clear();
    _lruKeys.clear();
    await _cacheManager.emptyCache();
  }

  /// Clear specific image from cache
  Future<void> removeFromCache(String url) async {
    final cacheKey = _generateCacheKey(url);
    _memoryCache.remove(cacheKey);
    _lruKeys.remove(cacheKey);
    await _cacheManager.removeFile(url);
  }
} 