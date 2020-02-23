
import 'passcode.dart';
import '../../data/storage/storage.dart';

class PasscodeRepository implements Passcode {

  final Storage _storage;

  PasscodeRepository(this._storage); //= StorageProvider().storage



  @override
  Future savePasscode(String passcode) {
    return _storage.savePasscode(passcode);
  }

}