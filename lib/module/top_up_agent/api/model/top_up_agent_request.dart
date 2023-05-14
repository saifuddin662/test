class TopUpAgentRequest {

  String toAc;
  String amount;
  String pin;
  String txnType;

  TopUpAgentRequest({
    required this.toAc,
    required this.amount,
    required this.pin,
    required this.txnType,
  });

  TopUpAgentRequest copyWith({
    String? toAc,
    String? amount,
    String? pin,
    String? txnType
  }) => TopUpAgentRequest(
    toAc: toAc ?? this.toAc,
    amount: amount ?? this.amount,
    pin: pin ?? this.pin,
    txnType: txnType ?? this.txnType,
  );

  factory TopUpAgentRequest.fromJson(Map<String, dynamic> json) => TopUpAgentRequest(
    toAc: json["toAc"],
    amount: json["amount"],
    pin: json["pin"],
    txnType: json["txnType"],
  );

  Map<String, dynamic> toJson() => {
    "toAc": toAc,
    "amount": amount,
    "pin": pin,
    "txnType": txnType,
  };
}



