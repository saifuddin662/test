///Created by Md. Awon-Uz-Zaman on 12/February/2023

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../core/di/core_providers.dart';
import '../../ui/custom_widgets/custom_common_success_widget.dart';
import '../../utils/pref_keys.dart';
import 'api/model/EducationFeesRequest.dart';
import 'beneficiary/data/edu_fee_data_controller.dart';
import 'beneficiary/model/edu_common_confirm_model.dart';
import 'beneficiary/model/edu_txn_info_model.dart';

class EducationFeesSuccessScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;
  final String? apiMessage;

  const EducationFeesSuccessScreen({
    Key? key,
    required this.confirmDialogModel,
    this.apiMessage
  }) : super(key: key);

  @override
  ConsumerState<EducationFeesSuccessScreen> createState() => _EducationFeesSuccessScreenState();
}

class _EducationFeesSuccessScreenState extends BaseConsumerState<EducationFeesSuccessScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (EduFeeDataController.instance.isSavedChecked) {
        var savedTxnList = loadSavedEduTxn();
        var toBeSavedTxn = EduFeeDataController.instance.eduTxnInfoModel;

        if (!isAlreadySaved(savedTxnList, toBeSavedTxn)) {
          savedTxnList.add(toBeSavedTxn);
          ref.read(localPrefProvider).setString(PrefKeys.keyEduSavedTxnList,
              EduTxnInfoModel.encode(savedTxnList));
          log.info('edu txn saved....');
        } else {
          log.info('duplicate edu is not saved....');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomCommonSuccessWidget(
        title: "education_fees".tr(),
        apiMessage: widget.apiMessage,
        hasStatement: true,
        confirmDialogModel: CommonConfirmDialogModel(
            widget.confirmDialogModel.appBarTitle,
            widget.confirmDialogModel.transactionTitle,
            widget.confirmDialogModel.recipientSummary,
            widget.confirmDialogModel.transactionSummary,
            widget.confirmDialogModel.apiUrl
        ),
      ),
    );
  }

  bool isAlreadySaved(List<EduTxnInfoModel> savedTxnList, EduTxnInfoModel toBeSavedTxn) {
    return savedTxnList.where((element) => element.schoolInfo!.insCode == toBeSavedTxn.schoolInfo!.insCode).isNotEmpty;
  }

  List<EduTxnInfoModel> loadSavedEduTxn() {
    var txnListInString = ref.read(localPrefProvider).getString(PrefKeys.keyEduSavedTxnList);
    List<EduTxnInfoModel>? savedTxnList = [];

    if(txnListInString != null)
    {
      var dataList = (json.decode(txnListInString) as List<dynamic>);

      savedTxnList = dataList
          .map((item) => EduTxnInfoModel(
          saveTime: item['saveTime'],
          insCode: item['insCode'],
          insName: item['insName'],
          studentName: item['studentName'],
          regNo: item['regNo'],
          amount: item['amount'],
          status: item['status'],
          isPaid: item['isPaid'],
          isOpen: item['isOpen'],
          eduCommonConfirmModel: EduCommonConfirmModel.fromMap(item['eduCommonConfirmModel']),
          schoolInfo: SchoolPaymentInfo.fromJson(item['schoolInfo'])))
          .toList();
    }

    return savedTxnList;
  }

}