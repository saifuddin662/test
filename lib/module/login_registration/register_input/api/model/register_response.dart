import 'dart:convert';

RegisterResponse? registerResponseFromJson(String str) => RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse? data) => json.encode(data!.toJson());

class RegisterResponse {
  RegisterResponse({
    this.walletNo,
    this.phoneNo,
    this.walletType,
    this.userTypeExists,
    this.ekycStatus,
  });

  String? walletNo;
  String? phoneNo;
  String? walletType;
  bool? userTypeExists;
  String? ekycStatus;

  RegisterResponse copyWith({
    String? walletNo,
    String? phoneNo,
    String? walletType,
    bool? userTypeExists,
    String? ekycStatus,
  }) =>
      RegisterResponse(
        walletNo: walletNo ?? this.walletNo,
        phoneNo: phoneNo ?? this.phoneNo,
        walletType: walletType ?? this.walletType,
        userTypeExists: userTypeExists ?? this.userTypeExists,
        ekycStatus: ekycStatus ?? this.ekycStatus,
      );

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
    walletNo: json["walletNo"],
    phoneNo: json["phoneNo"],
    walletType: json["walletType"],
    userTypeExists: json["userTypeExists"],
    ekycStatus: json["ekycStatus"],
  );

  Map<String, dynamic> toJson() => {
    "walletNo": walletNo,
    "phoneNo": phoneNo,
    "walletType": walletType,
    "userTypeExists": userTypeExists,
    "ekycStatus": ekycStatus,
  };
}
