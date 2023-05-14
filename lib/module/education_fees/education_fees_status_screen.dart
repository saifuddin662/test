import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../core/di/feature_details_singleton.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_common_status_widget.dart';
import '../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../utils/api_urls.dart';
import '../../utils/feature_details_keys.dart';
import '../dashboard/dashboard_screen.dart';
import '../statements/education_fees/data/statement_edu_data_controller.dart';
import 'api/model/EducationFeesRequest.dart';
import 'beneficiary/data/edu_fee_data_controller.dart';
import 'beneficiary/model/edu_common_confirm_model.dart';
import 'beneficiary/model/edu_summary_detail_model.dart';
import 'beneficiary/model/edu_txn_info_model.dart';
import 'education_fees_confirm_screen.dart';

/// Created by Md. Awon-Uz-Zaman on 09/February/2023

class EducationFeesStatusScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;
  final SchoolPaymentInfo schoolInfo;
  final String status;
  final bool isPaid;
  final bool isOpen;

  const EducationFeesStatusScreen ({
    Key? key,
    required this.confirmDialogModel,
    required this.schoolInfo,
    required this.status,
    required this.isPaid,
    required this.isOpen
  }) : super(key: key);

  @override
  BaseConsumerState<EducationFeesStatusScreen> createState() => _EducationFeesStatusScreenState();
}

class _EducationFeesStatusScreenState extends BaseConsumerState<EducationFeesStatusScreen> {
  FeatureDetailsSingleton featureDetailsSingleton = FeatureDetailsSingleton();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     ref.read(checkBalanceControllerProvider.notifier).checkBalance();
  //   });
  // }

  @override
  Widget build(BuildContext context) {

    saveEduTxnInfo(widget.confirmDialogModel, widget.schoolInfo, widget.isPaid, widget.status, widget.isOpen);

    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'education_fees'),
      body: CustomCommonStatusWidget(
        confirmDialogModel: widget.confirmDialogModel,
        status: widget.status,
        imageUrl: featureDetailsSingleton.feature[FeatureDetailsKeys.educationFees]!.imageUrl ?? "",
      ),
      bottomSheet: SafeNextButtonWidget(
          text: widget.isPaid ? "home".tr() : "next".tr(),
          onPressedFunction: () {
            if (widget.isPaid) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) => const DashboardScreen()
              ), (route) => false);
            }
            else {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) =>
                  EducationFeesConfirmScreen(
                    confirmDialogModel: CommonConfirmDialogModel(
                        widget.confirmDialogModel.appBarTitle,
                        widget.confirmDialogModel.transactionTitle,
                        widget.confirmDialogModel.recipientSummary,
                        widget.confirmDialogModel.transactionSummary,
                        ApiUrls.schoolPayment
                    ),
                    schoolInfo: widget.schoolInfo,
                  )
              ));
            }
          }
      ),
    );
  }

  void saveEduTxnInfo(CommonConfirmDialogModel commonConfirmDialog, SchoolPaymentInfo schoolInfo, bool isPaid, String status, bool isOpen) {
    List<EduSummaryDetailsModel> summaryList = commonConfirmDialog.transactionSummary
        .map((summary) => EduSummaryDetailsModel(
        title: summary.title, description: summary.description))
        .toList();

    final eduTxnInfoModel = EduTxnInfoModel(
      saveTime: DateTime.now().millisecondsSinceEpoch,
      insCode: schoolInfo.insCode,
      insName: StatementEduDataController.instance.eduInfo.insName,
      studentName: '',
      regNo: schoolInfo.regId,
      amount: '',
      status: status,
      isPaid: isPaid,
      isOpen: isOpen,
      schoolInfo: schoolInfo,
      eduCommonConfirmModel: EduCommonConfirmModel(
          appBarTitle: commonConfirmDialog.appBarTitle,
          transactionTitle: commonConfirmDialog.transactionTitle,
          recipientSummary: commonConfirmDialog.recipientSummary,
          transactionSummary: summaryList,
          apiUrl: commonConfirmDialog.apiUrl),
    );

    EduFeeDataController.instance.eduTxnInfoModel = eduTxnInfoModel;

    try{
      StatementEduDataController.instance.eduInfo.insName = summaryList[1].description ?? '';
      StatementEduDataController.instance.eduInfo.studentName = summaryList[3].description ?? '';
      StatementEduDataController.instance.eduInfo.regId = summaryList[4].description ?? '';
    } catch(e)
    {}



    log.info('Beneficiary: saving edu txn info for beneficiary --> ${EduFeeDataController.instance.eduTxnInfoModel}');
  }
}