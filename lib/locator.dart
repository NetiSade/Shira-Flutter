import 'package:get_it/get_it.dart';

import 'services/user_data_service.dart';
import 'services/db_service.dart';

GetIt serviceLocator = GetIt.instance;

void setupLocator() {
  serviceLocator.registerLazySingleton(() => DbService());
  serviceLocator.registerLazySingleton(() => UserDataService());
}
