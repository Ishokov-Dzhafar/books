import 'package:rxdart/rxdart.dart';

import 'vm_base.dart';

///ViewModel for PassCodeScreen
class PasscodeVM extends VMBase<PasscodeEvent> {



  PasscodeVM() {

  }

}

class PasscodeUIData {
  String passcode;
  String repeatPasscode;

  PasscodeUIData(this.passcode, this.repeatPasscode);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PasscodeUIData &&
              runtimeType == other.runtimeType &&
              passcode == other.passcode &&
              repeatPasscode == other.repeatPasscode;

  @override
  int get hashCode =>
      passcode.hashCode ^
      repeatPasscode.hashCode;
}

class PasscodeEvent {}