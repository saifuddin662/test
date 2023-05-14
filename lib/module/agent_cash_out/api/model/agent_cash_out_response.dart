class AgentCashOutResponse {

  final String? message;

  AgentCashOutResponse({
    this.message,
  });

  AgentCashOutResponse copyWith() =>
      AgentCashOutResponse(
        message: message ?? message,
      );

  factory AgentCashOutResponse.fromJson(Map<String, dynamic> json) => AgentCashOutResponse(
    message: json["message"],
  );
}
