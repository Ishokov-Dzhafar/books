import 'dart:core';

import 'package:flutter/material.dart';

import '../../blocs/passcode_bloc.dart' show KeyboardSymbol;
import '../../utils.dart';

///Numeric keyboard for passcode screen
class NumericKeyboard extends StatefulWidget {
  ///Callback function for pressed keyboard button
  final Function(KeyboardSymbol) onPressedBtn;
  ///Keyboard symbols
  final List<KeyboardSymbol> symbols;

  NumericKeyboard({@required this.onPressedBtn, @required this.symbols});

  @override
  _NumericKeyboardState createState() => _NumericKeyboardState();
}

class _NumericKeyboardState extends State<NumericKeyboard> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width*(4/5)
        : MediaQuery.of(context).size.height*(4/5);
    return Container(
      width: width,
      margin: EdgeInsets.all(16.0),
      child: GridView.count(
        childAspectRatio: 1.5,
        shrinkWrap: true,
        crossAxisCount: 3,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(widget.symbols.length, (index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: RawMaterialButton(
              onHighlightChanged: (_) {},
              highlightColor: Theme.of(context).highlightColor,
              shape: CircleBorder(),
              onPressed: () => widget.onPressedBtn(widget.symbols[index]),
              child: KeyboardItemWidget(widget.symbols[index]),
            ),
          );
        }),
      ),
    );
  }
}

class KeyboardItemWidget extends StatelessWidget {

  final KeyboardSymbol symbol;

  KeyboardItemWidget(this.symbol);

  @override
  Widget build(BuildContext context) {
    if(symbol == KeyboardSymbol.empty){
      return Container();
    } else if(symbol == KeyboardSymbol.delete){
      return Icon(Icons.backspace, color: Theme.of(context).primaryColor);
    } else {
      String textSymbol = mapKeyboarSymbol(symbol);
      return Text(textSymbol, textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.button.copyWith(fontSize: 30.0, color: Theme.of(context).primaryColor),
      );
    }
  }
}

