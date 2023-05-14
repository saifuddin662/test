class DsrLimitInfoResponse {

  int? code;
  Data? data;
  final String? message;

  DsrLimitInfoResponse({
    this.code,
    this.data,
    this.message,
  });

  DsrLimitInfoResponse copyWith() =>
      DsrLimitInfoResponse(
        code: code ?? code,
        data: data ?? data,
        message: message ?? message,
      );

  factory DsrLimitInfoResponse.fromJson(Map<String, dynamic> json) => DsrLimitInfoResponse(
    code: json["code"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );
}

class Data {
  int dsrTopUpLimit;
  dynamic dsrDailyTopUp;
  dynamic dsrDailyCashOut;
  bool isDsrTopUpLimitExceed;
  int dsrCashOutLimit;
  bool isDsrCashOutLimitExceed;

  Data({
    required this.dsrTopUpLimit,
    required this.dsrDailyTopUp,
    required this.dsrDailyCashOut,
    required this.isDsrTopUpLimitExceed,
    required this.dsrCashOutLimit,
    required this.isDsrCashOutLimitExceed,
  });

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(
        dsrTopUpLimit: json["dsrTopUpLimit"] ?? "",
        dsrDailyTopUp: json["dsrDailyTopUp"] ?? "",
        dsrDailyCashOut: json["dsrDailyCashOut"] ?? "",
        isDsrTopUpLimitExceed: json["isDsrTopUpLimitExceed"] ?? false,
        dsrCashOutLimit: json["dsrCashOutLimit"] ?? "",
        isDsrCashOutLimitExceed: json["isDsrCashOutLimitExceed"] ?? false,
      );
}