import 'dart:convert';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 16,March,2023.

UtilityPaymentResponse utilityPaymentResponseFromJson(String str) => UtilityPaymentResponse.fromJson(json.decode(str));

String utilityPaymentResponseToJson(UtilityPaymentResponse data) => json.encode(data.toJson());

class UtilityPaymentResponse {
  UtilityPaymentResponse({
    this.code,
    this.message,
    this.status,
    this.txnId,
    this.amount,
    this.fee,
    this.commission,
    this.balanceFrom,
    this.balanceTo,
    this.ticket,
    this.traceNo,
    this.fromAccount,
    this.toAccount,
    this.txnTime,
    this.txnType,
    this.txnTypeName,
    this.balance,
  });

  dynamic code;
  String? message;
  String? status;
  String? txnId;
  String? amount;
  String? fee;
  String? commission;
  String? balanceFrom;
  String? balanceTo;
  String? ticket;
  String? traceNo;
  String? fromAccount;
  String? toAccount;
  String? txnTime;
  String? txnType;
  String? txnTypeName;
  dynamic balance;

  UtilityPaymentResponse copyWith({
    dynamic code,
    String? message,
    String? status,
    String? txnId,
    String? amount,
    String? fee,
    String? commission,
    String? balanceFrom,
    String? balanceTo,
    String? ticket,
    String? traceNo,
    String? fromAccount,
    String? toAccount,
    String? txnTime,
    String? txnType,
    String? txnTypeName,
    dynamic balance,
  }) =>
      UtilityPaymentResponse(
        code: code ?? this.code,
        message: message ?? this.message,
        status: status ?? this.status,
        txnId: txnId ?? this.txnId,
        amount: amount ?? this.amount,
        fee: fee ?? this.fee,
        commission: commission ?? this.commission,
        balanceFrom: balanceFrom ?? this.balanceFrom,
        balanceTo: balanceTo ?? this.balanceTo,
        ticket: ticket ?? this.ticket,
        traceNo: traceNo ?? this.traceNo,
        fromAccount: fromAccount ?? this.fromAccount,
        toAccount: toAccount ?? this.toAccount,
        txnTime: txnTime ?? this.txnTime,
        txnType: txnType ?? this.txnType,
        txnTypeName: txnTypeName ?? this.txnTypeName,
        balance: balance ?? this.balance,
      );

  factory UtilityPaymentResponse.fromJson(Map<String, dynamic> json) => UtilityPaymentResponse(
    code: json["code"],
    message: json["message"],
    status: json["status"],
    txnId: json["txnId"],
    amount: json["amount"],
    fee: json["fee"],
    commission: json["commission"],
    balanceFrom: json["balanceFrom"],
    balanceTo: json["balanceTo"],
    ticket: json["ticket"],
    traceNo: json["traceNo"],
    fromAccount: json["fromAccount"],
    toAccount: json["toAccount"],
    txnTime: json["txnTime"],
    txnType: json["txnType"],
    txnTypeName: json["txnTypeName"],
    balance: json["balance"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "status": status,
    "txnId": txnId,
    "amount": amount,
    "fee": fee,
    "commission": commission,
    "balanceFrom": balanceFrom,
    "balanceTo": balanceTo,
    "ticket": ticket,
    "traceNo": traceNo,
    "fromAccount": fromAccount,
    "toAccount": toAccount,
    "txnTime": txnTime,
    "txnType": txnType,
    "txnTypeName": txnTypeName,
    "balance": balance,
  };
}
