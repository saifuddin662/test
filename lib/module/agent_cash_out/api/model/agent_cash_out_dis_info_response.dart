class AgentCashOutDisInfoResponse {
  AgentCashOutDisInfoResponse({
    this.code,
    this.data,
    this.message,
  });

  double? balance;
  int? code;
  Data? data;
  String? message;

  AgentCashOutDisInfoResponse copyWith() =>
      AgentCashOutDisInfoResponse(
        code: code ?? code,
        data: data ?? data,
        message: message ?? message,
      );

  factory AgentCashOutDisInfoResponse.fromJson(Map<String, dynamic> json) => AgentCashOutDisInfoResponse(
    code: json["code"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );
}

class Data {
  Data({
    required this.walletNo,
    required this.name,
  });

  String walletNo;
  String name;

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(
        walletNo: json["wallet_NO"] ?? "",
        name: json["name"] ?? "",
      );
}
