/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 01,April,2023.

class StatementEduInfoModel {

  String? title;
  int? insCode;
  String? insName;
  String? amount;
  String? charge;
  String? totalPaid;
  String? regId;
  String? studentName;
  String? txnId;
  String? txnDate;
  String? wallet;

//<editor-fold desc="Data Methods">
  StatementEduInfoModel({
    this.title,
    this.insCode,
    this.insName,
    this.amount,
    this.charge,
    this.totalPaid,
    this.regId,
    this.studentName,
    this.txnId,
    this.txnDate,
    this.wallet,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StatementEduInfoModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          insCode == other.insCode &&
          insName == other.insName &&
          amount == other.amount &&
          charge == other.charge &&
          totalPaid == other.totalPaid &&
          regId == other.regId &&
          studentName == other.studentName &&
          txnId == other.txnId &&
          txnDate == other.txnDate &&
          wallet == other.wallet);

  @override
  int get hashCode =>
      title.hashCode ^
      insCode.hashCode ^
      insName.hashCode ^
      amount.hashCode ^
      charge.hashCode ^
      totalPaid.hashCode ^
      regId.hashCode ^
      studentName.hashCode ^
      txnId.hashCode ^
      txnDate.hashCode ^
      wallet.hashCode;

  @override
  String toString() {
    return 'StatementEduInfoModel{ title: $title, insCode: $insCode, insName: $insName, amount: $amount, charge: $charge, totalPaid: $totalPaid, regId: $regId, studentName: $studentName, txnId: $txnId, txnDate: $txnDate, wallet: $wallet,}';
  }

  StatementEduInfoModel copyWith({
    String? title,
    int? insCode,
    String? insName,
    String? amount,
    String? charge,
    String? totalPaid,
    String? regId,
    String? studentName,
    String? txnId,
    String? txnDate,
    String? wallet,
  }) {
    return StatementEduInfoModel(
      title: title ?? this.title,
      insCode: insCode ?? this.insCode,
      insName: insName ?? this.insName,
      amount: amount ?? this.amount,
      charge: charge ?? this.charge,
      totalPaid: totalPaid ?? this.totalPaid,
      regId: regId ?? this.regId,
      studentName: studentName ?? this.studentName,
      txnId: txnId ?? this.txnId,
      txnDate: txnDate ?? this.txnDate,
      wallet: wallet ?? this.wallet,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': this.title,
      'insCode': this.insCode,
      'insName': this.insName,
      'amount': this.amount,
      'charge': this.charge,
      'totalPaid': this.totalPaid,
      'regId': this.regId,
      'studentName': this.studentName,
      'txnId': this.txnId,
      'txnDate': this.txnDate,
      'wallet': this.wallet,
    };
  }

  factory StatementEduInfoModel.fromMap(Map<String, dynamic> map) {
    return StatementEduInfoModel(
      title: map['title'] as String,
      insCode: map['insCode'] as int,
      insName: map['insName'] as String,
      amount: map['amount'] as String,
      charge: map['charge'] as String,
      totalPaid: map['totalPaid'] as String,
      regId: map['regId'] as String,
      studentName: map['studentName'] as String,
      txnId: map['txnId'] as String,
      txnDate: map['txnDate'] as String,
      wallet: map['wallet'] as String,
    );
  }

//</editor-fold>
}
