import 'package:flutter/cupertino.dart';

import 'bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class BookDetailedBloc extends BlocBase<BookDetailedEvent> {

  BookDetailedUIData _uiData;

  Observable<BookDetailedUIData> _uiDataObservable;
  Stream<BookDetailedUIData> get uiData => _uiDataObservable;

  Observable<void> _successBuy;
  Stream<void> get successBuy => _successBuy;

  BookDetailedBloc(){
    var initObservable = events
        .where((event) => event is InitEvent)
        .map((event) => event as InitEvent)
        .map((event) {
          _uiData = event.uiData;
          return _uiData;
    });

    var buying = events
        .where((event) => event is BuyEvent)
        .map((event) => event as BuyEvent)
        .asyncMap((event) async {
         //TODO send to server to buy book, but in the future. In technical task this function is not written
      return;
    });


    _uiDataObservable = Observable.merge([
      initObservable,
    ]).shareValue();

    _successBuy = buying;

  }
}

class BookDetailedEvent {}

class InitEvent extends BookDetailedEvent {
  final BookDetailedUIData uiData;

  InitEvent(this.uiData);
}

class BuyEvent extends BookDetailedEvent {}

class BookDetailedUIData {
  int price;
  String description;
  String imageUrl;

  BookDetailedUIData({@required this.price,@required  this.description,@required this.imageUrl});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BookDetailedUIData &&
              runtimeType == other.runtimeType &&
              price == other.price &&
              description == other.description &&
              imageUrl == other.imageUrl;

  @override
  int get hashCode =>
      price.hashCode ^
      description.hashCode ^
      imageUrl.hashCode;
}