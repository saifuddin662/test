import 'dart:convert';

MyQrCodeRequest? myQrRequestFromJson(String str) => MyQrCodeRequest.fromJson(json.decode(str));

String myQrRequestToJson(MyQrCodeRequest? data) => json.encode(data!.toJson());

class MyQrCodeRequest {
  MyQrCodeRequest({
    this.walletNo,
    this.walletType
  });

  String? walletNo;
  String? walletType;

  MyQrCodeRequest copyWith({
    String? walletNo,
    String? walletType
  }) =>
      MyQrCodeRequest(
        walletNo: walletNo ?? this.walletNo,
        walletType: walletType ?? this.walletType,
      );

  factory MyQrCodeRequest.fromJson(Map<String, dynamic> json) => MyQrCodeRequest(
    walletNo: json["walletNo"],
    walletType: json["type"]
  );

  Map<String, dynamic> toJson() => {
    "walletNo": walletNo,
    "type": walletType
  };
}

