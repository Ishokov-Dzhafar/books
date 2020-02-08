import 'profile.dart';
import '../../data/storage/storage_provider.dart';

class ProfileRepository implements Profile {

  var _storage = StorageProvider().storage;

  @override
  Future savePasscode(String passcode) {
    return _storage.savePasscode(passcode);
  }

}