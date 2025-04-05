import 'dart:collection';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Performance monitoring system for the banking app
/// Helps identify performance bottlenecks and memory issues
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();
  
  // Tracking enabled/disabled state
  bool _isEnabled = false;
  
  // Track performance metrics
  final Map<String, List<double>> _frameTimings = {};
  final Queue<double> _recentFrames = Queue();
  final int _maxRecentFrames = 120; // 2 seconds at 60fps
  
  // Tracking for memory usage
  int _lastMemoryUsage = 0;
  
  /// Enable performance monitoring
  void enable() {
    if (_isEnabled) return;
    
    _isEnabled = true;
    
    // Clear previous tracking data
    _frameTimings.clear();
    _recentFrames.clear();
    
    if (kDebugMode) {
      debugPrint('🔍 Performance monitoring enabled');
      
      // Track rendering performance
      debugProfileBuildsEnabled = true;
      debugPrintRebuildDirtyWidgets = true;
      
      // Register frame callback
      WidgetsBinding.instance.addTimingsCallback(_recordFrameTiming);
      
      // Start memory tracking
      _startMemoryTracking();
    }
  }
  
  /// Disable performance monitoring
  void disable() {
    if (!_isEnabled) return;
    
    _isEnabled = false;
    
    if (kDebugMode) {
      debugPrint('🔍 Performance monitoring disabled');
      
      // Disable debug flags
      debugProfileBuildsEnabled = false;
      debugPrintRebuildDirtyWidgets = false;
      
      // Remove frame callback
      WidgetsBinding.instance.removeTimingsCallback(_recordFrameTiming);
    }
  }
  
  /// Monitor a specific operation with timing
  Future<T> trackOperation<T>(String name, Future<T> Function() operation) async {
    if (!_isEnabled) return operation();
    
    final stopwatch = Stopwatch()..start();
    try {
      return await operation();
    } finally {
      stopwatch.stop();
      _recordTiming(name, stopwatch.elapsedMilliseconds.toDouble());
      if (stopwatch.elapsedMilliseconds > 16) {
        debugPrint('⚠️ Slow operation: $name took ${stopwatch.elapsedMilliseconds}ms');
      }
    }
  }
  
  /// Record frame timing information
  void _recordFrameTiming(List<FrameTiming> timings) {
    if (!_isEnabled) return;
    
    for (final timing in timings) {
      final rasterTime = 
          timing.rasterFinishTime - timing.rasterStartTime;
      final buildTime = 
          timing.buildFinishTime - timing.buildStartTime;
          
      final totalFrameTime = 
          timing.totalSpan.inMicroseconds / 1000.0;
      
      // Add to recent frames queue
      _recentFrames.add(totalFrameTime);
      if (_recentFrames.length > _maxRecentFrames) {
        _recentFrames.removeFirst();
      }
      
      // Log slow frames (>16ms is a dropped frame at 60fps)
      if (totalFrameTime > 16.0 && kDebugMode) {
        debugPrint('🔻 Slow frame: ${totalFrameTime.toStringAsFixed(2)}ms');
      }
    }
    
    // Calculate FPS every 60 frames
    if (_recentFrames.length == _maxRecentFrames) {
      final avgFrameTime = _recentFrames.reduce((a, b) => a + b) / _recentFrames.length;
      final estimatedFps = 1000 / avgFrameTime;
      
      if (kDebugMode && estimatedFps < 58) {
        debugPrint('📊 Estimated FPS: ${estimatedFps.toStringAsFixed(1)}');
      }
    }
  }
  
  /// Record a timing for a specific operation
  void _recordTiming(String name, double timing) {
    _frameTimings.putIfAbsent(name, () => []).add(timing);
    
    // Limit size of timing lists
    if (_frameTimings[name]!.length > 100) {
      _frameTimings[name]!.removeAt(0);
    }
  }
  
  /// Start tracking memory usage
  void _startMemoryTracking() {
    if (!_isEnabled || !kDebugMode) return;
    
    Future<void> checkMemory() async {
      try {
        // This is approximative since exact memory usage is platform-specific
        final memInfo = await developer.Service.getInfo();
        final currentUsage = memInfo.currentRSS ?? 0;
        
        // Report if memory increased significantly
        if (_lastMemoryUsage > 0 && 
            currentUsage > _lastMemoryUsage * 1.2 && 
            currentUsage - _lastMemoryUsage > 20 * 1024 * 1024) {
          debugPrint('⚠️ Memory usage increased by ${((currentUsage - _lastMemoryUsage) / (1024 * 1024)).toStringAsFixed(1)}MB');
        }
        
        _lastMemoryUsage = currentUsage;
      } catch (e) {
        // Ignore errors in memory tracking
      }
      
      if (_isEnabled) {
        Future.delayed(const Duration(seconds: 5), checkMemory);
      }
    }
    
    checkMemory();
  }
  
  /// Get performance report
  String getPerformanceReport() {
    if (!_isEnabled) {
      return 'Performance monitoring is disabled';
    }
    
    final buffer = StringBuffer();
    buffer.writeln('📊 Performance Report');
    buffer.writeln('----------------------');
    
    if (_recentFrames.isNotEmpty) {
      final avgFrameTime = _recentFrames.reduce((a, b) => a + b) / _recentFrames.length;
      buffer.writeln('Average frame time: ${avgFrameTime.toStringAsFixed(2)}ms');
      buffer.writeln('Estimated FPS: ${(1000 / avgFrameTime).toStringAsFixed(1)}');
    }
    
    // Report operation timings
    buffer.writeln('\nOperation Timings:');
    for (final entry in _frameTimings.entries) {
      if (entry.value.isNotEmpty) {
        final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
        buffer.writeln('${entry.key}: ${avg.toStringAsFixed(2)}ms (${entry.value.length} samples)');
      }
    }
    
    return buffer.toString();
  }
  
  /// Clear all performance data
  void clearData() {
    _frameTimings.clear();
    _recentFrames.clear();
  }
} 