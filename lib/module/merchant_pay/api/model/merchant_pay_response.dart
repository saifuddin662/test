class MerchantPayResponse {

  final String? message;

  MerchantPayResponse({
    this.message,
  });

  MerchantPayResponse copyWith() =>
      MerchantPayResponse(
        message: message ?? message,
      );

  factory MerchantPayResponse.fromJson(Map<String, dynamic> json) => MerchantPayResponse(
    message: json["message"],
  );
}
