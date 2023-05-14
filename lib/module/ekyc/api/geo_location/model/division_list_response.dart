import 'dart:convert';

DivisionListResponse divisionListResponseFromJson(String str) => DivisionListResponse.fromJson(json.decode(str));

String divisionListResponseToJson(DivisionListResponse data) => json.encode(data.toJson());

class DivisionListResponse {
  DivisionListResponse({
    this.code,
    this.message,
    this.data,
  });

  int? code;
  String? message;
  List<Datum>? data;

  DivisionListResponse copyWith({
    int? code,
    String? message,
    List<Datum>? data,
  }) =>
      DivisionListResponse(
        code: code ?? this.code,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory DivisionListResponse.fromJson(Map<String, dynamic> json) => DivisionListResponse(
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
    this.divisionName,
  });

  int? id;
  String? divisionName;

  Datum copyWith({
    int? id,
    String? divisionName,
  }) =>
      Datum(
        id: id ?? this.id,
        divisionName: divisionName ?? this.divisionName,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    divisionName: json["divisionName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "divisionName": divisionName,
  };
}
