import 'passcode.dart';
import '../../data/storage/storage_provider.dart';

class PasscodeRepository implements Passcode {

  var _storage = StorageProvider().storage;

  @override
  Future savePasscode(String passcode) {
    return _storage.savePasscode(passcode);
  }

}