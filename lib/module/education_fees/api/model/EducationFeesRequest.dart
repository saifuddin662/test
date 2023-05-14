/**
 * Created by Md. Awon-Uz-Zaman on 06/February/2023
 */

class EducationFeesRequest {
  EducationFeesRequest({
    required this.fromAc,
    required this.pin,
    required this.schoolPaymentInfo,
    required this.toAc,
    required this.userType,
  });

  String fromAc;
  String pin;
  SchoolPaymentInfo schoolPaymentInfo;
  String toAc;
  String userType;

  factory EducationFeesRequest.fromJson(Map<String, dynamic> json) => EducationFeesRequest(
    fromAc: json["fromAc"],
    pin: json["pin"],
    schoolPaymentInfo: SchoolPaymentInfo.fromJson(json["schoolPaymentInfo"]),
    toAc: json["toAc"],
    userType: json["userType"],
  );

  Map<String, dynamic> toJson() => {
    "fromAc": fromAc,
    "pin": pin,
    "schoolPaymentInfo": schoolPaymentInfo.toJson(),
    "toAc": toAc,
    "userType": userType,
  };
}

class SchoolPaymentInfo {
  SchoolPaymentInfo({
    required this.amount,
    required this.channel,
    required this.fromAc,
    required this.insCode,
    required this.insWallet,
    required this.notificationNumber,
    required this.regId,
    required this.remarks,
    required this.status,
    required this.txnNo,
    required this.txnTime,
    required this.txnType,
  });

  int amount;
  String channel;
  String fromAc;
  String insCode;
  String insWallet;
  String notificationNumber;
  String regId;
  String remarks;
  String status;
  String txnNo;
  String txnTime;
  String txnType;

  factory SchoolPaymentInfo.fromJson(Map<String, dynamic> json) => SchoolPaymentInfo(
    amount: json["amount"],
    channel: json["channel"],
    fromAc: json["fromAc"],
    insCode: json["insCode"],
    insWallet: json["insWallet"],
    notificationNumber: json["notificationNumber"],
    regId: json["regId"],
    remarks: json["remarks"],
    status: json["status"],
    txnNo: json["txnNo"],
    txnTime: json["txnTime"],
    txnType: json["txnType"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "channel": channel,
    "fromAc": fromAc,
    "insCode": insCode,
    "insWallet": insWallet,
    "notificationNumber": notificationNumber,
    "regId": regId,
    "remarks": remarks,
    "status": status,
    "txnNo": txnNo,
    "txnTime": txnTime,
    "txnType": txnType,
  };
}