import 'package:flutter/material.dart';
import 'components/numeric_keyboard.dart';
import 'components/passcode_indicator.dart';
import '../blocs/passcode_bloc.dart';

class PasscodeScreen extends StatefulWidget {
  ///Route name for Navigator
  static const String routeName = '/quickAccessPassword';

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  PasscodeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PasscodeBloc();

    _bloc.successCreatePasscode.listen((_) {
      //TODO navigate to books screen
      print('Create passcode successeded');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<PasscodeUIData>(
          stream: _bloc.passcode,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var uiData = snapshot.data;
              return Container(
                alignment: Alignment.bottomCenter,
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
                        _bloc.sink.add(NumberPressedEvent(symbol));
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
