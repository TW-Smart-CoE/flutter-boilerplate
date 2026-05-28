import 'package:dio/dio.dart';
import 'package:first_demo/common/states/auth_state.dart';
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

final httpClient = HttpClient();

class _TokenInterceptor extends Interceptor {
  final TokenStore _tokenStore;

  _TokenInterceptor({TokenStore? store}) : _tokenStore = store ?? tokenStore;

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

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      authState.logout();
    }
    handler.next(err);
  }
}
