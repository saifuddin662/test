import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/base_consumer_state.dart';
import '../../common/common_api/get_transaction_fee/model/transaction_fee_request.dart';
import '../../common/common_api/get_transaction_fee/transaction_fee_controller.dart';
import '../../common/constants.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../common/model/summary_details_item.dart';
import '../../common/toasts.dart';
import '../../core/di/core_providers.dart';
import '../../core/flavor/flavor_provider.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../utils/Colors.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_utils.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/pref_keys.dart';
import '../../utils/styles.dart';
import '../statements/education_fees/data/statement_edu_data_controller.dart';
import 'api/model/EducationFeesRequest.dart';
import 'api/model/institute_list_response.dart';
import 'api/model/school_fees_response.dart';
import 'education_fees_status_screen.dart';

/// Created by Md. Awon-Uz-Zaman on 02/February/2023

class FeeListScreen extends ConsumerStatefulWidget {
  const FeeListScreen ({
    Key? key,
    required this.feeResponse,
    required this.institute,
    required this.regId,
    required this.notificationNumber,
  }) : super(key: key);

  final SchoolFeesResponse? feeResponse;
  final Institute institute;
  final String regId;
  final String notificationNumber;

  @override
  BaseConsumerState<FeeListScreen> createState() => _FeeListScreenState();
}

class _FeeListScreenState extends BaseConsumerState<FeeListScreen> {

  late double selectedFee;
  var isNavOn =false;

  @override
  void initState() {
    super.initState();
    selectedFee = widget.feeResponse!.feeList![0];
  }

