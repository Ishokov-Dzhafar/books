import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage.dart';
import 'secure_storage.dart';

class StorageProvider {

  static final StorageProvider _instance = StorageProvider._internal();

  Storage _storage;

  ///Get storage instance
  Storage get storage => _storage;

  StorageProvider._internal() {
    _storage = SecureStorage(FlutterSecureStorage());
  }

  factory StorageProvider() => _instance;

}