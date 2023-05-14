/**
 * Created by Md. Awon-Uz-Zaman on 06/February/2023
 */
class EducationFeesResponse {
  EducationFeesResponse({
    this.balance,
    this.code,
    this.data,
    this.message,
  });

  double? balance;
  int? code;
  Data? data;
  String? message;

  EducationFeesResponse copyWith() =>
      EducationFeesResponse(
        balance: balance ?? balance,
        code: code ?? code,
        data: data ?? data,
        message: message ?? message,
      );

  factory EducationFeesResponse.fromJson(Map<String, dynamic> json) => EducationFeesResponse(
    balance: json["balance"],
    code: json["code"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );
}

class Data {
  Data({
    required this.amount,
    required this.balanceFrom,
    required this.balanceTo,
    required this.commission,
    required this.fee,
    this.fromAccount,
    required this.status,
    required this.ticket,
    this.toAccount,
    required this.traceNo,
    required this.txnId,
    required this.txnTime,
    required this.txnType,
    required this.txnTypeName,
  });

  String amount;
  String balanceFrom;
  String balanceTo;
  String commission;
  String fee;
  String? fromAccount;
  String status;
  String ticket;
  String? toAccount;
  String traceNo;
  String txnId;
  String txnTime;
  String txnType;
  String txnTypeName;

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(
        amount: json["amount"],
        balanceFrom: json["balanceFrom"],
        balanceTo: json["balanceTo"],
        commission: json["commission"],
        fee: json["fee"],
        fromAccount: json["fromAccount"],
        status: json["status"],
        ticket: json["ticket"],
        toAccount: json["toAccount"],
        traceNo: json["traceNo"],
        txnId: json["txnId"],
        txnTime: json["txnTime"],
        txnType: json["txnType"],
        txnTypeName: json["txnTypeName"],
      );
}
