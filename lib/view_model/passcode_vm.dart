import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../utils.dart';

import 'vm_base.dart';

///ViewModel for PassCodeScreen
class PasscodeVM extends VMBase<PasscodeEvent> {
  Observable<PasscodeUIData> _passcode;

  Stream<PasscodeUIData> get passcode => _passcode;

  PasscodeUIData _uiData;

  PasscodeVM() {
    _uiData = PasscodeUIData();

    var initPasscodeData = events
        .where((event) => event is InitEvent || event is ResetUIDataEvent)
        .map((_) {
      _uiData = PasscodeUIData();
      return _uiData;
    });

    var numberPressed = events
        .where((event) => event is NumberPressedEvent)
        .map((event) => event as NumberPressedEvent)
        .map((event) {
      if (event.symbol == KeyboardSymbol.delete) {
        _uiData.repeatPasscode.isNotEmpty
            ? _uiData.repeatPasscode = _uiData.repeatPasscode
                .substring(0, _uiData.repeatPasscode.length - 1)
            : _uiData.passcode =
                _uiData.passcode.substring(0, _uiData.passcode.length - 1);
      } else if (event.symbol != KeyboardSymbol.empty) {
        String symbolStr = mapKeyboarSymbol(event.symbol);
        if (_uiData.passcode.length != _uiData.totalSizeOfPasscode) {
          _uiData.passcode += symbolStr;
        } else {
          _uiData.repeatPasscode += symbolStr;
        }
        if (_uiData.passcode.length == _uiData.repeatPasscode.length &&
            _uiData.passcode != _uiData.repeatPasscode) {
          Future.delayed(Duration(milliseconds: 1500)).then((_) {
            sink.add(ResetUIDataEvent());
          });
        }
      }
      return _uiData;
    });

    _passcode =
        Observable.merge([numberPressed, initPasscodeData]);

    sink.add(InitEvent());
  }
}

class PasscodeUIData {
  final totalSizeOfPasscode = 5;

  String passcode;
  String repeatPasscode;

  final keyboardSymbols = [
    KeyboardSymbol.one,
    KeyboardSymbol.two,
    KeyboardSymbol.three,
    KeyboardSymbol.four,
    KeyboardSymbol.five,
    KeyboardSymbol.six,
    KeyboardSymbol.seven,
    KeyboardSymbol.eight,
    KeyboardSymbol.nine,
    KeyboardSymbol.empty,
    KeyboardSymbol.zero,
    KeyboardSymbol.delete
  ];

  PasscodeUIData({this.passcode = '', this.repeatPasscode = ''});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasscodeUIData &&
          runtimeType == other.runtimeType &&
          passcode == other.passcode &&
          repeatPasscode == other.repeatPasscode;

  @override
  int get hashCode => passcode.hashCode ^ repeatPasscode.hashCode;

  Color getFilledColor(BuildContext context) {
    if (passcode.length == totalSizeOfPasscode &&
        repeatPasscode.length == totalSizeOfPasscode &&
        passcode != repeatPasscode) {
      return Colors.red;
    } else {
      return Theme.of(context).primaryColor;
    }
  }
}

class PasscodeEvent {}

class InitEvent extends PasscodeEvent {}

class NumberPressedEvent extends PasscodeEvent {
  final KeyboardSymbol symbol;

  NumberPressedEvent(this.symbol);
}

class ResetUIDataEvent extends PasscodeEvent {}

enum KeyboardSymbol {
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  empty,
  zero,
  delete
}
