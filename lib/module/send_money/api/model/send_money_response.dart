class SendMoneyResponse {
  SendMoneyResponse({
    this.message,
  });

  final String? message;

  SendMoneyResponse copyWith() =>
      SendMoneyResponse(
        message: message ?? message,
      );

  factory SendMoneyResponse.fromJson(Map<String, dynamic> json) => SendMoneyResponse(
    message: json["message"],
  );
}
