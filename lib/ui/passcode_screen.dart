import 'package:flutter/material.dart';
import 'components/numeric_keyboard.dart';


class PasscodeScreen extends StatefulWidget {
  ///Route name for Navigator
  static const String routeName = '/quickAccessPassword';
  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        //padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NumericKeyboard(onPressedBtn: (number) {
              print('PRESSED $number');
            },),
          ],
        ),
      ),
    );
  }
}
