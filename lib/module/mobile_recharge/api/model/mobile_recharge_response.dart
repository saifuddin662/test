/**
 * Created by Md. Awon-Uz-Zaman on 29/January/2023
 */

class MobileRechargeResponse {
  MobileRechargeResponse({
    this.message,
  });

  final String? message;

  MobileRechargeResponse copyWith() =>
      MobileRechargeResponse(
        message: message ?? message,
      );

  factory MobileRechargeResponse.fromJson(Map<String, dynamic> json) => MobileRechargeResponse(
    message: json["message"],
  );
}
