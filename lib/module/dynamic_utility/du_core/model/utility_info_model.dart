import '../api/du_info/model/utility_info_response.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 14,March,2023.

class UtilityInfoModel {
  String utilityTitle;
  String utilityCode;
  String dueAmount;
  String currentBalance;
  String logoUrl;
  String txnId;
  bool isPaid;
  List<String>? recipientSummary;
  List<InfoItemArrayList>? transactionSummary;

  UtilityInfoModel({
    required this.utilityTitle,
    required this.utilityCode,
    required this.dueAmount,
    required this.currentBalance,
    required this.logoUrl,
    required this.txnId,
    required this.isPaid,
    this.recipientSummary,
    this.transactionSummary,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UtilityInfoModel &&
          runtimeType == other.runtimeType &&
          utilityTitle == other.utilityTitle &&
          utilityCode == other.utilityCode &&
          dueAmount == other.dueAmount &&
          currentBalance == other.currentBalance &&
          logoUrl == other.logoUrl &&
          txnId == other.txnId &&
          isPaid == other.isPaid &&
          recipientSummary == other.recipientSummary &&
          transactionSummary == other.transactionSummary);

  @override
  int get hashCode =>
      utilityTitle.hashCode ^
      utilityCode.hashCode ^
      dueAmount.hashCode ^
      currentBalance.hashCode ^
      logoUrl.hashCode ^
      txnId.hashCode ^
      isPaid.hashCode ^
      recipientSummary.hashCode ^
      transactionSummary.hashCode;

  @override
  String toString() {
    return 'UtilityInfoModel{ utilityTitle: $utilityTitle, utilityCode: $utilityCode, dueAmount: $dueAmount, currentBalance: $currentBalance, logoUrl: $logoUrl, txnId: $txnId, isPaid: $isPaid, recipientSummary: $recipientSummary, transactionSummary: $transactionSummary,}';
  }

  UtilityInfoModel copyWith({
    String? utilityTitle,
    String? utilityCode,
    String? dueAmount,
    String? currentBalance,
    String? logoUrl,
    String? txnId,
    bool? isPaid,
    List<String>? recipientSummary,
    List<InfoItemArrayList>? transactionSummary,
  }) {
    return UtilityInfoModel(
      utilityTitle: utilityTitle ?? this.utilityTitle,
      utilityCode: utilityCode ?? this.utilityCode,
      dueAmount: dueAmount ?? this.dueAmount,
      currentBalance: currentBalance ?? this.currentBalance,
      logoUrl: logoUrl ?? this.logoUrl,
      txnId: txnId ?? this.txnId,
      isPaid: isPaid ?? this.isPaid,
      recipientSummary: recipientSummary ?? this.recipientSummary,
      transactionSummary: transactionSummary ?? this.transactionSummary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'utilityTitle': utilityTitle,
      'utilityCode': utilityCode,
      'dueAmount': dueAmount,
      'currentBalance': currentBalance,
      'logoUrl': logoUrl,
      'txnId': txnId,
      'isPaid': isPaid,
      'recipientSummary': recipientSummary,
      'transactionSummary': transactionSummary,
    };
  }

  factory UtilityInfoModel.fromMap(Map<String, dynamic> map) {
    return UtilityInfoModel(
      utilityTitle: map['utilityTitle'] as String,
      utilityCode: map['utilityCode'] as String,
      dueAmount: map['dueAmount'] as String,
      currentBalance: map['currentBalance'] as String,
      logoUrl: map['logoUrl'] as String,
      txnId: map['txnId'] as String,
      isPaid: map['isPaid'] as bool,
      recipientSummary: map['recipientSummary'] as List<String>,
      transactionSummary: map['transactionSummary'] as List<InfoItemArrayList>,
    );
  }
}
