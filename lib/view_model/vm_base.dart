import 'dart:async';

import 'package:rxdart/rxdart.dart';

///Abstract class for Base View Model
abstract class VMBase<T> {
  final _controller = BehaviorSubject<T>();

  StreamSink<T> get sink => _controller.sink;
  Observable<T> get events => _controller.stream;

  ///Dispose method for clearing all controllers
  void dispose(){
    _controller.close();
  }
}