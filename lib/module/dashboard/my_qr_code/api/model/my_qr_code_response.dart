class MyQrCodeResponse {

  final String qrCode;

  MyQrCodeResponse({
    this.qrCode = "",
  });

  factory MyQrCodeResponse.fromJson(Map<String, dynamic> json) => MyQrCodeResponse(
    qrCode: json["qrcode"],
  );
}
