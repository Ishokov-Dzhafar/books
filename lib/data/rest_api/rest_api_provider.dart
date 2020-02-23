import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'rest_api.dart';
import '../../app_config.dart' as config;
import 'dio_rest_api.dart';

class RestApiProvider {
  static final RestApiProvider _instance = RestApiProvider._internal();

  RestApi _restApi;

  RestApi get restApi => _restApi;


  RestApiProvider._internal() {
    _restApi = DioRestApi(_createHttpClient(config.baseUrl));
  }

  Dio _createHttpClient(String baseUrl) {
    var options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
    );
    var _dio = Dio(options);

    _dio.interceptors
        .add(InterceptorsWrapper(
        onRequest: (options) {
          debugPrint("requestHeaders: ${jsonEncode(options.headers)}");
          debugPrint("requestData: ${jsonEncode(options.data)}");
          debugPrint("requestExtra: ${jsonEncode(options.extra)}");
          debugPrint("requestPath: ${jsonEncode(options.path)}");
          debugPrint("ContentType: ${options.contentType.toString()}");
          debugPrint("requestQuery: ${jsonEncode(options.queryParameters)}");
          debugPrint("requestUrl: ${jsonEncode(options.baseUrl)}");

          return options;
        },
        onResponse: (response) {
          var encoder = JsonEncoder.withIndent('  ');
          debugPrint("responseBody: ${encoder.convert(response.data)}");
          debugPrint("responseHeader: ${response.headers.toString()}");
          debugPrint("responseStatusCode: ${jsonEncode(response.statusCode)}");
          return response;
        },
        onError: (e) {
          debugPrint("errorMessage: ${e.message}");
          if (e.response != null) {
            var encoder = JsonEncoder.withIndent('  ');
            debugPrint("responseBody: ${encoder.convert(e.response.data)}");
            debugPrint("responseHeader: ${e.response.headers.toString()}");
            debugPrint(
                "responseStatusCode: ${jsonEncode(e.response.statusCode)}");
          }
          return e;
        }));
    return _dio;
  }

  factory RestApiProvider() => _instance;

}