import 'dart:convert';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 14,March,2023.

UtilityInfoResponse utilityInfoResponseFromJson(String str) => UtilityInfoResponse.fromJson(json.decode(str));

String utilityInfoResponseToJson(UtilityInfoResponse data) => json.encode(data.toJson());

class UtilityInfoResponse {
  UtilityInfoResponse({
    this.transactionId,
    this.dueAmount,
    this.infoItemArrayList,
  });

  String? transactionId;
  String? dueAmount;
  List<InfoItemArrayList>? infoItemArrayList;

  UtilityInfoResponse copyWith({
    String? transactionId,
    String? dueAmount,
    List<InfoItemArrayList>? infoItemArrayList,
  }) =>
      UtilityInfoResponse(
        transactionId: transactionId ?? this.transactionId,
        dueAmount: dueAmount ?? this.dueAmount,
        infoItemArrayList: infoItemArrayList ?? this.infoItemArrayList,
      );

  factory UtilityInfoResponse.fromJson(Map<String, dynamic> json) => UtilityInfoResponse(
    transactionId: json["transaction_id"],
    dueAmount: json["due_amount"],
    infoItemArrayList: json["infoItemArrayList"] == null ? [] : List<InfoItemArrayList>.from(json["infoItemArrayList"]!.map((x) => InfoItemArrayList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "transaction_id": transactionId,
    "due_amount": dueAmount,
    "infoItemArrayList": infoItemArrayList == null ? [] : List<dynamic>.from(infoItemArrayList!.map((x) => x.toJson())),
  };
}

class InfoItemArrayList {
  InfoItemArrayList({
    this.label,
    this.value,
  });

  String? label;
  String? value;

  InfoItemArrayList copyWith({
    String? label,
    String? value,
  }) =>
      InfoItemArrayList(
        label: label ?? this.label,
        value: value ?? this.value,
      );

  factory InfoItemArrayList.fromJson(Map<String, dynamic> json) => InfoItemArrayList(
    label: json["label"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "value": value,
  };
}
