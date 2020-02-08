import 'package:flutter/material.dart';

///Numeric keyboard for passcode screen
class NumericKeyboard extends StatefulWidget {
  ///Callback function for pressed keyboard button
  final Function(int number) onPressedBtn;

  NumericKeyboard({@required this.onPressedBtn});

  @override
  _NumericKeyboardState createState() => _NumericKeyboardState();
}

class _NumericKeyboardState extends State<NumericKeyboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height*(3/5),
      width: MediaQuery.of(context).size.width*(4/5),
      margin: EdgeInsets.all(16.0),
      child: GridView.count(
        childAspectRatio: 1.5,
        shrinkWrap: true,
        crossAxisCount: 3,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(12, (index) {
          if(index == 9 || index == 11) return Container();
          index == 10 ? index = 0 : index++;
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: RawMaterialButton(
              onHighlightChanged: (_) {},
              highlightColor: Theme.of(context).primaryColor,
              shape: CircleBorder(),
              onPressed: widget.onPressedBtn(index),
              child: Text(index.toString(), textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button.copyWith(fontSize: 30.0),
              ),
            ),
          );
        }),
      ),
    );
  }
}
