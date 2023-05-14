import 'dart:convert';

DeviceRegModel? deviceRegModelFromJson(String str) => DeviceRegModel.fromJson(json.decode(str));

String deviceRegModelToJson(DeviceRegModel? data) => json.encode(data!.toJson());

class DeviceRegModel {
  DeviceRegModel({
    this.deviceInfo,
    this.deviceType,
    this.mno,
    this.msisdn,
    this.phoneNumber,
    this.pin,
    this.serviceName,
  });

  DeviceInfo? deviceInfo;
  String? deviceType;
  String? mno;
  String? msisdn;
  String? phoneNumber;
  String? pin;
  String? serviceName;

  DeviceRegModel copyWith({
    DeviceInfo? deviceInfo,
    String? deviceType,
    String? mno,
    String? msisdn,
    String? phoneNumber,
    String? pin,
    String? serviceName,
  }) =>
      DeviceRegModel(
        deviceInfo: deviceInfo ?? this.deviceInfo,
        deviceType: deviceType ?? this.deviceType,
        mno: mno ?? this.mno,
        msisdn: msisdn ?? this.msisdn,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        pin: pin ?? this.pin,
        serviceName: serviceName ?? this.serviceName,
      );

  factory DeviceRegModel.fromJson(Map<String, dynamic> json) => DeviceRegModel(
    deviceInfo: DeviceInfo.fromJson(json["deviceInfo"]),
    deviceType: json["deviceType"],
    mno: json["mno"],
    msisdn: json["msisdn"],
    phoneNumber: json["phoneNumber"],
    pin: json["pin"],
    serviceName: json["serviceName"],
  );

  Map<String, dynamic> toJson() => {
    "deviceInfo": deviceInfo!.toJson(),
    "deviceType": deviceType,
    "mno": mno,
    "msisdn": msisdn,
    "phoneNumber": phoneNumber,
    "pin": pin,
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
