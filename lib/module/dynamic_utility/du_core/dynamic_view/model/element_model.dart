import '../../api/du_detail/model/utility_detail_response.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 08,March,2023.

class DynamicElementModel {
  DynamicElementModel({
    this.key,
    this.label,
    this.fieldType,
    this.dataType,
    this.regex,
    this.hint,
    this.options,
    this.required,
  });

  String? key;
  String? label;
  String? fieldType;
  String? dataType;
  String? regex;
  String? hint;
  List<Option>? options;
  bool? required;

  DynamicElementModel copyWith({
    String? key,
    String? label,
    String? fieldType,
    String? dataType,
    String? regex,
    String? hint,
    List<Option>? options,
    bool? required,
  }) =>
      DynamicElementModel(
        key: key ?? this.key,
        label: label ?? this.label,
        fieldType: fieldType ?? this.fieldType,
        dataType: dataType ?? this.dataType,
        regex: regex ?? this.regex,
        hint: hint ?? this.hint,
        options: options ?? this.options,
        required: required ?? this.required,
      );

  factory DynamicElementModel.fromJson(Map<String, dynamic> json) => DynamicElementModel(
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