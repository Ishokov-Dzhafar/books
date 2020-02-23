import 'package:books/data/storage/storage_provider.dart';
import 'package:books/repositories/profile/passcode_repository.dart';
import 'package:flutter/material.dart';
import 'components/numeric_keyboard.dart';
import 'components/passcode_indicator.dart';
import '../blocs/passcode_bloc.dart';
import 'books_catalog_screen.dart';

class PasscodeScreen extends StatefulWidget {
  ///Route name for Navigator
  static const String routeName = '/quickAccessPassword';

  PasscodeBloc _bloc;

  //TODO не хватило времени на подбор инструмента для DI, но я бы попробовал https://github.com/google/inject.dart
  PasscodeScreen() {
    _bloc = PasscodeBloc(PasscodeRepository(StorageProvider().storage));
  }


  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {

  @override
  void initState() {
    super.initState();


    widget._bloc.successCreatePasscode.listen((_) {
      ///Navigate to Books Catalog and remove backstack pages
      Navigator.of(context).pushNamedAndRemoveUntil(BooksCatalogScreen.routeName, (_) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<PasscodeUIData>(
          stream: widget._bloc.passcode,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var uiData = snapshot.data;
              if(MediaQuery.of(context).orientation == Orientation.portrait) {
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
                          widget._bloc.sink.add(NumberPressedEvent(symbol));
                        },
                        symbols: uiData.keyboardSymbols,
                      ),
                    ],
                  ),
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: NumericKeyboard(
                        onPressedBtn: (symbol) {
                          widget._bloc.sink.add(NumberPressedEvent(symbol));
                        },
                        symbols: uiData.keyboardSymbols,
                      ),
                    ),
                  ],
                );
              }
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
