import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../core/di/core_providers.dart';
import '../../../core/local/services/local_pref_service.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import '../../../utils/pref_keys.dart';
import 'api/model/register_request.dart';
import 'api/model/register_response.dart';
import 'api/register_data_source.dart';

class RegisterController extends StateNotifier<AsyncValue<RegisterResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  final LocalPrefService _prefs;

  RegisterController(this._ref, this._prefs) : super(AsyncData(RegisterResponse()));

  Future<void> getWallet(RegisterRequest registerRequest, BuildContext context) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(registerDataSourceProvider).getWallet(registerRequest);

      safeApiCall<RegisterResponse>(response, onSuccess: (response) {

        state = AsyncData(response!);
        log.info("saving msisdn no : ${response.walletNo} in prefs");
        _prefs.setString(PrefKeys.keyMsisdn, response.walletNo ?? "");
        _prefs.setString(PrefKeys.keyPhoneNo, response.phoneNo ?? "");

      }, onError: (code, message) {
        state = AsyncError(
          message,
          StackTrace.current,
        );
        log.info("------------------------- ERROR > code: $code, msg: $message");
      });
    } on Failure {
      state = AsyncError("error",StackTrace.current);
    }
  }
}

final registerControllerProvider = StateNotifierProvider<RegisterController, AsyncValue<RegisterResponse>>((ref) {
  final prefs = ref.watch(localPrefProvider);
  return RegisterController(ref, prefs);
}
);