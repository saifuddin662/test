import 'dart:convert';

ValidateRegOtpRequest validateRegOtpRequestFromJson(String str) => ValidateRegOtpRequest.fromJson(json.decode(str));

String validateRegOtpRequestToJson(ValidateRegOtpRequest data) => json.encode(data.toJson());

class ValidateRegOtpRequest {
  ValidateRegOtpRequest({
    this.deviceId,
    this.otp,
    this.otpReferenceId,
    this.receiverInfo,
  });

  String? deviceId;
  String? otp;
  String? otpReferenceId;
  String? receiverInfo;

  ValidateRegOtpRequest copyWith({
    String? deviceId,
    String? otp,
    String? otpReferenceId,
    String? receiverInfo,
  }) =>
      ValidateRegOtpRequest(
        deviceId: deviceId ?? this.deviceId,
        otp: otp ?? this.otp,
        otpReferenceId: otpReferenceId ?? this.otpReferenceId,
        receiverInfo: receiverInfo ?? this.receiverInfo,
      );

  factory ValidateRegOtpRequest.fromJson(Map<String, dynamic> json) => ValidateRegOtpRequest(
    deviceId: json["deviceId"],
    otp: json["otp"],
    otpReferenceId: json["otpReferenceId"],
    receiverInfo: json["receiverInfo"],
  );

  Map<String, dynamic> toJson() => {
    "deviceId": deviceId,
    "otp": otp,
    "otpReferenceId": otpReferenceId,
    "receiverInfo": receiverInfo,
  };
}
