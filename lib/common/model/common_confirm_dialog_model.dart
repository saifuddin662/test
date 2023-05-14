import 'package:red_cash_dfs_flutter/common/model/summary_details_item.dart';

class CommonConfirmDialogModel {
  String appBarTitle;
  String transactionTitle;
  List<String> recipientSummary;
  List<SummaryDetailsItem> transactionSummary;
  String apiUrl;

  CommonConfirmDialogModel(
      this.appBarTitle,
      this.transactionTitle,
      this.recipientSummary,
      this.transactionSummary,
      this.apiUrl);
}