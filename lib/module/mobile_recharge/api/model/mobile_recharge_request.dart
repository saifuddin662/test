///Created by Md. Awon-Uz-Zaman on 29/January/2023

class MobileRechargeRequest {
  MobileRechargeRequest({
    required this.secretKey,
    required this.recipientNumber,
    required this.amount,
    required this.connectionType,
    required this.operator,
    required this.isBundle,
    required this.pin,
  });

  String secretKey;
  String recipientNumber;
  int amount;
  String connectionType;
  String operator;
  bool isBundle;
  String pin;
}