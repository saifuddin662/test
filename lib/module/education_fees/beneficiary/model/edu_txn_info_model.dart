import 'dart:convert';

import '../../api/model/EducationFeesRequest.dart';
import 'edu_common_confirm_model.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 02,April,2023.

class EduTxnInfoModel{

  int? saveTime;
  String? insCode;
  String? insName;
  String? studentName;
  String? regNo;
  String? amount;
  String? status;
  String? fee;
  bool? isPaid;
  bool? isOpen;

  EduCommonConfirmModel? eduCommonConfirmModel;
  SchoolPaymentInfo? schoolInfo;


  static String encode(List<EduTxnInfoModel> messageList) => json.encode(
    messageList.map<Map<String, dynamic>>((message) => message.toMap())
        .toList(),
  );

  static List<EduTxnInfoModel> decode(String messages) =>
      (json.decode(messages) as List<dynamic>).map<EduTxnInfoModel>((item) => EduTxnInfoModel.fromMap(item)).toList();

//<editor-fold desc="Data Methods">
  EduTxnInfoModel({
    this.saveTime,
    this.insCode,
    this.insName,
    this.studentName,
    this.regNo,
    this.amount,
    this.status,
    this.isPaid,
    this.isOpen,
    this.eduCommonConfirmModel,
    this.schoolInfo,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is EduTxnInfoModel &&
              runtimeType == other.runtimeType &&
              saveTime == other.saveTime &&
              insCode == other.insCode &&
              insName == other.insName &&
              studentName == other.studentName &&
              regNo == other.regNo &&
              amount == other.amount &&
              status == other.status &&
              isPaid == other.isPaid &&
              isPaid == other.isOpen &&
              eduCommonConfirmModel == other.eduCommonConfirmModel &&
              schoolInfo == other.schoolInfo);

  @override
  int get hashCode =>
      saveTime.hashCode ^
      insCode.hashCode ^
      insName.hashCode ^
      studentName.hashCode ^
      regNo.hashCode ^
      amount.hashCode ^
      status.hashCode ^
      isPaid.hashCode ^
      isOpen.hashCode ^
      eduCommonConfirmModel.hashCode ^
      schoolInfo.hashCode;

  @override
  String toString() {
    return 'EduTxnInfoModel{' +
        ' saveTime: $saveTime,' +
        ' insCode: $insCode,' +
        ' insName: $insName,' +
        ' studentName: $studentName,' +
        ' regNo: $regNo,' +
        ' amount: $amount,' +
        ' status: $status,' +
        ' isPaid: $isPaid,' +
        ' isOpen: $isOpen,' +
        ' eduCommonConfirmModel: $eduCommonConfirmModel,' +
        ' schoolInfo: $schoolInfo,' +
        '}';
  }

  EduTxnInfoModel copyWith({
    int? saveTime,
    String? insCode,
    String? insName,
    String? studentName,
    String? regNo,
    String? amount,
    String? status,
    bool? isPaid,
    bool? isOpen,
    EduCommonConfirmModel? eduCommonConfirmModel,
    SchoolPaymentInfo? schoolInfo,
  }) {
    return EduTxnInfoModel(
      saveTime: saveTime ?? this.saveTime,
      insCode: insCode ?? this.insCode,
      insName: insName ?? this.insName,
      studentName: studentName ?? this.studentName,
      regNo: regNo ?? this.regNo,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      isPaid: isPaid ?? this.isPaid,
      isOpen: isOpen ?? this.isOpen,
      eduCommonConfirmModel:
      eduCommonConfirmModel ?? this.eduCommonConfirmModel,
      schoolInfo: schoolInfo ?? this.schoolInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'saveTime': this.saveTime,
      'insCode': this.insCode,
      'insName': this.insName,
      'studentName': this.studentName,
      'regNo': this.regNo,
      'amount': this.amount,
      'status': this.status,
      'isPaid': this.isPaid,
      'isOpen': this.isOpen,
      'eduCommonConfirmModel': eduCommonConfirmModel?.toMap(),
      'schoolInfo': schoolInfo?.toJson(),
    };
  }

  factory EduTxnInfoModel.fromMap(Map<String, dynamic> map) {
    return EduTxnInfoModel(
      saveTime: map['saveTime'] as int,
      insCode: map['insCode'] as String,
      insName: map['insName'] as String,
      studentName: map['studentName'] as String,
      regNo: map['regNo'] as String,
      amount: map['amount'] as String,
      status: map['status'] as String,
      isPaid: map['isPaid'] as bool,
      isOpen: map['isOpen'] as bool,
      eduCommonConfirmModel: EduCommonConfirmModel.fromMap(map['eduCommonConfirmModel']),
      schoolInfo: SchoolPaymentInfo.fromJson(map['schoolInfo']),
    );
  }

//</editor-fold>
}


/*
// from
eduCommonConfirmModel: EduCommonConfirmModel.fromMap(map['eduCommonConfirmModel']),
schoolInfo: SchoolPaymentInfo.fromJson(map['schoolInfo']),
// to
'eduCommonConfirmModel': eduCommonConfirmModel?.toMap(),
'schoolInfo': schoolInfo?.toJson(),
*/
