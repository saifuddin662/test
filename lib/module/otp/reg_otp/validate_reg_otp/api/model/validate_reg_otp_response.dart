import 'dart:convert';

ValidateRegOtpResponse validateRegOtpResponseFromJson(String str) => ValidateRegOtpResponse.fromJson(json.decode(str));

String validateRegOtpResponseToJson(ValidateRegOtpResponse data) => json.encode(data.toJson());

class ValidateRegOtpResponse {
  ValidateRegOtpResponse({
    this.otpReference,
  });

  String? otpReference;

  ValidateRegOtpResponse copyWith({
    String? otpReference,
  }) =>
      ValidateRegOtpResponse(
        otpReference: otpReference ?? this.otpReference,
      );

  factory ValidateRegOtpResponse.fromJson(Map<String, dynamic> json) => ValidateRegOtpResponse(
    otpReference: json["otpReference"],
  );

  Map<String, dynamic> toJson() => {
    "otpReference": otpReference,
  };
}

