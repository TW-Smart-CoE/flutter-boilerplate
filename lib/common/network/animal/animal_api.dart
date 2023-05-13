import 'package:dio/dio.dart';
import 'package:first_demo/common/network/animal/model/animal.dart';
import 'package:retrofit/retrofit.dart';

part 'animal_api.g.dart';

@RestApi()
abstract class AnimalApi {
  factory AnimalApi(Dio dio, {String baseUrl}) = _AnimalApi;

  @GET('https://api.the{animal}api.com/v1/images/search')
  Future<List<Animal>> getAnimals(
    @Path('animal') String animal, {
    @Query('limit') int limit = 20,
    @Query('page') int page = 1,
    @Query('order') String order = 'desc',
  });
}
