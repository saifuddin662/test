import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/utils/extensions/extension_two_decimal.dart';
import '../../base/base_consumer_state.dart';
import '../../common/common_api/check_balance/check_balance_controller.dart';
import '../../common/common_api/get_transaction_fee/model/transaction_fee_request.dart';
import '../../common/common_api/get_transaction_fee/transaction_fee_controller.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../common/model/summary_details_item.dart';
import '../../common/toasts.dart';
import '../../core/di/core_providers.dart';
import '../../core/di/feature_details_singleton.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_common_enter_amout_widget.dart';
import '../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_utils.dart';
import '../../utils/feature_details_keys.dart';
import '../../utils/number_formatter.dart';
import '../../utils/pref_keys.dart';
import 'cash_out_confirm_screen.dart';


class CashOutEnterAmountScreen extends ConsumerStatefulWidget {
  final String agentName;
  final String agentNumber;

  const CashOutEnterAmountScreen({
    super.key,
    required this.agentName,
    required this.agentNumber
  });

  @override
  ConsumerState<CashOutEnterAmountScreen> createState() => _CashOutEnterAmountScreenState();
}

class _CashOutEnterAmountScreenState extends BaseConsumerState<CashOutEnterAmountScreen> {

  FeatureDetailsSingleton featureDetailsSingleton = FeatureDetailsSingleton();
  final cashOutAmount = TextEditingController();

  var amountList = [50, 100, 200, 500, 1000, 2000];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(checkBalanceControllerProvider.notifier).checkBalance();
    });
  }

  @override
  Widget build(BuildContext context) {

    final userWalletNumber = ref.read(localPrefProvider).getString(PrefKeys.keyMsisdn);
    final currentBalance = ref.read(localPrefProvider).getString(PrefKeys.keyUserBalance);

    final minLimit = featureDetailsSingleton.feature[FeatureDetailsKeys.cashOutCustomer]!.minLimit.toString();
    final maxLimit = featureDetailsSingleton.feature[FeatureDetailsKeys.cashOutCustomer]!.maxLimit.toString();
    final featureIcon = featureDetailsSingleton.feature[FeatureDetailsKeys.cashOutCustomer]?.imageUrl;
    final transactionType = featureDetailsSingleton.feature[FeatureDetailsKeys.cashOutCustomer]?.transactionType;

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
          (NumberFormatter.stringToDouble(currentBalance.toString())
              - NumberFormatter.stringToDouble(cashOutAmount.text)
              - NumberFormatter.stringToDouble(currentState.value.chargeAmount.toString())).isNegative ?
          Toasts.showErrorToast("insufficient_fund".tr()) :
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              CashOutConfirmScreen(
                confirmDialogModel: CommonConfirmDialogModel(
                    "cash_out".tr(),
                    "cash_out".tr(),
                    [
                      widget.agentName,
                      widget.agentNumber
                    ],
                    [
                      SummaryDetailsItem(
                          "transaction_amount".tr(),
                          "৳ ${(NumberFormatter.stringToDouble(cashOutAmount.text)).convertTwoDecimal()}"
                      ),
                      SummaryDetailsItem(
                          "new_balance".tr(),
                          "৳ ${(NumberFormatter.stringToDouble(currentBalance.toString())
                              - NumberFormatter.stringToDouble(cashOutAmount.text)
                              - NumberFormatter.stringToDouble(currentState.value.chargeAmount.toString())).convertTwoDecimal()}"
                      ),
                      SummaryDetailsItem(
                          "charge".tr(),
                          "৳ ${currentState.value.chargeAmount}"
                      ),
                      SummaryDetailsItem(
                          "total_amount".tr(),
                          "৳ ${(NumberFormatter.stringToDouble(currentState.value.chargeAmount.toString()) + NumberFormatter.stringToDouble(cashOutAmount.text)).convertTwoDecimal()}"
                      ),
                    ],
                    ApiUrls.cashOutApi
                ),
              )));
        }
      },
    );


    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'cash_out'),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CustomCommonEnterAmountWidget(
          amountList: amountList,
          imageUrl: "$featureIcon",
          username: widget.agentName,
          currentBalance: '$currentBalance',
          amountController: cashOutAmount,
        ),
      ),
      bottomSheet: SafeNextButtonWidget(
          text: "next".tr(),
          onPressedFunction: () {
            AppUtils.hideKeyboard();
            if(cashOutAmount.text.isNotEmpty) {
              if(NumberFormatter.stringToDouble(cashOutAmount.text) < NumberFormatter.stringToDouble(minLimit)){
                Toasts.showErrorToast("${"min_amount_msg".tr()}$minLimit");
              }
              else if(NumberFormatter.stringToDouble(cashOutAmount.text) > NumberFormatter.stringToDouble(maxLimit)){
                Toasts.showErrorToast("${"max_amount_msg".tr()}$maxLimit");
              }
              else {
                if((NumberFormatter.stringToDouble(currentBalance.toString()) - NumberFormatter.stringToDouble(cashOutAmount.text)).isNegative) {
                  Toasts.showErrorToast("insufficient_fund".tr());
                }
                else {
                  ref.read(transactionFeeControllerProvider.notifier).getTransactionFee(
                      TransactionFeeRequest(
                          userWalletNumber,
                          widget.agentNumber,
                          transactionType,
                          cashOutAmount.text
                      )
                  );
                }
              }
            }
            else {
              Toasts.showErrorToast("enter_amount".tr());
            }
          }
      ),
    );
  }
}