import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../../core/di/core_providers.dart';
import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../../../core/local/services/local_pref_service.dart';
import '../../../utils/pref_keys.dart';
import 'api/config_data_source.dart';
import 'api/model/config_response.dart';

class ConfigController extends StateNotifier<AsyncValue<ConfigResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  final LocalPrefService _prefs;

  ConfigController(this._ref, this._prefs) : super(AsyncData(ConfigResponse()));

  Future<void> getConfig() async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(configDataSourceProvider).getConfig();

      safeApiCall<ConfigResponse>(response, onSuccess: (response) {

        state = AsyncData(response!);

        saveDeviceBindingStatus(response);


        final serverHiddenFeatureStatus = response.clientConfig!.hiddenFeatureStatus ?? false;
        var androidHiddenFeatureStatus = false;
        var iosHiddenFeatureStatus = false;

        if (serverHiddenFeatureStatus) {
          if (Platform.isIOS) {
            iosHiddenFeatureStatus = true;
          } else {
            androidHiddenFeatureStatus = true;
          }
        }

        androidHiddenFeatureStatus ? _prefs.setBool(PrefKeys.keyHiddenFeatureAndroid, true) : _prefs.setBool(PrefKeys.keyHiddenFeatureAndroid, false);
        iosHiddenFeatureStatus ? _prefs.setBool(PrefKeys.keyHiddenFeatureIos, true) : _prefs.setBool(PrefKeys.keyHiddenFeatureIos, false);


      }, onError: (code, message) {
        state = AsyncError(
          message,
          StackTrace.current,
        );
        debugPrint("------------------------- ERROR > code: $code, msg: $message");
      });
    } on Failure {
      state = AsyncError("error",StackTrace.current);
    }
  }

  void saveDeviceBindingStatus(ConfigResponse response) {
    log.info("saving device binding status -> ${response.serverConfig!.deviceBindingEnabled!}");
    _prefs.setBool(PrefKeys.keyDeviceBinding, response.serverConfig!.deviceBindingEnabled!);
  }
}

final configControllerProvider = StateNotifierProvider<ConfigController, AsyncValue<ConfigResponse>>((ref) {
  final prefs = ref.watch(localPrefProvider);
  return ConfigController(ref, prefs);
}
);
