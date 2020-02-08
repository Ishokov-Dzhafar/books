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
        highlightColor: Colors.black.withOpacity(0.1),
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
