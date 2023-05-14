import 'dart:convert';

class TxnListResponse {
  TxnListResponse({
    this.statement,
  });

  List<Statement>? statement;

  TxnListResponse copyWith({
    List<Statement>? statement,
  }) =>
      TxnListResponse(
        statement: statement ?? this.statement,
      );

  factory TxnListResponse.fromRawJson(String str) => TxnListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TxnListResponse.fromJson(Map<String, dynamic> json) => TxnListResponse(
    statement: json["statement"] == null ? [] : List<Statement>.from(json["statement"]!.map((x) => Statement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statement": statement == null ? [] : List<dynamic>.from(statement!.map((x) => x.toJson())),
  };
}

class Statement {
  Statement({
    this.amount,
    this.transactionType,
    this.senderNumber,
    this.receiverNumber,
    this.senderName,
    this.receiverName,
    this.transactionDate,
    this.txCode,
    this.actionType,
    this.typeName,
  });

  double? amount;
  String? transactionType;
  String? senderNumber;
  String? receiverNumber;
  String? senderName;
  String? receiverName;
  String? transactionDate;
  String? txCode;
  String? actionType;
  String? typeName;

  Statement copyWith({
    double? amount,
    String? transactionType,
    String? senderNumber,
    String? receiverNumber,
    String? senderName,
    String? receiverName,
    String? transactionDate,
    String? txCode,
    String? actionType,
    String? typeName,
  }) =>
      Statement(
        amount: amount ?? this.amount,
        transactionType: transactionType ?? this.transactionType,
        senderNumber: senderNumber ?? this.senderNumber,
        receiverNumber: receiverNumber ?? this.receiverNumber,
        senderName: senderName ?? this.senderName,
        receiverName: receiverName ?? this.receiverName,
        transactionDate: transactionDate ?? this.transactionDate,
        txCode: txCode ?? this.txCode,
        actionType: actionType ?? this.actionType,
        typeName: typeName ?? this.typeName,
      );

  factory Statement.fromRawJson(String str) => Statement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Statement.fromJson(Map<String, dynamic> json) => Statement(
    amount: json["amount"],
    transactionType: json["transactionType"],
    senderNumber: json["senderNumber"],
    receiverNumber: json["receiverNumber"],
    senderName: json["senderName"] ?? "N/A",
    receiverName: json["receiverName"],
    transactionDate: json["transactionDate"],
    txCode: json["txCode"],
    actionType: json["actionType"],
    typeName: json["typeName"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "transactionType": transactionType,
    "senderNumber": senderNumber,
    "receiverNumber": receiverNumber,
    "senderName": senderName,
    "receiverName": receiverName,
    "transactionDate": transactionDate,
    "txCode": txCode,
    "actionType": actionType,
    "typeName": typeName,
  };
}
