import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceUtils {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<String> uuid() async {
    String id = 'unknown';
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      id = "A${encryptId(androidInfo.id)}";
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      id = "I${encryptId(iosInfo.identifierForVendor ?? '')}";
    }
    return id;
  }

  Future<String> name() async {
    String name = 'unknown';
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      name = androidInfo.model;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      name = iosInfo.utsname.machine ?? '';
    }
    return name;
  }

  Future<String> type() async {
    String type = 'unknown';
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      type = androidInfo.type;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      type = iosInfo.name ?? '';
    }
    return type;
  }

  String encryptId(String value) => base64Encode(utf8.encode(sha256.convert(utf8.encode(value)).toString()));
}