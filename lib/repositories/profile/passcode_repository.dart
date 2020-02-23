
import '../../data/storage/storage.dart';
import 'passcode.dart';

class PasscodeRepository implements Passcode {

  final Storage _storage;

  PasscodeRepository(this._storage); //= StorageProvider().storage



  @override
  Future savePasscode(String passcode) {
    return _storage.savePasscode(passcode);
  }

}