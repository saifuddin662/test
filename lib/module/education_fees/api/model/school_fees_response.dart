

/**
 * Created by Md. Awon-Uz-Zaman on 01/February/2023
 */

class SchoolFeesResponse {
  SchoolFeesResponse({
    this.institutionWallet,
    this.institutionName,
    this.code,
    this.message,
    this.amount,
    this.feeList,
    this.studentName,
  });

  final String? institutionWallet;
  final String? institutionName;
  final int? code;
  final String? message;
  final double? amount;
  final List<double>? feeList;
  final String? studentName;

  SchoolFeesResponse copyWith() =>
      SchoolFeesResponse(
        institutionWallet: institutionWallet ?? institutionWallet,
        institutionName: institutionName ?? institutionName,
        code: code ?? code,
        message: message ?? message,
        amount: amount ?? amount,
        feeList: feeList ?? feeList,
        studentName: studentName ?? studentName,
      );

  factory SchoolFeesResponse.fromJson(Map<String, dynamic> json) => SchoolFeesResponse(
    institutionWallet: json["insWallet"],
    institutionName: json["insName"],
    code: json["code"],
    message: json["message"],
    amount: json["amount"],
    feeList: json['feeList'] == null ? null : List<double>.from(json["feeList"]?.map((x) => x)),
    studentName: json["studentName"],
  );
}