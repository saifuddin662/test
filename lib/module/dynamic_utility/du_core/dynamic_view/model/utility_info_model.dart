/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 21,March,2023.

class UtilityInfoModel {
  String? featureCode;
  String? transactionId;
  String? notificationNumber;

  UtilityInfoModel({
    this.featureCode,
    this.transactionId,
    this.notificationNumber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UtilityInfoModel &&
          runtimeType == other.runtimeType &&
          featureCode == other.featureCode &&
          transactionId == other.transactionId &&
          notificationNumber == other.notificationNumber);

  @override
  int get hashCode =>
      featureCode.hashCode ^
      transactionId.hashCode ^
      notificationNumber.hashCode;

  @override
  String toString() {
    return 'UtilityInfoModel{ featureCode: $featureCode, transactionId: $transactionId, notificationNumber: $notificationNumber,}';
  }

  UtilityInfoModel copyWith({
    String? featureCode,
    String? transactionId,
    String? notificationNumber,
  }) {
    return UtilityInfoModel(
      featureCode: featureCode ?? this.featureCode,
      transactionId: transactionId ?? this.transactionId,
      notificationNumber: notificationNumber ?? this.notificationNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'featureCode': featureCode,
      'transactionId': transactionId,
      'notificationNumber': notificationNumber,
    };
  }

  factory UtilityInfoModel.fromMap(Map<String, dynamic> map) {
    return UtilityInfoModel(
      featureCode: map['featureCode'] as String,
      transactionId: map['transactionId'] as String,
      notificationNumber: map['notificationNumber'] as String,
    );
  }
}
