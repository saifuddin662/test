import 'dart:convert';

DeviceValidateRequest deviceValidateRequestFromJson(String str) => DeviceValidateRequest.fromJson(json.decode(str));

String deviceValidateRequestToJson(DeviceValidateRequest data) => json.encode(data.toJson());

class DeviceValidateRequest {
  DeviceValidateRequest({
    this.deviceId,
    this.otp,
    this.otpReferenceId,
    this.receiverInfo,
    this.userType,
    this.walletNo,
  });

  String? deviceId;
  String? otp;
  String? otpReferenceId;
  String? receiverInfo;
  String? userType;
  String? walletNo;

  DeviceValidateRequest copyWith({
    String? deviceId,
    String? otp,
    String? otpReferenceId,
    String? receiverInfo,
    String? userType,
    String? walletNo,
  }) =>
      DeviceValidateRequest(
        deviceId: deviceId ?? this.deviceId,
        otp: otp ?? this.otp,
        otpReferenceId: otpReferenceId ?? this.otpReferenceId,
        receiverInfo: receiverInfo ?? this.receiverInfo,
        userType: userType ?? this.userType,
        walletNo: walletNo ?? this.walletNo,
      );

  factory DeviceValidateRequest.fromJson(Map<String, dynamic> json) => DeviceValidateRequest(
    deviceId: json["deviceId"],
    otp: json["otp"],
    otpReferenceId: json["otpReferenceId"],
    receiverInfo: json["receiverInfo"],
    userType: json["userType"],
    walletNo: json["walletNo"],
  );

  Map<String, dynamic> toJson() => {
    "deviceId": deviceId,
    "otp": otp,
    "otpReferenceId": otpReferenceId,
    "receiverInfo": receiverInfo,
    "userType": userType,
    "walletNo": walletNo,
  };
}
