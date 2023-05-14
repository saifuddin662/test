import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../core/di/core_providers.dart';
import '../../../core/di/singleton_provider.dart';
import '../../../core/flavor/flavor_provider.dart';
import '../../../core/local/services/local_pref_service.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import '../../../utils/device_utils.dart';
import '../../../utils/pref_keys.dart';
import 'api/check_otp_input_data_source.dart';
import 'api/model/device_validate_request.dart';
import 'api/model/device_validate_response.dart';

class CheckOtpInputController extends StateNotifier<AsyncValue<DeviceValidateResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  final LocalPrefService _prefs;

  CheckOtpInputController(this._ref, this._prefs) : super(AsyncData(DeviceValidateResponse()));

  Future<void> validateCheckOtp(String otpInput) async {
    try {
      state = const AsyncLoading();

      String deviceId = await DeviceUtils().uuid();
      String otpRef = _ref.read(globalDataControllerProvider).otpRef;
      String? receiverInfo = _prefs.getString(PrefKeys.keyPhoneNo);
      String? walletNo = _prefs.getString(PrefKeys.keyMsisdn);
      //String userType = _ref.read(flavorProvider).name; // todo shaj userType XXX un comment this
      String userType = 'CUSTOMER';

      DeviceValidateRequest deviceValidateRequest = DeviceValidateRequest(
        deviceId: deviceId,
        otp: otpInput,
        otpReferenceId: otpRef,
        receiverInfo: receiverInfo,
        userType: userType,
        walletNo: walletNo,
      );

      final response = await _ref.read(checkOtpInputDataSourceProvider).validateCheckOtp(deviceValidateRequest);

      safeApiCall<DeviceValidateResponse>(response, onSuccess: (response) {

        state = AsyncData(response!);

        _prefs.setString(PrefKeys.keyJwt,response.jwt!);
        _prefs.setString(PrefKeys.keyUserName,response.userLoginInfo?.userName);
        //_prefs.setBool(PrefKeys.keyIsUserLoggedIn, true);
        _ref.read(globalDataControllerProvider).msisdn = walletNo!;

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

final checkOtpInputControllerProvider = StateNotifierProvider<CheckOtpInputController, AsyncValue<DeviceValidateResponse>>((ref) {
  final prefs = ref.watch(localPrefProvider);
  return CheckOtpInputController(ref, prefs);
}
);