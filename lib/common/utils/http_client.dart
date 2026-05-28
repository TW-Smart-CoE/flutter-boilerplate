import 'package:dio/dio.dart';
import 'package:first_demo/common/utils/di.dart';
import 'package:first_demo/common/utils/token_store.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HttpClient {
  late final Dio dio;

  HttpClient() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(milliseconds: 5000),
        receiveTimeout: const Duration(milliseconds: 5000),
        contentType: 'application/json',
      ),
    );
    dio.interceptors.add(_TokenInterceptor());
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: kDebugMode,
      requestBody: kDebugMode,
      responseBody: kDebugMode,
    ));
  }
}

class _TokenInterceptor extends Interceptor {
  final TokenStore _tokenStore;

  _TokenInterceptor({TokenStore? tokenStore})
      : _tokenStore = tokenStore ?? getIt<TokenStore>();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStore.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
