class ChangePinResponse {
  ChangePinResponse({
    this.message,
  });

  final String? message;

  ChangePinResponse copyWith() =>
      ChangePinResponse(
        message: message ?? message,
      );

  factory ChangePinResponse.fromJson(Map<String, dynamic> json) => ChangePinResponse(
    message: json["message"],
  );
}
