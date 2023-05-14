import 'dart:convert';

DuServiceListResponse duServiceListResponseFromJson(String str) => DuServiceListResponse.fromJson(json.decode(str));

String duServiceListResponseToJson(DuServiceListResponse data) => json.encode(data.toJson());

class DuServiceListResponse {
  DuServiceListResponse({
    this.sectionTitle,
    this.isVisible,
    this.services,
  });

  String? sectionTitle;
  bool? isVisible;
  List<Service>? services;

  DuServiceListResponse copyWith({
    String? sectionTitle,
    bool? isVisible,
    List<Service>? services,
  }) =>
      DuServiceListResponse(
        sectionTitle: sectionTitle ?? this.sectionTitle,
        isVisible: isVisible ?? this.isVisible,
        services: services ?? this.services,
      );

  factory DuServiceListResponse.fromJson(Map<String, dynamic> json) => DuServiceListResponse(
    sectionTitle: json["sectionTitle"],
    isVisible: json["is_visible"],
    services: json["services"] == null ? [] : List<Service>.from(json["services"]!.map((x) => Service.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sectionTitle": sectionTitle,
    "is_visible": isVisible,
    "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toJson())),
  };
}

class Service {
  Service({
    this.featureCode,
    this.featureTitle,
    this.flow,
    this.iconUrl,
    this.isEnabled,
    this.isVisible,
  });

  String? featureCode;
  String? featureTitle;
  int? flow;
  String? iconUrl;
  bool? isEnabled;
  bool? isVisible;

  Service copyWith({
    String? featureCode,
    String? featureTitle,
    int? flow,
    String? iconUrl,
    bool? isEnabled,
    bool? isVisible,
  }) =>
      Service(
        featureCode: featureCode ?? this.featureCode,
        featureTitle: featureTitle ?? this.featureTitle,
        flow: flow ?? this.flow,
        iconUrl: iconUrl ?? this.iconUrl,
        isEnabled: isEnabled ?? this.isEnabled,
        isVisible: isVisible ?? this.isVisible,
      );

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    featureCode: json["feature_code"],
    featureTitle: json["feature_title"],
    flow: json["flow"],
    iconUrl: json["icon_url"],
    isEnabled: json["is_enabled"],
    isVisible: json["is_visible"],
  );

  Map<String, dynamic> toJson() => {
    "feature_code": featureCode,
    "feature_title": featureTitle,
    "flow": flow,
    "icon_url": iconUrl,
    "is_enabled": isEnabled,
    "is_visible": isVisible,
  };
}

