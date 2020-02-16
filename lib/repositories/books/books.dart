import '../result.dart';
import '../../data/rest_api/responses/book_res.dart';

class Books {
  Future<BooksResult> fetchBooks() {}
  Future<List<BookRes>> searchBook(String search) {}
}

class BooksResult extends Result {
  final List<BookRes> books;

  BooksResult(this.books, {String errorMessage = ''}) : super(errorMessage);
}

