import 'package:flutter_test/flutter_test.dart';
import 'package:capstone/services/api.dart';
import 'package:capstone/services/google_auth_service.dart';
import 'package:capstone/services/logger.dart';
import 'package:capstone/services/socket_service.dart';

void main() {
  group('Api', () {
    test('Api can be instantiated', () {
      final api = Api();
      expect(api, isA<Api>());
    });
  });

  group('GoogleSignInService', () {
    test('GoogleSignInService can be instantiated', () {
      final service = GoogleSignInService();
      expect(service, isA<GoogleSignInService>());
    });
  });

  group('Logger', () {
    test('Logger can be instantiated', () {
      final logger = Logger();
      expect(logger, isA<Logger>());
    });
  });

  group('SocketService', () {
    test('SocketService can be instantiated', () {
      final socket = SocketService();
      expect(socket, isA<SocketService>());
    });
  });
}