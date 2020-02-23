import 'package:dio/dio.dart';

import '../../app_config.dart';
import 'rest_api.dart';

class DioRestApi implements RestApi {

  final Dio _httpClient;

  DioRestApi(this._httpClient);

  @override
  Future<Response> fetchBooks() async {
    return await _httpClient.get('${baseUrl}testBook.json');
  }
}