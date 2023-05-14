class DistrictModel {
  DistrictModel({
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

  DistrictModel copyWith({
    int? id,
    int? divisionId,
    String? districtName,
    dynamic remarks,
    int? isActive,
  }) =>
      DistrictModel(
        id: id ?? this.id,
        divisionId: divisionId ?? this.divisionId,
        districtName: districtName ?? this.districtName,
        remarks: remarks ?? this.remarks,
        isActive: isActive ?? this.isActive,
      );

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
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