import 'dart:convert';

AgentCashInRequest? agentCashInRequest(String str) => AgentCashInRequest.fromJson(json.decode(str));

String agentCashInRequestJson(AgentCashInRequest? data) => json.encode(data!.toJson());

class AgentCashInRequest {

  String recipientNumber;
  String amount;
  String pin;

  AgentCashInRequest({
    required this.recipientNumber,
    required this.amount,
    required this.pin,
  });

  AgentCashInRequest copyWith({
    String? recipientNumber,
    String? amount,
    String? pin
  }) => AgentCashInRequest(
    recipientNumber: recipientNumber ?? this.recipientNumber,
    amount: amount ?? this.amount,
    pin: pin ?? this.pin,
  );

  factory AgentCashInRequest.fromJson(Map<String, dynamic> json) => AgentCashInRequest(
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


