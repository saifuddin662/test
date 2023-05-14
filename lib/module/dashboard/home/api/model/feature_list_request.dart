class FeatureListRequest {
  String userType;

  FeatureListRequest(this.userType);

  Map<String, dynamic> toJson() {
    return {
      "accountType": userType,
    };
  }
}