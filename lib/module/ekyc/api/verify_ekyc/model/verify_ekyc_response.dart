import 'dart:convert';

VerifyEkycResponse verifyEkycResponseFromJson(String str) => VerifyEkycResponse.fromJson(json.decode(str));

String verifyEkycResponseToJson(VerifyEkycResponse data) => json.encode(data.toJson());

class VerifyEkycResponse {
  VerifyEkycResponse({
    this.code,
    this.message,
    this.status,
    this.uuid,
  });

  int? code;
  String? message;
  String? status;
  String? uuid;

  VerifyEkycResponse copyWith({
    int? code,
    String? message,
    String? status,
    String? uuid,
  }) =>
      VerifyEkycResponse(
        code: code ?? this.code,
        message: message ?? this.message,
        status: status ?? this.status,
        uuid: uuid ?? this.uuid,
      );

  factory VerifyEkycResponse.fromJson(Map<String, dynamic> json) => VerifyEkycResponse(
    code: json["code"],
    message: json["message"],
    status: json["status"],
    uuid: json["uuid"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "status": status,
    "uuid": uuid,
  };
}
