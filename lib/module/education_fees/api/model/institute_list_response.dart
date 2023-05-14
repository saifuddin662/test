/**
 * Created by Md. Awon-Uz-Zaman on 31/January/2023
 */
import 'dart:core';

class InstituteListResponse {
  InstituteListResponse({
    this.code,
    this.message,
    this.instituteList,
  });

  int? code;
  String? message;
  List<Institute>? instituteList;

  factory InstituteListResponse.fromJson(Map<String, dynamic> json) => InstituteListResponse(
    code: json["code"],
    message: json["message"],
    instituteList: List<Institute>.from(json["instituteList"].map((x) => Institute.fromJson(x))),
  );
}

class Institute {
  Institute({
    required this.name,
    required this.code,
    required this.wallet,
    required this.isOpenInstitute,
  });

  String name;
  String code;
  String wallet;
  int isOpenInstitute;

  factory Institute.fromJson(Map<String, dynamic> json) => Institute(
    name: json["name"],
    code: json["code"],
    wallet: json["wallet"],
    isOpenInstitute: json["isOpenInstitute"],
  );
}
