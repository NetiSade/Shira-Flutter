import 'package:get_it/get_it.dart';

import 'services/db_service.dart';

GetIt serviceLocator = GetIt.instance;

void setupLocator() {
  serviceLocator.registerLazySingleton(() => DbService());
}
