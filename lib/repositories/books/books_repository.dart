import 'books.dart';
import '../../data/rest_api/rest_api.dart';
import '../../data/rest_api/responses/book_res.dart';
import '../../localization_strings.dart' as local;

class BooksRepository implements Books {

  final RestApi _restClient;
  
  List<BookRes> _books;

  BooksRepository(this._restClient);


  @override
  Future<BooksResult> fetchBooks() async {
    try {
      var response = await _restClient.fetchBooks();
      switch(response.statusCode) {
        case 200:
          _books = (response.data as List)
              .map((value) => BookRes.fromJson(value as Map))
              .toList();
          return BooksResult(_books);
      }

    } on Exception catch (_) {
      return BooksResult(null, errorMessage: local.ru['check_internet_connection']);
    }
  }

  @override
  Future<List<BookRes>> searchBook(String search) async {
    return _books.where((book) => book.title.toLowerCase().startsWith(search.toLowerCase())).toList();
  }

}