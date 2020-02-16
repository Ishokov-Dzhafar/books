import 'package:books/repositories/books/books.dart';
import 'package:rxdart/rxdart.dart';

import '../data/rest_api/responses/book_res.dart';
import '../repositories/books/books_repository.dart';
import 'bloc_base.dart';

class BooksCatalogBloc extends BlocBase<BooksEvent> {

  final BooksRepository _booksRepository;

  BooksCatalogUIData _uiData;

  Observable<String> _errors;
  Stream<String> get errors => _errors;

  Observable<BooksCatalogUIData> _uiDataObservable;
  Stream<BooksCatalogUIData> get uiDataObservable => _uiDataObservable;


  BooksCatalogBloc(this._booksRepository) {

    _uiData = BooksCatalogUIData();

    var initObservable = events.where((event) => event is InitEvent)
        .asyncMap((_) async => await _booksRepository.fetchBooks())
        .asBroadcastStream();
    var searchEvents = events
        .where((event) => event is SearchEvent)
        .map((event) => event as SearchEvent)
        .asBroadcastStream();
    var search = searchEvents
        .asyncMap((event) async {
          _uiData.search = event.search;
          _uiData.books = await _booksRepository.searchBook(event.search);
          _uiData.isLoadingBooks = false;
          return _uiData;
    });

    var refreshEvents = events
        .where((event) => event is RefreshEvent && !_uiData.isLoadingBooks)
        .asBroadcastStream();

    var refresh = refreshEvents
        .asyncMap((_) async {
          print('REEEEFFFFFFFFREEEESH');
          return await _booksRepository.fetchBooks();
    });


    var loadingObservable = Observable.merge([
      events.where((event) => event is InitEvent).map((_) {
        _uiData.isLoadingBooks = true;
        return _uiData;
      }),
      initObservable.map((_) {
        _uiData.isLoadingBooks = false;
        return _uiData;
      }),
      refreshEvents.map((_) {
        print('REFRESH');
        _uiData.isLoadingBooks = true;
        return _uiData;
      }),
      refresh.map((_) {
        _uiData.isLoadingBooks = false;
        return _uiData;
      }),
      searchEvents.map((_) {
        _uiData.isLoadingBooks = true;
        return _uiData;
      }),
      search,
    ]);

    _uiDataObservable = Observable.merge([
      loadingObservable,
      initObservable.where((result) => result.isSucceeded()).map((result) {
        _uiData.books = result.books;
        return _uiData;
      }),
      refresh.where((result) => result.isSucceeded())
          .asyncMap((result) async {
        _uiData.books = await _booksRepository.searchBook(_uiData.search);
        return _uiData;
      })
    ]).asBroadcastStream().shareValue();

    _errors = Observable.merge([
      initObservable,
      refresh
    ]).where((result) => !result.isSucceeded())
        .map((result) => result.errorMessage).asBroadcastStream();

    sink.add(InitEvent());
  }

}

class BooksCatalogUIData {
  List<BookRes> books;
  bool isLoadingBooks;
  String search;

  BooksCatalogUIData({this.books, this.isLoadingBooks = false, this.search = ''});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BooksCatalogUIData &&
              runtimeType == other.runtimeType &&
              books == other.books &&
              isLoadingBooks == other.isLoadingBooks;

  @override
  int get hashCode =>
      books.hashCode ^
      isLoadingBooks.hashCode;
}

class BooksEvent {}

class InitEvent extends BooksEvent {}

class RefreshEvent extends BooksEvent {}

class SearchEvent extends BooksEvent {
  final String search;

  SearchEvent(this.search);
}

