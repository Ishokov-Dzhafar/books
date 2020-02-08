import 'package:flutter/material.dart';
import 'components/numeric_keyboard.dart';
import 'components/passcode_indicator.dart';
import '../view_model/passcode_vm.dart';

class PasscodeScreen extends StatefulWidget {
  ///Route name for Navigator
  static const String routeName = '/quickAccessPassword';

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  PasscodeVM _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PasscodeVM();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<PasscodeUIData>(
          stream: _viewModel.passcode,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var uiData = snapshot.data;
              return Container(
                alignment: Alignment.bottomCenter,
                //padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: _createIndicatorWithText(
                          'Задайте пароль быстрого доступа',
                          uiData.totalSizeOfPasscode,
                          uiData.passcode.length,
                          uiData.getFilledColor(context)),
                    ),
                    Container(
                      child: _createIndicatorWithText(
                          'Повторите пароль быстрого доступа',
                          uiData.totalSizeOfPasscode,
                          uiData.repeatPasscode.length,
                          uiData.getFilledColor(context)),
                    ),
                    NumericKeyboard(
                      onPressedBtn: (symbol) {
                        print('PRESSED $symbol');
                        _viewModel.sink.add(NumberPressedEvent(symbol));
                      },
                      symbols: uiData.keyboardSymbols,
                    ),
                  ],
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Widget _createIndicatorWithText(
      String text, int totalCount, int filledCount, Color filledColor) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(text),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 2 / 5,
          child: PasscodeIndicator(
            totalCount: totalCount,
            filledCount: filledCount,
            filledColor: filledColor,
            disabledColor: Theme.of(context).disabledColor,
          ),
        ),
      ],
    );
  }
}
