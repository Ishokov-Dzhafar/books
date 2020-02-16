import 'dart:io';

import 'package:books/data/rest_api/rest_api_provider.dart';
import 'package:books/repositories/books/books_repository.dart';
import 'package:flutter/material.dart';
import '../localization_strings.dart' as local;
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:rxdart/rxdart.dart';
import '../blocs/books_catalog_bloc.dart';


class BooksCatalogScreen extends StatefulWidget {
  ///Route name for Navigator
  static const String routeName = '/booksCatalogScreen';

  BooksCatalogScreen();

  @override
  _BooksCatalogScreenState createState() => _BooksCatalogScreenState();
}

class _BooksCatalogScreenState extends State<BooksCatalogScreen> {
  BooksCatalogBloc _bloc;

  final _controller = TextEditingController();

  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = Text(local.ru['books_catalog']);


  @override
  void initState() {
    super.initState();
    //TODO не хватило времени выбрать библиотеку для реализации DI
    _bloc = BooksCatalogBloc(BooksRepository(RestApiProvider().restApi));

    _controller.addListener(() {
      _bloc.sink.add(SearchEvent(_controller.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        leading: IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        ),
      ),
        body: Platform.isAndroid ? MaterialPullToRef(_bloc) : CupertinoList(_bloc),
    );
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = Icon(Icons.close);
        this._appBarTitle = TextField(
          controller: _controller,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search...'
          ),
        );
      } else {
        this._searchIcon = Icon(Icons.search);
        this._appBarTitle = Text(local.ru['books_catalog']);
        _controller.clear();
      }
    });
  }

}


class MaterialPullToRef extends StatefulWidget {

  final BooksCatalogBloc _bloc;

  MaterialPullToRef(this._bloc);

  @override
  _MaterialPullToRefState createState() => _MaterialPullToRefState();
}

class _MaterialPullToRefState extends State<MaterialPullToRef> {
  GlobalKey<RefreshIndicatorState> _key;

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BooksCatalogUIData>(
      stream: widget._bloc.uiDataObservable,
      builder: (context, snapshot) {
        _key = GlobalKey<RefreshIndicatorState>();
        widget._bloc.uiDataObservable.listen((data) {
          print('IsLoading ${data.isLoadingBooks}');
          if(data.isLoadingBooks) _key.currentState.show();
        });
        return Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: RefreshIndicator(
            key: _key,
            onRefresh: () async {
              if(!snapshot.hasData || !snapshot.data.isLoadingBooks)  {
                widget._bloc.sink.add(RefreshEvent());
              }
              await widget._bloc.uiDataObservable.firstWhere((data) => !data.isLoadingBooks);
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                var book = snapshot.data.books[index];
                return BookItem(
                  title: book.title,
                  description: book.description,
                  imageUrl: book.preview,
                  price: book.price,
                );
              },
              itemCount: snapshot.hasData && snapshot.data.books != null ? snapshot.data.books.length : 0,
            ),
          ),
        );
      }
    );
  }
}

class CupertinoList extends StatefulWidget {

  final BooksCatalogBloc _bloc;

  CupertinoList(this._bloc);

  @override
  _CupertinoListState createState() => _CupertinoListState();
}

class _CupertinoListState extends State<CupertinoList> {

  ScrollController _controller = ScrollController();
  ScrollController _listController = ScrollController();

  @override
  void initState() {
    super.initState();
    /*widget._bloc.showProgressIndicator.listen((_) {
      if(_controller.hasClients) {
        _controller.jumpTo(-100.0);
      }
    });*/
    Observable(widget._bloc.uiDataObservable
        .where((data) => data.isLoadingBooks))
        .debounceTime(Duration(seconds: 500))
        .listen((_) {
          if(_controller.hasClients) {
            _controller.jumpTo(-100.0);
          }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BooksCatalogUIData>(
      stream: widget._bloc.uiDataObservable,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CustomScrollView(
            controller: _controller,
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              cupertino.CupertinoSliverRefreshControl(
                onRefresh: () async {
                  if(!snapshot.hasData || !snapshot.data.isLoadingBooks)  {
                    print('Aaaaaaaa - ${snapshot.data.isLoadingBooks}');

                    //widget._bloc.sink.add(RefreshEvent());
                  }
                  await widget._bloc.uiDataObservable.firstWhere((data) => !data.isLoadingBooks);
                },
              ),

              SliverSafeArea(
                top: false,
                sliver: SliverList(
                         delegate: SliverChildBuilderDelegate(
                               (context, index) {
                             var book = snapshot.data.books[index];
                             return BookItem(
                               title: book.title,
                               description: book.description,
                               imageUrl: book.preview,
                               price: book.price,
                             );
                           },
                           childCount: snapshot.hasData && snapshot.data.books != null ? snapshot.data.books.length : 0,
                         ),
                       ),
              ),
              /*SliverSafeArea(
                //top: false,
                sliver: widget(
                  child: Column(
                    children: [

                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                var book = snapshot.data.books[index];
                            return BookItem(
                              title: book.title,
                              description: book.description,
                              imageUrl: book.preview,
                              price: book.price,
                            );
                          },
                          childCount: snapshot.hasData && snapshot.data.books != null ? snapshot.data.books.length : 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/
            ],
          ),
        );
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
    _listController.dispose();
    _controller.dispose();
  }
}

class BookItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final int price;

  BookItem({this.imageUrl, this.title, this.description, this.price});

  @override
  Widget build(BuildContext context) {
    double height;
    double width;
    int imageWeight;
    int contentWeight;

    if(MediaQuery.of(context).orientation == Orientation.portrait) {
      height = MediaQuery.of(context).size.height / 3;
      width = MediaQuery.of(context).size.width / 3;
      imageWeight = 5;
      contentWeight = 8;
    } else {
      height = MediaQuery.of(context).size.width / 3;
      width = MediaQuery.of(context).size.height / 3;
      imageWeight = 3;
      contentWeight = 10;
    }

    return Container(
      height: height,
      child: Row(
        mainAxisAlignment: cupertino.MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: imageWeight,
            child: Container(
                width: width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                        spreadRadius: 0.0,
                        offset: const Offset(3.0, 3.0))
                  ],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.network(
                    imageUrl,

                  ),
                )),
          ),
          Flexible(
            flex: contentWeight,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      title,
                      textAlign: TextAlign.justify,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        description,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 8,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('$price \u{20BD}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                          ],
                        ),
                        RaisedButton(
                          child: Text(local.ru['more_info']),
                          onPressed: () {
                            print('Подробнее');
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

