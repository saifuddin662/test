import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../core/di/core_providers.dart';
import '../../core/di/singleton_provider.dart';
import '../../core/firebase/notification/firebase_push_notification.dart';
import '../../core/local/services/local_pref_service.dart';
import '../../core/networking/error/failure.dart';
import '../../core/networking/safe_api_call.dart';
import '../../utils/device_utils.dart';
import '../../utils/pref_keys.dart';
import 'api/device_reg_data_source.dart';
import 'api/model/device_reg_model.dart';
import 'api/model/device_reg_response.dart';

class ConfirmPinController
    extends StateNotifier<AsyncValue<DeviceRegResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  final LocalPrefService _prefs;

  ConfirmPinController(this._ref, this._prefs)
      : super(AsyncData(DeviceRegResponse()));

  Future<void> checkDevice(String pinInput) async {
    try {
      state = const AsyncLoading();

      final DeviceInfoPlugin deviceInfoData = DeviceInfoPlugin();
      // final fcmToken = await _ref.read(firebasePushNotificationProvider).getFirebaseToken(); // todo shaj userType XXX uncomment this
      final fcmToken = 'dummy_token';
      DeviceInfo deviceInfo = DeviceInfo();
      DeviceRegModel deviceRegModel = DeviceRegModel();

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
      String? msisdn = "";
      String? phoneNumber = "";
      String pin = "";
      String serviceName = "";

      deviceId = await DeviceUtils().uuid();
      mno = _ref.read(globalDataControllerProvider).mno;
      msisdn = _prefs.getString(PrefKeys.keyMsisdn);
      phoneNumber = _prefs.getString(PrefKeys.keyPhoneNo);
      firebaseDeviceToken = fcmToken;
      rootDevice = "0"; //todo shaj need to add root checker
      pin = pinInput;
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

      deviceRegModel = DeviceRegModel(
        deviceInfo: deviceInfo,
        deviceType: deviceType,
        mno: mno,
        msisdn: msisdn,
        phoneNumber: phoneNumber,
        pin: pin,
        serviceName: serviceName,
      );

      final response = await _ref.read(deviceRegDataSourceProvider).checkDevice(deviceRegModel);

      safeApiCall<DeviceRegResponse>(response, onSuccess: (response) {
        state = AsyncData(response!);

        _ref.read(globalDataControllerProvider).otpRef = response.otpReference!;
        _ref.read(globalDataControllerProvider).isOtpInputEnabled = response.isOtpInputEnabled!;

      }, onError: (code, message) {
        state = AsyncError(
          message,
          StackTrace.current,
        );
        log.info("------------------------- ERROR > code: $code, msg: $message");
      });
    } on Failure {
      state = AsyncError("error", StackTrace.current);
    }
  }
}

final confirmPinControllerProvider =
    StateNotifierProvider<ConfirmPinController, AsyncValue<DeviceRegResponse>>(
        (ref) {
  final prefs = ref.watch(localPrefProvider);
  return ConfirmPinController(ref, prefs);
});
