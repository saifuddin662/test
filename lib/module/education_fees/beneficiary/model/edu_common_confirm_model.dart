import 'edu_summary_detail_model.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 02,April,2023.

class EduCommonConfirmModel {
  String appBarTitle;
  String transactionTitle;
  List<String> recipientSummary;
  List<EduSummaryDetailsModel> transactionSummary;
  String apiUrl;

//<editor-fold desc="Data Methods">
  EduCommonConfirmModel({
    required this.appBarTitle,
    required this.transactionTitle,
    required this.recipientSummary,
    required this.transactionSummary,
    required this.apiUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EduCommonConfirmModel &&
          runtimeType == other.runtimeType &&
          appBarTitle == other.appBarTitle &&
          transactionTitle == other.transactionTitle &&
          recipientSummary == other.recipientSummary &&
          transactionSummary == other.transactionSummary &&
          apiUrl == other.apiUrl);

  @override
  int get hashCode =>
      appBarTitle.hashCode ^
      transactionTitle.hashCode ^
      recipientSummary.hashCode ^
      transactionSummary.hashCode ^
      apiUrl.hashCode;

  @override
  String toString() {
    return 'EduCommonConfirmModel{' +
        ' appBarTitle: $appBarTitle,' +
        ' transactionTitle: $transactionTitle,' +
        ' recipientSummary: $recipientSummary,' +
        ' transactionSummary: $transactionSummary,' +
        ' apiUrl: $apiUrl,' +
        '}';
  }

  EduCommonConfirmModel copyWith({
    String? appBarTitle,
    String? transactionTitle,
    List<String>? recipientSummary,
    List<EduSummaryDetailsModel>? transactionSummary,
    String? apiUrl,
  }) {
    return EduCommonConfirmModel(
      appBarTitle: appBarTitle ?? this.appBarTitle,
      transactionTitle: transactionTitle ?? this.transactionTitle,
      recipientSummary: recipientSummary ?? this.recipientSummary,
      transactionSummary: transactionSummary ?? this.transactionSummary,
      apiUrl: apiUrl ?? this.apiUrl,
    );
  }

  Map<String, dynamic> toMap() {

    List<Map<String, dynamic>> itemJson = [];
    for (EduSummaryDetailsModel item in transactionSummary) {
      itemJson.add(item.toMap());
    }

    return {
      'appBarTitle': this.appBarTitle,
      'transactionTitle': this.transactionTitle,
      'recipientSummary': this.recipientSummary,
      'transactionSummary': itemJson,
      'apiUrl': this.apiUrl,
    };
  }

  factory EduCommonConfirmModel.fromMap(Map<String, dynamic> map) {

    List<EduSummaryDetailsModel> items = [];
    for (Map<String, dynamic> itemJson in map['transactionSummary']) {
      items.add(EduSummaryDetailsModel.fromMap(itemJson));
    }

    List<String> ListTwo = map['recipientSummary'].cast<String>();

    return EduCommonConfirmModel(
      appBarTitle: map['appBarTitle'] as String,
      transactionTitle: map['transactionTitle'] as String,
      recipientSummary: map['recipientSummary'].cast<String>(),
      transactionSummary: items,
      apiUrl: map['apiUrl'] as String,
    );
  }

//</editor-fold>
}