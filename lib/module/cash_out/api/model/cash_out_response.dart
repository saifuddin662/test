class CashOutResponse {

  final String? message;

  CashOutResponse({
    this.message,
  });

  CashOutResponse copyWith() =>
      CashOutResponse(
        message: message ?? message,
      );

  factory CashOutResponse.fromJson(Map<String, dynamic> json) => CashOutResponse(
    message: json["message"],
  );
}
