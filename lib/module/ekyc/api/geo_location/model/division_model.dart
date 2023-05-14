class DivisionModel {
  DivisionModel({
    this.id,
    this.divisionName,
  });

  int? id;
  String? divisionName;

  DivisionModel copyWith({
    int? id,
    String? divisionName,
  }) =>
      DivisionModel(
        id: id ?? this.id,
        divisionName: divisionName ?? this.divisionName,
      );

  factory DivisionModel.fromJson(Map<String, dynamic> json) => DivisionModel(
    id: json["id"],
    divisionName: json["divisionName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "divisionName": divisionName,
  };
}