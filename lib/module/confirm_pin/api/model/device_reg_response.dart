import 'dart:convert';

DeviceRegResponse? deviceRegResponseFromJson(String str) => DeviceRegResponse.fromJson(json.decode(str));

String deviceRegResponseToJson(DeviceRegResponse? data) => json.encode(data!.toJson());

class DeviceRegResponse {
  DeviceRegResponse({
    this.otpReference,
    this.isOtpInputEnabled,
  });

  final String? otpReference;
  final bool? isOtpInputEnabled;

  DeviceRegResponse copyWith({
    String? otpReference,
    bool? isOtpInputEnabled,
  }) =>
      DeviceRegResponse(
        otpReference: otpReference ?? this.otpReference,
        isOtpInputEnabled: isOtpInputEnabled ?? this.isOtpInputEnabled,
      );

  factory DeviceRegResponse.fromJson(Map<String, dynamic> json) => DeviceRegResponse(
    otpReference: json["otpReference"],
    isOtpInputEnabled: json["isOtpInputEnabled"],
  );

  Map<String, dynamic> toJson() => {
    "otpReference": otpReference,
    "isOtpInputEnabled": isOtpInputEnabled,
  };
}
