import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../local/services/local_pref_service.dart';
import '../local/services/secure_storage_service.dart';
import '../networking/base/base_api.dart';
import '../networking/base/base_data_source.dart';
import 'network_provider.dart';
/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 10,January,2023.

final baseApiProvider = Provider<BaseApi>((ref) {
  final dio = ref.watch(dioProvider);
  return BaseApi(dio);
});

final baseDataSourceProvider = Provider<BaseDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return BaseDataSource(dio);
});

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage()); //todo shaj need to on encryption

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(ref.read(secureStorageProvider));
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final localPrefProvider = Provider((ref){
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return LocalPrefService(sharedPreferences);
});

final navigatorKeyProvider = Provider(
      (_) => GlobalKey<NavigatorState>(),
);

final loggerProvider = Provider.family<Logger,String>((ref,name) {
  return Logger(name);
});

final localeStateProvider = StateProvider((ref) => 0);

final fontFamilyProvider = StateProvider((ref) => 'Akzentica');

Future<void> initializeProviders(ProviderContainer container) async {
  container.read(secureStorageProvider);
  //await container.read(sharedPreferencesProvider.future);
}
