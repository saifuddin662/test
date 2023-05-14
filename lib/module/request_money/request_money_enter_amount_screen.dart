import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/request_money/request_money_confirm_screen.dart';
import 'package:red_cash_dfs_flutter/ui/custom_widgets/custom_safe_next_button.dart';
import 'package:red_cash_dfs_flutter/utils/extensions/extension_two_decimal.dart';
import '../../base/base_consumer_state.dart';
import '../../common/common_api/check_balance/check_balance_controller.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../common/model/summary_details_item.dart';
import '../../common/toasts.dart';
import '../../core/di/core_providers.dart';
import '../../core/di/feature_details_singleton.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_common_enter_amout_widget.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_utils.dart';
import '../../utils/feature_details_keys.dart';
import '../../utils/number_formatter.dart';
import '../../utils/pref_keys.dart';


class RequestMoneyEnterAmountScreen extends ConsumerStatefulWidget {
  final String userName;
  final String walletNumber;


  const RequestMoneyEnterAmountScreen( {
    super.key,
    required this.userName,
    required this.walletNumber,
  });

  @override
  ConsumerState<RequestMoneyEnterAmountScreen> createState() => _RequestMoneyEnterAmountScreenState();
}

class _RequestMoneyEnterAmountScreenState extends BaseConsumerState<RequestMoneyEnterAmountScreen> {
  AnimationController? controller;
  final requestMoneyAmount = TextEditingController();

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
    final currentBalance = ref.read(localPrefProvider).getString(PrefKeys.keyUserBalance);
    final featureIcon = featureDetailsSingleton.feature[FeatureDetailsKeys.requestMoney]?.imageUrl;
    final requesterName = ref.read(localPrefProvider).getString(PrefKeys.keyUserName);

    final minLimit = featureDetailsSingleton.feature[FeatureDetailsKeys.sendMoney]!.minLimit.toString();
    final maxLimit = featureDetailsSingleton.feature[FeatureDetailsKeys.sendMoney]!.maxLimit.toString();

    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'request_money'),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CustomCommonEnterAmountWidget(
          amountList: amountList,
          imageUrl: "$featureIcon",
          username: widget.userName,
          currentBalance: '$currentBalance',
          amountController: requestMoneyAmount,
        ),
      ),
      bottomSheet: SafeNextButtonWidget(
          text: "next".tr(),
          onPressedFunction: () {
            AppUtils.hideKeyboard();
            if(requestMoneyAmount.text.isNotEmpty) {
              if(NumberFormatter.stringToDouble(requestMoneyAmount.text) < NumberFormatter.stringToDouble(minLimit)){
                Toasts.showErrorToast("${"min_amount_msg".tr()}$minLimit");
              }
              else if(NumberFormatter.stringToDouble(requestMoneyAmount.text) > NumberFormatter.stringToDouble(maxLimit)){
                Toasts.showErrorToast("${"max_amount_msg".tr()}$maxLimit");
              }
              else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      RequestMoneyConfirmScreen(
                        confirmDialogModel: CommonConfirmDialogModel(
                            "request_money".tr(),
                            "request_money".tr(),
                            [
                              widget.userName,
                              widget.walletNumber
                            ],
                            [
                              SummaryDetailsItem(
                                  'requested_amount'.tr(),
                                  "৳ ${(NumberFormatter.stringToDouble(requestMoneyAmount.text)).convertTwoDecimal()}"
                              ),
                            ],
                            ApiUrls.makeRequestApi
                        ),
                        requesterName!,
                        widget.userName,
                      )));
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

