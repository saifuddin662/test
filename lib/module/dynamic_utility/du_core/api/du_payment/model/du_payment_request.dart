

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 16,March,2023.


class UtilityPaymentRequest {

  String? featureCode;
  String? transactionId;
  String? walletNo;
  String? pin;
  String? notificationNumber;

  UtilityPaymentRequest({
    this.featureCode,
    this.transactionId,
    this.walletNo,
    this.pin,
    this.notificationNumber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UtilityPaymentRequest &&
          runtimeType == other.runtimeType &&
          featureCode == other.featureCode &&
          transactionId == other.transactionId &&
          walletNo == other.walletNo &&
          pin == other.pin &&
          notificationNumber == other.notificationNumber);

  @override
  int get hashCode =>
      featureCode.hashCode ^
      transactionId.hashCode ^
      walletNo.hashCode ^
      pin.hashCode ^
      notificationNumber.hashCode;

  @override
  String toString() {
    return 'UtilityPaymentRequest{ featureCode: $featureCode, transactionId: $transactionId, walletNo: $walletNo, pin: $pin, notificationNumber: $notificationNumber,}';
  }

  UtilityPaymentRequest copyWith({
    String? featureCode,
    String? transactionId,
    String? walletNo,
    String? pin,
    String? notificationNumber,
  }) {
    return UtilityPaymentRequest(
      featureCode: featureCode ?? this.featureCode,
      transactionId: transactionId ?? this.transactionId,
      walletNo: walletNo ?? this.walletNo,
      pin: pin ?? this.pin,
      notificationNumber: notificationNumber ?? this.notificationNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'featureCode': featureCode,
      'transactionId': transactionId,
      'walletNo': walletNo,
      'pin': pin,
      'notificationNumber': notificationNumber,
    };
  }

  factory UtilityPaymentRequest.fromMap(Map<String, dynamic> map) {
    return UtilityPaymentRequest(
      featureCode: map['featureCode'] as String,
      transactionId: map['transactionId'] as String,
      walletNo: map['walletNo'] as String,
      pin: map['pin'] as String,
      notificationNumber: map['notificationNumber'] as String,
    );
  }
}
