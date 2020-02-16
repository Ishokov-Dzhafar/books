import 'package:books/app_config.dart';
import 'package:books/data/rest_api/rest_api.dart';
import 'package:dio/dio.dart';

class DioRestApi implements RestApi {

  final Dio _httpClient;

  DioRestApi(this._httpClient);

  @override
  Future<Response> fetchBooks() async {
    return await _httpClient.get('${baseUrl}testBook.json');
  }
}