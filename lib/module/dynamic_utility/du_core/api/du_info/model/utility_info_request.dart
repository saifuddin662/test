/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 14,March,2023.

class UtilityInfoRequest {
  String? featureCode;
  String? walletNo;
  Map<String, dynamic>? dynamicFields;

  UtilityInfoRequest({
    this.featureCode,
    this.walletNo,
    this.dynamicFields,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UtilityInfoRequest &&
          runtimeType == other.runtimeType &&
          featureCode == other.featureCode &&
          walletNo == other.walletNo &&
          dynamicFields == other.dynamicFields);

  @override
  int get hashCode =>
      featureCode.hashCode ^ walletNo.hashCode ^ dynamicFields.hashCode;

  @override
  String toString() {
    return 'UtilityInfoRequest{ featureCode: $featureCode, walletNo: $walletNo, dynamicFields: $dynamicFields,}';
  }

  UtilityInfoRequest copyWith({
    String? featureCode,
    String? walletNo,
    Map<String, dynamic>? dynamicFields,
  }) {
    return UtilityInfoRequest(
      featureCode: featureCode ?? this.featureCode,
      walletNo: walletNo ?? this.walletNo,
      dynamicFields: dynamicFields ?? this.dynamicFields,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'featureCode': featureCode,
      'walletNo': walletNo,
      'dynamicFields': dynamicFields,
    };
  }

  factory UtilityInfoRequest.fromMap(Map<String, dynamic> map) {
    return UtilityInfoRequest(
      featureCode: map['featureCode'] as String,
      walletNo: map['walletNo'] as String,
      dynamicFields: map['dynamicFields'] as Map<String, dynamic>,
    );
  }
}
