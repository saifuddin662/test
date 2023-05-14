class AgentCashInResponse {

  final String? message;

  AgentCashInResponse({
    this.message,
  });

  AgentCashInResponse copyWith() =>
      AgentCashInResponse(
        message: message ?? message,
      );

  factory AgentCashInResponse.fromJson(Map<String, dynamic> json) => AgentCashInResponse(
    message: json["message"],
  );
}
