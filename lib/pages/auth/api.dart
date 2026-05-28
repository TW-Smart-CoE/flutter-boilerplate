import 'package:dio/dio.dart';
import 'package:first_demo/pages/auth/model.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi(baseUrl: 'https://postman-echo.com')
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('/post')
  Future<AuthResponse> login(@Body() AuthRequest request);
}
