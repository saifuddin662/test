import 'dart:convert';

AgentCashOutRequest? agentCashOutRequest(String str) => AgentCashOutRequest.fromJson(json.decode(str));

String agentCashOutRequestJson(AgentCashOutRequest? data) => json.encode(data!.toJson());

class AgentCashOutRequest {

  String recipientNumber;
  String amount;
  String pin;

  AgentCashOutRequest({
    required this.recipientNumber,
    required this.amount,
    required this.pin,
  });

  AgentCashOutRequest copyWith({
    String? recipientNumber,
    String? amount,
    String? pin
  }) => AgentCashOutRequest(
    recipientNumber: recipientNumber ?? this.recipientNumber,
    amount: amount ?? this.amount,
    pin: pin ?? this.pin,
  );

  factory AgentCashOutRequest.fromJson(Map<String, dynamic> json) => AgentCashOutRequest(
      recipientNumber: json["recipientNumber"],
      amount: json["amount"],
      pin: json["pin"],
  );

  Map<String, dynamic> toJson() => {
    "recipientNumber": recipientNumber,
    "amount": amount,
    "pin": pin,
  };
}


