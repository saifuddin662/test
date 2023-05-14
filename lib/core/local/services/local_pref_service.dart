import 'package:shared_preferences/shared_preferences.dart';

class LocalPrefService {
  final SharedPreferences _preferences;

  LocalPrefService(this._preferences);

  String? getString(String key) {
    return _preferences.getString(key);
  }

  Future<void> setString(String key, String? value) async {
    await _preferences.setString(key, value ?? '');
  }

  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  Future<void> setBool(String key, bool? value) async {
    await _preferences.setBool(key, value ?? false);
  }

  readObject(String key) async {
    return _preferences.getString(key) ?? '';
  }

  Future<void> saveObject(String key, value) async {
    await _preferences.setString(key, value);
  }

  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  Future<void> setDouble(String key, double? value) async {
    await _preferences.setDouble(key, value ?? 0.0);
  }

  Future<void> clearSession() async {
    await _preferences.clear();
  }
}
