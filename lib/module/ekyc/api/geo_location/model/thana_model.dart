class ThanaModel {
  ThanaModel({
    this.id,
    this.districtId,
    this.upazillaName,
  });

  int? id;
  int? districtId;
  String? upazillaName;

  ThanaModel copyWith({
    int? id,
    int? districtId,
    String? upazillaName,
  }) =>
      ThanaModel(
        id: id ?? this.id,
        districtId: districtId ?? this.districtId,
        upazillaName: upazillaName ?? this.upazillaName,
      );

  factory ThanaModel.fromJson(Map<String, dynamic> json) => ThanaModel(
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