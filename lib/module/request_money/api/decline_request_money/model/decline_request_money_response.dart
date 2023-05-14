class DeclineRequestMoneyResponse {
  DeclineRequestMoneyResponse({
    this.message,
  });

  final String? message;

  DeclineRequestMoneyResponse copyWith() =>
      DeclineRequestMoneyResponse(
        message: message ?? message,
      );

  factory DeclineRequestMoneyResponse.fromJson(Map<String, dynamic> json) => DeclineRequestMoneyResponse(
    message: json["message"],
  );
}