import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();
  final FlutterSecureStorage secureStorage;

  factory SecureStorage() {
    return _instance;
  }

  SecureStorage._internal() : secureStorage = FlutterSecureStorage();
}
