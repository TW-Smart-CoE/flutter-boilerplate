import 'package:first_demo/common/utils/http_client.dart';
import 'package:first_demo/common/utils/token_store.dart';
import 'package:first_demo/pages/animal_image/api.dart';
import 'package:first_demo/pages/auth/api.dart';
import 'package:first_demo/pages/moments/api.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  // Core
  getIt.registerSingleton<TokenStore>(TokenStore());
  getIt.registerSingleton<HttpClient>(HttpClient());

  // APIs
  getIt.registerLazySingleton<AuthApi>(
    () => AuthApi(getIt<HttpClient>().dio),
  );
  getIt.registerLazySingleton<AnimalApi>(
    () => AnimalApi(getIt<HttpClient>().dio),
  );
  getIt.registerLazySingleton<MomentsApi>(
    () => MomentsApi(getIt<HttpClient>().dio),
  );
}
