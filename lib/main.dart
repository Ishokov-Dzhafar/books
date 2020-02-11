import 'package:flutter/material.dart';
import 'ui/passcode_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.black,
        primarySwatch: Colors.blue,
        highlightColor: Colors.blue.withOpacity(0.1),
        textTheme: TextTheme(
          subtitle: TextStyle(color: Colors.black, fontSize: 18.0),
          overline: TextStyle(color: Colors.black),
          body1: TextStyle(color: Colors.black),
          body2: TextStyle(color: Colors.black),
          button: TextStyle(color: Colors.blue,
            letterSpacing: 1.5,
            fontWeight: FontWeight.normal,
            fontSize: 20.0,
          ),
          caption: TextStyle(color: Colors.black),
          display1: TextStyle(color: Colors.black),
          display2: TextStyle(color: Colors.black),
          display3: TextStyle(color: Colors.black),
          display4: TextStyle(color: Colors.black),
          headline: TextStyle(color: Colors.black),
          subhead: TextStyle(
              color: Colors.black,
              fontSize: 16.0),
          title: TextStyle(color: Colors.white,
              fontSize: 20.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal
          ),
        ),
      ),

      home: PasscodeScreen(),
    );
  }
}