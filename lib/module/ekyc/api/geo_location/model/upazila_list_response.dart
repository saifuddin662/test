import 'dart:convert';

UpazilaListResponse upazilaListResponseFromJson(String str) => UpazilaListResponse.fromJson(json.decode(str));

String upazilaListResponseToJson(UpazilaListResponse data) => json.encode(data.toJson());

class UpazilaListResponse {
  UpazilaListResponse({
    this.code,
    this.message,
    this.data,
  });

  int? code;
  String? message;
  List<Datum>? data;

  UpazilaListResponse copyWith({
    int? code,
    String? message,
    List<Datum>? data,
  }) =>
      UpazilaListResponse(
        code: code ?? this.code,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory UpazilaListResponse.fromJson(Map<String, dynamic> json) => UpazilaListResponse(
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.districtId,
    this.upazillaName,
  });

  int? id;
  int? districtId;
  String? upazillaName;

  Datum copyWith({
    int? id,
    int? districtId,
    String? upazillaName,
  }) =>
      Datum(
        id: id ?? this.id,
        districtId: districtId ?? this.districtId,
        upazillaName: upazillaName ?? this.upazillaName,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    districtId: json["districtId"],
    upazillaName: json["upazillaName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "districtId": districtId,
    "upazillaName": upazillaName,
  };
}
