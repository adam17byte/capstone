import 'dart:developer' as developer;

class Logger {
  static const String _tag = 'TemanTukang';

  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log('ℹ️ $message', name: _tag, error: error, stackTrace: stackTrace);
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log('⚠️ $message', name: _tag, error: error, stackTrace: stackTrace, level: 900);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log('❌ $message', name: _tag, error: error, stackTrace: stackTrace, level: 1000);
  }

  static void auth(String action, String details, [bool success = true]) {
    final status = success ? '✅' : '❌';
    developer.log('$status AUTH: $action - $details', name: _tag);
  }

  static void network(String endpoint, String method, [int? statusCode, String? error]) {
    final status = statusCode != null ? '($statusCode)' : error != null ? '(ERROR)' : '';
    developer.log('🌐 $method $endpoint $status', name: _tag, error: error);
  }
}