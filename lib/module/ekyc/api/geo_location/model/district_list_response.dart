import 'dart:convert';

DistrictListResponse districtListResponseFromJson(String str) => DistrictListResponse.fromJson(json.decode(str));

String districtListResponseToJson(DistrictListResponse data) => json.encode(data.toJson());

class DistrictListResponse {
  DistrictListResponse({
    this.code,
    this.message,
    this.data,
  });

  int? code;
  String? message;
  List<Datum>? data;

  DistrictListResponse copyWith({
    int? code,
    String? message,
    List<Datum>? data,
  }) =>
      DistrictListResponse(
        code: code ?? this.code,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory DistrictListResponse.fromJson(Map<String, dynamic> json) => DistrictListResponse(
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
    this.divisionId,
    this.districtName,
    this.remarks,
    this.isActive,
  });

  int? id;
  int? divisionId;
  String? districtName;
  dynamic remarks;
  int? isActive;

  Datum copyWith({
    int? id,
    int? divisionId,
    String? districtName,
    dynamic remarks,
    int? isActive,
  }) =>
      Datum(
        id: id ?? this.id,
        divisionId: divisionId ?? this.divisionId,
        districtName: districtName ?? this.districtName,
        remarks: remarks ?? this.remarks,
        isActive: isActive ?? this.isActive,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    divisionId: json["divisionId"],
    districtName: json["districtName"],
    remarks: json["remarks"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "divisionId": divisionId,
    "districtName": districtName,
    "remarks": remarks,
    "isActive": isActive,
  };
}
