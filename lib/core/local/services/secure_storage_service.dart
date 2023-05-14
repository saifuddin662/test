import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _secureStorage;

  SecureStorageService(this._secureStorage);

  Future<String?> getSecuredString(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> setSecuredString(String key, String? value) async {
    return await _secureStorage.write(key: key, value: value);
  }

  Future<void> clearSession() async {
    await _secureStorage.deleteAll();
  }
}
