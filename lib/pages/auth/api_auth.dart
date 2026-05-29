import 'package:dio/dio.dart';
import 'package:first_demo/pages/auth/model_auth.dart';
import 'package:retrofit/retrofit.dart';

part 'api_auth.g.dart';

@RestApi(baseUrl: 'https://postman-echo.com')
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('/post')
  Future<AuthResponse> login(@Body() AuthRequest request);
}
