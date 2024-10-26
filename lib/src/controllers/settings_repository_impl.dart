import '/src/controllers/settings_repository.dart';
import 'package:hive/hive.dart';

const darkModeKey = 'darkModeKey';

class SettingsRepositoryImpl implements SettingsRepository {
  final Box<bool> _box; // PARA ALMACENAR EL VALOR BOOLEANO

  SettingsRepositoryImpl(this._box);

  @override
  bool get isDarkMode => _box.get(darkModeKey) ?? false;

  @override
  Future<void> updateDarkMode(bool isDark) async {
    await _box.put(darkModeKey, isDark);
  }
}
