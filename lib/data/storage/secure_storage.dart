import 'storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage implements Storage {
  FlutterSecureStorage _secureStorage;

  final passcodeKey = 'passcodeKey';

  SecureStorage(this._secureStorage);

  @override
  Future<void> savePasscode(String passcode) async {
    var result = await _secureStorage.write(key: passcodeKey, value: passcode);
    print('RESULT');
    return result;
  }

}