  void listenResponse(currentBalance){
    final userWalletNumber = ref.read(localPrefProvider).getString(PrefKeys.keyMsisdn)!;

    final userType = ref.read(flavorProvider).name;
    var txnType = 'PAYMENT';

    if (userType == AppConstants.userTypeAgent) {
      txnType = 'AGENT_ASSISTED_PAYMENT';
    } else {
      txnType = 'PAYMENT';
    }

    ref.listen<AsyncValue>(
      transactionFeeControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();

          log.info('-------------------------------------------------------> transactionFeeControllerProvider = fee list screen ');

          storeStatementData();

          final charge = currentState.value.chargeAmount != null? currentState.value.chargeAmount.toString(): "0";

          CommonConfirmDialogModel commonConfirmDialog = processCommonConfirmDialogData(currentBalance, charge);
          SchoolPaymentInfo schoolInfo = processSchoolInfoData(userWalletNumber, txnType, charge);
          final bool isPaid = double.parse(selectedFee.toString()) <= 0.0 ? true : false;
          const status =  Constants.unpaid;

          if (isNavOn) {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                EducationFeesStatusScreen(
                  isPaid: isPaid,
                  confirmDialogModel: commonConfirmDialog,
                  schoolInfo: schoolInfo,
                  status:status,
                  isOpen: false,
                ))
            );
          }
        }
      },
    );
  }

  SchoolPaymentInfo processSchoolInfoData(String userWalletNumber, String txnType, String charge) {

    //final charge = currentState.value.chargeAmount != null? currentState.value.chargeAmount.toString(): "0";
    final amount = double.parse(charge.toString()) + selectedFee;

    final schoolInfo = SchoolPaymentInfo(
      amount: amount.toInt(),
      channel: "App",
      fromAc: userWalletNumber,
      insCode: widget.institute.code,
      insWallet: widget.institute.wallet,
      notificationNumber: widget.notificationNumber,
      regId: widget.regId,
      remarks: "N/A",
      status: "",
      txnNo: "",
      txnTime: "",
      txnType: txnType,
    );
    return schoolInfo;
  }

  CommonConfirmDialogModel processCommonConfirmDialogData(currentBalance, String charge) {
    final commonConfirmDialog = CommonConfirmDialogModel(
        "education_fees".tr(),
        "education_fees".tr(),
        [
          widget.feeResponse?.institutionName ?? "",
          "৳ $selectedFee",
          currentBalance.toString(),
        ],
        [
          SummaryDetailsItem(
              "ins_code".tr(),
              widget.institute.code.toString()
          ),
          SummaryDetailsItem(
              "ins_name".tr(),
              widget.feeResponse!.institutionName.toString()
          ),
          SummaryDetailsItem(
              "amount".tr(),
              "৳ $selectedFee"
          ),
          SummaryDetailsItem(
              "student_name".tr(),
              widget.feeResponse!.studentName.toString()
          ),
          SummaryDetailsItem(
              "reg_id".tr(),
              widget.regId
          ),
          SummaryDetailsItem(
              "charge".tr(),
              charge
          ),
        ],
        ApiUrls.schoolPayment
    );
    return commonConfirmDialog;
  }

  @override
  Widget build(BuildContext context) {
    final userWalletNumber = ref.read(localPrefProvider).getString(PrefKeys.keyMsisdn)!;
    final currentBalance = ref.read(localPrefProvider).getString(PrefKeys.keyUserBalance);
    listenResponse(currentBalance);

    return Scaffold(
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'education_fees'),
      bottomSheet: SafeNextButtonWidget(
          text: "next".tr(),
          onPressedFunction: () {
            AppUtils.hideKeyboard();
            isNavOn =true;

            final userType = ref.read(flavorProvider).name;
            var paymentType = 'PAYMENT';

            if (userType == AppConstants.userTypeAgent) {
              paymentType = 'AGENT_ASSISTED_PAYMENT';
            } else {
              paymentType = 'PAYMENT';
            }


            ref.read(transactionFeeControllerProvider.notifier).getTransactionFee(
                TransactionFeeRequest(
                    userWalletNumber,
                    widget.feeResponse?.institutionWallet ?? "",
                    paymentType,
                    selectedFee.toString()
                )
            );
          }
      ),
      body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: AppDimen.toolbarBottomGap),
            Padding(
              padding: const EdgeInsets.only(left: DimenSizes.dimen_20,right: DimenSizes.dimen_20),
              child: CustomCommonTextWidget(
                text: "select_amount".tr(),
                style: CommonTextStyle.bold_14,
                color: colorPrimaryText ,
              ),
            ),
            const SizedBox(height: AppDimen.toolbarBottomGap),
            Row(
              children: [
                Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: DimenSizes.dimen_20,right: DimenSizes.dimen_20),
                      padding: const EdgeInsets.only(left: DimenSizes.dimen_5,right: DimenSizes.dimen_5),
                      decoration:BoxDecoration(
                      borderRadius: AppDimen.commonCircularBorderRadius,
                      border: Border.all(color: Colors.grey, width: 0.80),
                    ),

                      child: DropdownButton(
                        isExpanded: true,
                        value: selectedFee,
                        hint: CustomCommonTextWidget(
                              text: "select_amount".tr(),
                              style : CommonTextStyle.regular_14,
                              color: suvaGray
                          ),
                        items: _dropdownItems(),
                        underline: const SizedBox(),//dropdownItems,
                        onChanged: (val) {
                          setState(() {
                            selectedFee = val!;
                          });
                        },
                      ),
                    )
                )
              ],
            ),
            const SizedBox(height: DimenSizes.dimen_10),
          ]
      ),
    );
  }

  List<DropdownMenuItem<double>> _dropdownItems(){
    List<DropdownMenuItem<double>> dropdownItemList = [];
    for (double fee in widget.feeResponse!.feeList!) {
      if (fee != null) {
        var newItem = DropdownMenuItem(
          value: fee,
          child: Text(fee.toString()),
        );
        dropdownItemList.add(newItem);
      }
    }
    return dropdownItemList;
  }

  void storeStatementData() {
    StatementEduDataController.instance.eduInfo.insName = widget.institute.name;
    StatementEduDataController.instance.eduInfo.regId = widget.regId;
    StatementEduDataController.instance.eduInfo.studentName = widget.feeResponse!.studentName.toString();
  }
}