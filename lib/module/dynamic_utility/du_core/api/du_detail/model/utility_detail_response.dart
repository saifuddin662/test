import 'dart:convert';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 08,March,2023.

UtilityDetailResponse utilityDetailResponseFromJson(String str) => UtilityDetailResponse.fromJson(json.decode(str));

String utilityDetailResponseToJson(UtilityDetailResponse data) => json.encode(data.toJson());

class UtilityDetailResponse {
  UtilityDetailResponse({
    this.utilityCode,
    this.utilityTitle,
    this.utilityImage,
    this.flow,
    this.fieldItemList,
  });

  String? utilityCode;
  String? utilityTitle;
  String? utilityImage;
  String? flow;
  List<FieldItemList>? fieldItemList;

  UtilityDetailResponse copyWith({
    String? utilityCode,
    String? utilityTitle,
    String? utilityImage,
    String? flow,
    List<FieldItemList>? fieldItemList,
  }) =>
      UtilityDetailResponse(
        utilityCode: utilityCode ?? this.utilityCode,
        utilityTitle: utilityTitle ?? this.utilityTitle,
        utilityImage: utilityImage ?? this.utilityImage,
        flow: flow ?? this.flow,
        fieldItemList: fieldItemList ?? this.fieldItemList,
      );

  factory UtilityDetailResponse.fromJson(Map<String, dynamic> json) => UtilityDetailResponse(
    utilityCode: json["utilityCode"],
    utilityTitle: json["utilityTitle"],
    utilityImage: json["utilityImage"],
    flow: json["flow"],
    fieldItemList: json["fieldItemList"] == null ? [] : List<FieldItemList>.from(json["fieldItemList"]!.map((x) => FieldItemList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "utilityCode": utilityCode,
    "utilityTitle": utilityTitle,
    "utilityImage": utilityImage,
    "flow": flow,
    "fieldItemList": fieldItemList == null ? [] : List<dynamic>.from(fieldItemList!.map((x) => x.toJson())),
  };
}

class FieldItemList {
  FieldItemList({
    this.key,
    this.label,
    required this.fieldType,
    this.dataType,
    this.regex,
    this.hint,
    this.options,
    this.required,
  });

  String? key;
  String? label;
  String fieldType;
  String? dataType;
  String? regex;
  String? hint;
  List<Option>? options;
  bool? required;

  FieldItemList copyWith({
    String? key,
    String? label,
    String? fieldType,
    String? dataType,
    String? regex,
    String? hint,
    List<Option>? options,
    bool? required,
  }) =>
      FieldItemList(
        key: key ?? this.key,
        label: label ?? this.label,
        fieldType: fieldType ?? this.fieldType,
        dataType: dataType ?? this.dataType,
        regex: regex ?? this.regex,
        hint: hint ?? this.hint,
        options: options ?? this.options,
        required: required ?? this.required,
      );

  factory FieldItemList.fromJson(Map<String, dynamic> json) => FieldItemList(
    key: json["key"],
    label: json["label"],
    fieldType: json["fieldType"],
    dataType: json["dataType"],
    regex: json["regex"],
    hint: json["hint"],
    options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
    required: json["required"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "label": label,
    "fieldType": fieldType,
    "dataType": dataType,
    "regex": regex,
    "hint": hint,
    "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
    "required": required,
  };
}

class Option {
  Option({
    this.label,
    this.value,
  });

  String? label;
  String? value;

  Option copyWith({
    String? label,
    String? value,
  }) =>
      Option(
        label: label ?? this.label,
        value: value ?? this.value,
      );

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    label: json["label"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "value": value,
  };
}
