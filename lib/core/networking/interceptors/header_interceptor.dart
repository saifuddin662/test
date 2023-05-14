import 'dart:io';

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../utils/device_utils.dart';
import '../../../utils/pref_keys.dart';
import '../../../utils/shared_pref.dart';

class HeaderInterceptor extends InterceptorsWrapper {
  final SharedPref _sharedPref = SharedPref();

  Future<String> getToken() async {
    var token = await _sharedPref.readString(PrefKeys.keyJwt) ?? "";
    return token;
  }

  Future<String> getWallet() async {
    var msisdn = await _sharedPref.readString(PrefKeys.keyMsisdn) ?? "";
    return msisdn;
  }

  Future<String> getDeviceId() async {
    var deviceId = await DeviceUtils().uuid();
    return deviceId;
  }

  Future<String> getAppLang() async {
    var appLang = await _sharedPref.readString(PrefKeys.keyAppLang) ?? "en";
    return appLang;
  }

  Future<String> getAppChannel() async {
    return Platform.isIOS ? 'IOS' : 'ANDROID';
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['Content-Type'] = 'application/json';
    options.headers['Cache-Control'] = 'no-cache';
    options.headers['requestTime'] = '';

    await getToken().then((value) => value.isNotEmpty
        ? options.headers['Authorization'] = "Bearer $value"
        : null);

    await getWallet().then(
        (value) => value.isNotEmpty ? options.headers['msisdn'] = value : null);

    await getDeviceId().then((value) =>
        value.isNotEmpty ? options.headers['deviceId'] = value : null);

    await getAppLang().then((value) =>
        value.isNotEmpty ? options.headers['Accept-Language'] = value : 'en');

    await getAppChannel().then((value) =>
        value.isNotEmpty ? options.headers['channel'] = value : 'ANDROID');

    await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      options.headers['version'] = packageInfo.version;
    });

    super.onRequest(options, handler);
  }
}
