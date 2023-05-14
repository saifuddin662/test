import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../../core/di/core_providers.dart';
import '../../../../core/di/singleton_provider.dart';
import '../../../../core/local/services/local_pref_service.dart';
import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../../../../utils/device_utils.dart';
import '../../../../utils/pref_keys.dart';
import 'api/model/validate_reg_otp_request.dart';
import 'api/model/validate_reg_otp_response.dart';
import 'api/validate_reg_otp_data_source.dart';

class ValidateRegOtpController extends StateNotifier<AsyncValue<ValidateRegOtpResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  final LocalPrefService _prefs;

  ValidateRegOtpController(this._ref, this._prefs) : super(AsyncData(ValidateRegOtpResponse()));

  Future<void> validateRegOtp(String otp) async {
    try {
      state = const AsyncLoading();

      String deviceId = await DeviceUtils().uuid();
      String? receiverInfo = _ref.read(globalDataControllerProvider).phoneNo;
      String otpRef = _ref.read(globalDataControllerProvider).otpRef;

      final ValidateRegOtpRequest validateRegOtpRequest = ValidateRegOtpRequest(
        deviceId: deviceId,
        otp: otp,
        otpReferenceId: otpRef,
        receiverInfo: receiverInfo,
      );

      final response = await _ref.read(validateRegOtpDataSourceProvider).validateRegOtp(validateRegOtpRequest);

      safeApiCall<ValidateRegOtpResponse>(response, onSuccess: (response) {

        state = AsyncData(response!);
        _prefs.setString(PrefKeys.keyPhoneNo, receiverInfo);
        log.info("REG OTP-----> ${response.otpReference}");

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

final validateRegOtpControllerProvider = StateNotifierProvider<ValidateRegOtpController, AsyncValue<ValidateRegOtpResponse>>((ref) {
  final prefs = ref.watch(localPrefProvider);
  return ValidateRegOtpController(ref, prefs);
}
);