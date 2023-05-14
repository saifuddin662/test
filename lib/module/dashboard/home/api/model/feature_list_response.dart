class FeatureListResponse {
  List<FeatureList>? features;

  FeatureListResponse({
    required this.features,
  });


  FeatureListResponse.fromJson(dynamic json) {
    features = <FeatureList>[];
    if(json != null) {
      json.forEach((v) {
        features!.add(FeatureList.fromJson(v));
      });
    }
  }

}

class FeatureList {
  List<Feature>? featureList;

  FeatureList({
    required this.featureList,
  });

  FeatureList.fromJson(dynamic json) {
    featureList = <Feature>[];
    json["features"].forEach((v) {
      if(json != null) {
        featureList!.add(Feature.fromJson(v));
      }
    });
  }

}

class Feature {
  Feature({
    this.featureTitle,
    this.featureCode,
    this.transactionType,
    this.imageUrl,
    this.isActive,
    this.sequence,
    this.minLimit,
    this.maxLimit,
  });

  String? featureTitle;
  String? featureCode;
  String? transactionType;
  String? imageUrl;
  bool? isActive;
  int? sequence;
  int? minLimit;
  int? maxLimit;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    featureTitle: json["featureTitle"],
    featureCode: json["featureCode"],
    transactionType: json["transactionType"],
    imageUrl: json["imageUrl"],
    isActive: json["isActive"],
    sequence: json["sequence"],
    minLimit: json["minLimit"],
    maxLimit: json["maxLimit"],
  );

  Map<String, dynamic> toJson() => {
    "featureTitle": featureTitle,
    "featureCode": featureCode,
    "transactionType": transactionType,
    "imageUrl": imageUrl,
    "isActive": isActive,
    "sequence": sequence,
    "minLimit": minLimit,
    "maxLimit": maxLimit,
  };
}
