import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/send_money/send_money_confirm_screen.dart';
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

class SendMoneyEnterAmountScreen extends ConsumerStatefulWidget {
  final String userName;
  final String walletNumber;

  const SendMoneyEnterAmountScreen({
    super.key,
    required this.userName,
    required this.walletNumber
  });

  @override
  ConsumerState<SendMoneyEnterAmountScreen> createState() => _SendMoneyEnterAmountScreenState();
}

class _SendMoneyEnterAmountScreenState extends BaseConsumerState<SendMoneyEnterAmountScreen> {
  AnimationController? controller;
  final sendMoneyAmount = TextEditingController();

  var amountList = [50, 100, 200, 500, 1000, 2000];
  FeatureDetailsSingleton featureDetailsSingleton = FeatureDetailsSingleton();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(checkBalanceControllerProvider.notifier).checkBalance();
    });
  }


  @override
  Widget build(BuildContext context) {
    final userWalletNumber = ref.read(localPrefProvider).getString(PrefKeys.keyMsisdn)!;
    final currentBalance = ref.read(localPrefProvider).getString(PrefKeys.keyUserBalance);

    final minLimit = featureDetailsSingleton.feature[FeatureDetailsKeys.sendMoney]!.minLimit.toString();
    final maxLimit = featureDetailsSingleton.feature[FeatureDetailsKeys.sendMoney]!.maxLimit.toString();
    final featureIcon = featureDetailsSingleton.feature[FeatureDetailsKeys.sendMoney]?.imageUrl;
    final transactionType = featureDetailsSingleton.feature[FeatureDetailsKeys.sendMoney]?.transactionType;

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
              - NumberFormatter.stringToDouble(sendMoneyAmount.text)
              - NumberFormatter.stringToDouble(currentState.value.chargeAmount.toString())).isNegative ?
          Toasts.showErrorToast("insufficient_fund".tr()) :
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              SendMoneyConfirmScreen(
                confirmDialogModel: CommonConfirmDialogModel(
                    "send_money".tr(),
                    "send_money".tr(),
                    [
                      widget.userName,
                      widget.walletNumber
                    ],
                    [
                      SummaryDetailsItem(
                          "transaction_amount".tr(),
                          "৳ ${(NumberFormatter.stringToDouble(sendMoneyAmount.text)).convertTwoDecimal()}"
                      ),
                      SummaryDetailsItem(
                          "new_balance".tr(),
                          "৳ ${(NumberFormatter.stringToDouble(currentBalance.toString())
                              - NumberFormatter.stringToDouble(sendMoneyAmount.text)
                              - NumberFormatter.stringToDouble(currentState.value.chargeAmount.toString())).convertTwoDecimal()}"
                      ),
                      SummaryDetailsItem(
                          "charge".tr(),
                          "৳ ${NumberFormatter.stringToDouble(currentState.value.chargeAmount.toString())}"
                      ),
                      SummaryDetailsItem(
                          "total_amount".tr(),
                          "৳ ${(NumberFormatter.stringToDouble(currentState.value.chargeAmount.toString()) + NumberFormatter.stringToDouble(sendMoneyAmount.text)).convertTwoDecimal()}"
                      )
                    ],
                    ApiUrls.sendMoneyApi
                ),
              )));
        }
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'send_money'),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CustomCommonEnterAmountWidget(
          amountList: amountList,
          imageUrl: "$featureIcon",
          username: widget.userName,
          currentBalance: '$currentBalance',
          amountController: sendMoneyAmount,
        ),
      ),
      bottomSheet: SafeNextButtonWidget(
          text: "next".tr(),
          onPressedFunction: () {
            AppUtils.hideKeyboard();
            if(sendMoneyAmount.text.isNotEmpty) {
              if(NumberFormatter.stringToDouble(sendMoneyAmount.text) < NumberFormatter.stringToDouble(minLimit)){
                Toasts.showErrorToast("${"min_amount_msg".tr()}$minLimit");
              }
              else if(NumberFormatter.stringToDouble(sendMoneyAmount.text) > NumberFormatter.stringToDouble(maxLimit)){
                Toasts.showErrorToast("${"max_amount_msg".tr()}$maxLimit");
              }
              else {
                if((NumberFormatter.stringToDouble(currentBalance.toString()) - NumberFormatter.stringToDouble(sendMoneyAmount.text)).isNegative) {
                  Toasts.showErrorToast("insufficient_fund".tr());
                }
                else {
                  ref.read(transactionFeeControllerProvider.notifier).getTransactionFee(
                      TransactionFeeRequest(
                          userWalletNumber,
                          widget.walletNumber,
                          transactionType,
                          sendMoneyAmount.text
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