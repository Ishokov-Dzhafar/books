import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../blocs/book_detailed_bloc.dart';
import '../localization_strings.dart' as local;

class BookDetailedScreen extends StatefulWidget {
  ///Route name for Navigator
  static const String routeName = '/bookDetailedScreen';

  BookDetailedBloc _bloc;

  //TODO не хватило времени на подбор инструмента для DI, но я бы попробовал https://github.com/google/inject.dart
  BookDetailedScreen() {
    _bloc = BookDetailedBloc();
  }

  @override
  _BookDetailedScreenState createState() => _BookDetailedScreenState();
}

class _BookDetailedScreenState extends State<BookDetailedScreen> {

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final BookArgument args = ModalRoute.of(context).settings.arguments;
      if (args != null) {
        widget._bloc.sink.add(InitEvent(BookDetailedUIData(
            price: args.price,
            description: args.description,
            imageUrl: args.imageUrl)));
      }
    });
    widget._bloc.successBuy.listen((_) {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          height: 150.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              Icon(
                Icons.thumb_up,
                size: 48.0,
                color: Colors.amber,
              ),
              RaisedButton(
                child: Text(local.ru['success_buying']),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<BookDetailedUIData>(
        stream: widget._bloc.uiData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              child: Text(local.ru['error_loading_book']),
            );
          }
          if (MediaQuery.of(context).orientation == Orientation.portrait) {
            return BookDetailedPortrait(snapshot.data, widget._bloc);
          } else {
            return BookDetailedLandscape(snapshot.data, widget._bloc);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget._bloc.dispose();
  }
}

class BookArgument {
  final int price;
  final String description;
  final String imageUrl;

  BookArgument(
      {@required this.price,
      @required this.description,
      @required this.imageUrl})
      : assert(price != null),
        assert(description != null),
        assert(imageUrl != null);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BookArgument &&
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

class BookDetailedPortrait extends StatelessWidget {
  final BookDetailedUIData uiData;
  final BookDetailedBloc _bloc;

  BookDetailedPortrait(this.uiData, this._bloc);

  @override
  Widget build(BuildContext context) {
    var imageHeight = MediaQuery.of(context).size.height / 3;
    var contentPadding = 16.0;


    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(contentPadding),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 16.0),
                child: Image.network(
                  uiData.imageUrl,
                  height: imageHeight,
                )),
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: Text(
                uiData.description,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 2*contentPadding,
              child: RaisedButton(
                child: Text('${local.ru['buy']} ${uiData.price} \u{20BD}'),
                onPressed: () {
                  _bloc.sink.add(BuyEvent());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookDetailedLandscape extends StatelessWidget {
  final BookDetailedUIData uiData;
  final BookDetailedBloc _bloc;

  BookDetailedLandscape(this.uiData, this._bloc);

  @override
  Widget build(BuildContext context) {
    var imageWidth = MediaQuery.of(context).size.width / 3;
    var imageRightInset = 16.0;
    var contentPadding = 16.0;
    var descriptionWidth = MediaQuery.of(context).size.width -
        imageWidth -
        imageRightInset -
        2 * contentPadding;

    return Container(
      padding: EdgeInsets.all(contentPadding),
      child: Row(
        children: [
          Container(
              margin: EdgeInsets.only(right: imageRightInset),
              child: Image.network(
                uiData.imageUrl,
                width: imageWidth,
              )),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: descriptionWidth,
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    uiData.description,
                    textAlign: TextAlign.justify,
                  ),
                ),
                Container(
                  width: descriptionWidth,
                  child: RaisedButton(
                    child: Text('${local.ru['buy']} ${uiData.price} \u{20BD}'),
                    onPressed: () {
                      _bloc.sink.add(BuyEvent());
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
