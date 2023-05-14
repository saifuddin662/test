import 'dart:convert';

RegOtpRequest regOtpRequestFromJson(String str) => RegOtpRequest.fromJson(json.decode(str));

String regOtpRequestToJson(RegOtpRequest data) => json.encode(data.toJson());

class RegOtpRequest {
  RegOtpRequest({
    this.deviceInfo,
    this.deviceType,
    this.mno,
    this.phoneNumber,
    this.serviceName,
  });

  DeviceInfo? deviceInfo;
  String? deviceType;
  String? mno;
  String? phoneNumber;
  String? serviceName;

  RegOtpRequest copyWith({
    DeviceInfo? deviceInfo,
    String? deviceType,
    String? mno,
    String? phoneNumber,
    String? serviceName,
  }) =>
      RegOtpRequest(
        deviceInfo: deviceInfo ?? this.deviceInfo,
        deviceType: deviceType ?? this.deviceType,
        mno: mno ?? this.mno,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        serviceName: serviceName ?? this.serviceName,
      );

  factory RegOtpRequest.fromJson(Map<String, dynamic> json) => RegOtpRequest(
    deviceInfo: json["deviceInfo"] == null ? null : DeviceInfo.fromJson(json["deviceInfo"]),
    deviceType: json["deviceType"],
    mno: json["mno"],
    phoneNumber: json["phoneNumber"],
    serviceName: json["serviceName"],
  );

  Map<String, dynamic> toJson() => {
    "deviceInfo": deviceInfo?.toJson(),
    "deviceType": deviceType,
    "mno": mno,
    "phoneNumber": phoneNumber,
    "serviceName": serviceName,
  };
}

class DeviceInfo {
  DeviceInfo({
    this.deviceId,
    this.firebaseDeviceToken,
    this.manufacturer,
    this.modelName,
    this.osFirmWireBuild,
    this.osName,
    this.osVersion,
    this.rootDevice,
  });

  String? deviceId;
  String? firebaseDeviceToken;
  String? manufacturer;
  String? modelName;
  String? osFirmWireBuild;
  String? osName;
  String? osVersion;
  int? rootDevice;

  DeviceInfo copyWith({
    String? deviceId,
    String? firebaseDeviceToken,
    String? manufacturer,
    String? modelName,
    String? osFirmWireBuild,
    String? osName,
    String? osVersion,
    int? rootDevice,
  }) =>
      DeviceInfo(
        deviceId: deviceId ?? this.deviceId,
        firebaseDeviceToken: firebaseDeviceToken ?? this.firebaseDeviceToken,
        manufacturer: manufacturer ?? this.manufacturer,
        modelName: modelName ?? this.modelName,
        osFirmWireBuild: osFirmWireBuild ?? this.osFirmWireBuild,
        osName: osName ?? this.osName,
        osVersion: osVersion ?? this.osVersion,
        rootDevice: rootDevice ?? this.rootDevice,
      );

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => DeviceInfo(
    deviceId: json["deviceId"],
    firebaseDeviceToken: json["firebaseDeviceToken"],
    manufacturer: json["manufacturer"],
    modelName: json["modelName"],
    osFirmWireBuild: json["osFirmWireBuild"],
    osName: json["osName"],
    osVersion: json["osVersion"],
    rootDevice: json["rootDevice"],
  );

  Map<String, dynamic> toJson() => {
    "deviceId": deviceId,
    "firebaseDeviceToken": firebaseDeviceToken,
    "manufacturer": manufacturer,
    "modelName": modelName,
    "osFirmWireBuild": osFirmWireBuild,
    "osName": osName,
    "osVersion": osVersion,
    "rootDevice": rootDevice,
  };
}
