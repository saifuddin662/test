class PayRequestMoneyResponse {
  PayRequestMoneyResponse({
    this.message,
  });

  final String? message;

  PayRequestMoneyResponse copyWith() =>
      PayRequestMoneyResponse(
        message: message ?? message,
      );

  factory PayRequestMoneyResponse.fromJson(Map<String, dynamic> json) => PayRequestMoneyResponse(
    message: json["message"],
  );
}
