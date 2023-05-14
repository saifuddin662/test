import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../../core/di/core_providers.dart';
import '../../../../core/local/services/local_pref_service.dart';
import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../../../../utils/pref_keys.dart';
import 'login_data_source.dart';
import 'model/login_request.dart';
import 'model/login_response.dart';


class LoginController extends StateNotifier<AsyncValue<LoginResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  final LocalPrefService _prefs;

  LoginController(this._ref, this._prefs) : super(AsyncData(LoginResponse()));

  Future<void> login(LoginRequest loginRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(loginDataSourceProvider).login(
          LoginRequest(
              loginRequest.msisdn,
              loginRequest.pin,
              loginRequest.deviceId
          )
      );

      safeApiCall<LoginResponse>(response, onSuccess: (response) {

        state = AsyncData(response!);

        _prefs.setString(PrefKeys.keyJwt, response.jwt ?? "");

      }, onError: (code, message) {
        state = AsyncError(
          message,
          StackTrace.current,
        );
      });

    } on Failure {
      state = AsyncError("error",StackTrace.current);
    }
  }
}

final loginControllerProvider = StateNotifierProvider<LoginController, AsyncValue<LoginResponse>>((ref) {
  final prefs = ref.watch(localPrefProvider);
  return LoginController(ref, prefs);
});