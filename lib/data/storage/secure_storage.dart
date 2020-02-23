import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../app_config.dart' as config;
import 'storage.dart';

class SecureStorage implements Storage {
  FlutterSecureStorage _secureStorage;


  SecureStorage(this._secureStorage);

  @override
  Future<void> savePasscode(String passcode) async {
    var result = await _secureStorage.write(key: config.passcodeKey, value: passcode);
    print('RESULT');
    return result;
  }

}