import 'dart:convert';

RegOtpResponse regOtpResponseFromJson(String str) => RegOtpResponse.fromJson(json.decode(str));

String regOtpResponseToJson(RegOtpResponse data) => json.encode(data.toJson());

class RegOtpResponse {
  RegOtpResponse({
    this.otpReference,
    this.isOtpInputEnabled,
  });

  String? otpReference;
  bool? isOtpInputEnabled;

  RegOtpResponse copyWith({
    String? otpReference,
    bool? isOtpInputEnabled,
  }) =>
      RegOtpResponse(
        otpReference: otpReference ?? this.otpReference,
        isOtpInputEnabled: isOtpInputEnabled ?? this.isOtpInputEnabled,
      );

  factory RegOtpResponse.fromJson(Map<String, dynamic> json) => RegOtpResponse(
    otpReference: json["otpReference"],
    isOtpInputEnabled: json["isOtpInputEnabled"],
  );

  Map<String, dynamic> toJson() => {
    "otpReference": otpReference,
    "isOtpInputEnabled": isOtpInputEnabled,
  };
}
