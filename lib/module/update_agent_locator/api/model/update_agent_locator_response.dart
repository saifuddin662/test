class UpdateAgentLocatorResponse {
  UpdateAgentLocatorResponse({
    this.message,
  });

  final String? message;

  UpdateAgentLocatorResponse copyWith() =>
      UpdateAgentLocatorResponse(
        message: message ?? message,
      );

  factory UpdateAgentLocatorResponse.fromJson(Map<String, dynamic> json) => UpdateAgentLocatorResponse(
    message: json["message"],
  );
}
