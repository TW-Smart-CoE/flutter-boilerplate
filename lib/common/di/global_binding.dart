import 'package:dio/dio.dart';
import 'package:first_demo/common/network/animal/animal_api.dart';
import 'package:first_demo/common/network/dio_client.dart';
import 'package:get/get.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DioClient(), permanent: true);
    // apis
    Get.lazyPut(() => AnimalApi(findDio()), fenix: true);
  }

  Dio findDio() => Get.find<DioClient>().dio;
}
