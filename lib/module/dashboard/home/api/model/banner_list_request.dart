class BannerListRequest {
  String userType;

  BannerListRequest(this.userType);

  Map<String, dynamic> toJson() {
    return {
      "accountType": userType,
    };
  }
}