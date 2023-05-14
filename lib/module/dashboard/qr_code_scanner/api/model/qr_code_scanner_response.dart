class QrCodeScannerResponse {

  final String? status;
  final String? walletNo;
  final String? name;
  final String? userType;
  final String? accountStatus;

  QrCodeScannerResponse({
    this.status,
    this.walletNo,
    this.name,
    this.userType,
    this.accountStatus,
  });

  QrCodeScannerResponse copyWith() =>
      QrCodeScannerResponse(
        status: status ?? status,
        walletNo: walletNo ?? walletNo,
        name: name ?? name,
        userType: userType ?? userType,
        accountStatus: accountStatus ?? accountStatus,
      );

  factory QrCodeScannerResponse.fromJson(Map<String, dynamic> json) => QrCodeScannerResponse(
    status: json["status"],
    walletNo: json["walletNo"],
    name: json["name"],
    userType: json["userType"],
    accountStatus: json["accountStatus"],
  );
}
