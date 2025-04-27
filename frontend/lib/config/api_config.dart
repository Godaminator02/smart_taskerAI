import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // Base URL for API
  // This handles different environments:
  // - iOS simulator: localhost
  // - Android emulator: 10.0.2.2
  // - Web: relative URL
  static String get baseUrl {
    if (kIsWeb) {
      return '/api'; // For web, use relative URL
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5002/api'; // Android emulator
    } else if (Platform.isIOS) {
      return 'http://localhost:5002/api'; // iOS simulator
    } else {
      return 'http://localhost:5002/api'; // Default fallback
    }
  }

  // Task endpoints
  static String get tasks => '$baseUrl/tasks';
  static String taskDetail(String id) => '$baseUrl/tasks/$id';
  static String toggleTask(String id) => '$baseUrl/tasks/$id/toggle';

  // AI endpoints
  static String get prioritize => '$baseUrl/ai/prioritize';
  static String get suggestTime => '$baseUrl/ai/suggest-time';
  static String get rewriteTask => '$baseUrl/ai/rewrite-task';

  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
}
