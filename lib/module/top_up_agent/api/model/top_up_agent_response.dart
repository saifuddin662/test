class TopUpAgentResponse {
  TopUpAgentResponse({
    this.message,
  });

  final String? message;

  TopUpAgentResponse copyWith() =>
      TopUpAgentResponse(
        message: message ?? message,
      );

  factory TopUpAgentResponse.fromJson(Map<String, dynamic> json) => TopUpAgentResponse(
    message: json["message"],
  );
}
