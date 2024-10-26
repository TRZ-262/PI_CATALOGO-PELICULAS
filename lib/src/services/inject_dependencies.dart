import 'package:welcome_to_flutter/src/controllers/settings_repository_impl.dart';
import 'package:welcome_to_flutter/src/get_it/get_it.dart';
import '../controllers/settings_repository.dart';
import 'package:hive/hive.dart';

Future<void> injectDependencies() async {
  final box = await Hive.openBox<bool>('settingsBox');

  GetIt.I.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(box),
  );
}
