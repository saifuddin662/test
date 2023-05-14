import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../core/di/core_providers.dart';
import '../../../../core/di/singleton_provider.dart';
import '../../../../core/firebase/notification/firebase_push_notification.dart';
import '../../../../core/local/services/local_pref_service.dart';
import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../../../../utils/device_utils.dart';
import 'api/model/reg_otp_request.dart';
import 'api/model/reg_otp_response.dart';
import 'api/reg_otp_input_data_source.dart';

class RegOtpInputController extends StateNotifier<AsyncValue<RegOtpResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  final LocalPrefService _prefs;

  RegOtpInputController(this._ref, this._prefs) : super(AsyncData(RegOtpResponse()));

  Future<void> requestRegOtp() async {
    try {
      state = const AsyncLoading();

      final DeviceInfoPlugin deviceInfoData = DeviceInfoPlugin();
      final fcmToken = await _ref.read(firebasePushNotificationProvider).getFirebaseToken();
      DeviceInfo deviceInfo = DeviceInfo();
      RegOtpRequest regOtpRequest = RegOtpRequest();

      String deviceId = "";
      String? firebaseDeviceToken = "";
      String manufacturer = "";
      String? modelName = "";
      String? osFirmWireBuild = "";
      String osName = "";
      String? osVersion = "";
      String rootDevice = "0";

      String? deviceType = "";
      String mno = "";
      String? phoneNumber = "";
      String serviceName = "";

      deviceId = await DeviceUtils().uuid();
      mno = _ref.read(globalDataControllerProvider).mno;
      phoneNumber = _ref.read(globalDataControllerProvider).phoneNo;
      firebaseDeviceToken = fcmToken;
      rootDevice = "0"; //todo shaj need to add root checker
      serviceName = "REGISTRATION";

      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfoData.androidInfo;

        manufacturer = androidInfo.manufacturer;
        modelName = androidInfo.model;
        osFirmWireBuild = androidInfo.hardware;
        osName = "Android";
        osVersion = androidInfo.version.release;
        deviceType = "ANDROID";

      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfoData.iosInfo;

        manufacturer = "Apple";
        modelName = iosInfo.name;
        osFirmWireBuild = iosInfo.identifierForVendor;
        osName = "Android";
        osVersion = iosInfo.systemVersion;
        deviceType = iosInfo.systemName;
      }

      deviceInfo = DeviceInfo(
        deviceId: deviceId,
        firebaseDeviceToken: firebaseDeviceToken,
        manufacturer: manufacturer,
        modelName: modelName,
        osFirmWireBuild: osFirmWireBuild,
        osName: osName,
        osVersion: osVersion,
        rootDevice: int.parse(rootDevice),
      );

      regOtpRequest = RegOtpRequest(
        deviceInfo: deviceInfo,
        deviceType: deviceType,
        mno: mno,
        phoneNumber: phoneNumber,
        serviceName: serviceName

      );

      final response = await _ref.read(regOtpInputDataSourceProvider).requestRegOtp(regOtpRequest);

      safeApiCall<RegOtpResponse>(response, onSuccess: (response) {

        state = AsyncData(response!);

        log.info("REG OTP-----> ${response.otpReference}");

        _ref.read(globalDataControllerProvider).otpRef = response.otpReference!;
        _ref.read(globalDataControllerProvider).isOtpInputEnabled = response.isOtpInputEnabled!;

        //_prefs.setString(PrefKeys.keyJwt,response.jwt!);
        //_prefs.setString(PrefKeys.keyUserName,response.userLoginInfo?.userName);
        //_prefs.setBool(PrefKeys.keyIsUserLoggedIn, true);
        //_ref.read(globalDataControllerProvider).msisdn = walletNo!;

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

final regOtpInputControllerProvider = StateNotifierProvider<RegOtpInputController, AsyncValue<RegOtpResponse>>((ref) {
  final prefs = ref.watch(localPrefProvider);
  return RegOtpInputController(ref, prefs);
}
);