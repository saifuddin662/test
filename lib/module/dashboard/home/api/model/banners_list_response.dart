class BannersListResponse {
  List<Banners>? bannerList;

  BannersListResponse({
    required this.bannerList,
  });

  BannersListResponse.fromJson(dynamic json) {
    bannerList = <Banners>[];
    if(json != null) {
      json["banners"].forEach((v) {
        bannerList!.add(Banners.fromJson(v));
      });
    }
  }

}

class Banners {

  String? id;
  String? code;
  String imageSource;

  Banners({
    this.id,
    this.code,
    this.imageSource = ""
  });

  factory Banners.fromJson(Map<String, dynamic> json) => Banners(
    id: json["id"],
    code: json["code"],
    imageSource: json["imageSource"],
  );
}
