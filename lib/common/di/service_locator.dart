import 'package:first_demo/common/network/animal/api.dart';
import 'package:first_demo/common/network/dio_client.dart';
import 'package:first_demo/common/network/moments/api.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Core
  getIt.registerSingleton<DioClient>(DioClient());

  // APIs
  getIt.registerLazySingleton<AnimalApi>(
    () => AnimalApi(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<MomentsApi>(
    () => MomentsApi(getIt<DioClient>().dio),
  );
}
