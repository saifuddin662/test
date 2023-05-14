import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:red_cash_dfs_flutter/utils/extensions/extension_two_decimal.dart';
import '../../base/base_consumer_state.dart';
import '../../common/common_api/check_balance/check_balance_controller.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../common/model/summary_details_item.dart';
import '../../common/toasts.dart';
import '../../core/di/core_providers.dart';
import '../../core/di/feature_details_singleton.dart';
import '../../ui/configs/branding_data_controller.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_common_enter_amout_widget.dart';
import '../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../utils/Colors.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_encoder_decoder_utility.dart';
import '../../utils/app_utils.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/feature_details_keys.dart';
import '../../utils/number_formatter.dart';
import '../../utils/pref_keys.dart';
import '../../utils/styles.dart';
import '../send_money/send_money_success_screen.dart';
import 'api/model/top_up_agent_request.dart';
import 'api/top_up_agent_controller.dart';

class TopUpAgentEnterAmountScreen extends ConsumerStatefulWidget {
  final String userName;
  final String walletNumber;

  const TopUpAgentEnterAmountScreen({
    super.key,
    required this.userName,
    required this.walletNumber
  });

  @override
  ConsumerState<TopUpAgentEnterAmountScreen> createState() => _TopUpAgentEnterAmountScreenState();
}

class _TopUpAgentEnterAmountScreenState extends BaseConsumerState<TopUpAgentEnterAmountScreen> {

  AnimationController? controller;
  final pinController = TextEditingController();
  final topUpAgentAmount = TextEditingController();

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
    final featureIcon = featureDetailsSingleton.feature[FeatureDetailsKeys.dsrTopUpAgent]?.imageUrl;

    ref.listen<AsyncValue>(
      topUpAgentControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();
          Toasts.showSuccessToast("send_money_success_msg".tr());
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) => SendMoneySuccessScreen(
                confirmDialogModel: CommonConfirmDialogModel(
                    "top_up_agent".tr(),
                    "top_up_agent".tr(),
                    [
                      widget.userName,
                      widget.walletNumber
                    ],
                    [
                      SummaryDetailsItem(
                          "transaction_amount".tr(),
                          "৳ ${(NumberFormatter.stringToDouble(topUpAgentAmount.text)).convertTwoDecimal()}"
                      ),
                      SummaryDetailsItem(
                          "new_balance".tr(),
                          "৳ ${(NumberFormatter.stringToDouble(currentBalance.toString())
                              - NumberFormatter.stringToDouble(topUpAgentAmount.text))}"
                      ),
                    ],
                    ApiUrls.topUpAgentApi
                ),
                apiMessage: currentState.value?.message,
              )
          ), (route) => false);
        }
      },
    );

    return Scaffold(
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'top_up_agent'),
      body: SingleChildScrollView(
        child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Column(
              children: [
                CustomCommonEnterAmountWidget(
                  amountList: amountList,
                  imageUrl: "$featureIcon",
                  username: widget.userName,
                  currentBalance: '$currentBalance',
                  amountController: topUpAgentAmount,
                ),
                Padding(
                  padding: AppDimen.commonLeftRightPadding,
                  child: CustomCommonTextWidget(
                      text: "enter_pin".tr(),
                      style: CommonTextStyle.regular_16,
                      color: colorPrimaryText,
                      shouldShowMultipleLine : true
                  ),
                ),
                Container(
                  padding:  DimenEdgeInset.marginLTRB_confirmPin,
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    length: 4,
                    obscureText: true,
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderWidth: 1,
                      borderRadius: AppDimen.commonCircularBorderRadius,
                      fieldHeight: AppDimen.pinCodeTextFieldHeightWidth,
                      fieldWidth: AppDimen.pinCodeTextFieldHeightWidth,
                      activeFillColor: Colors.white,
                      activeColor: BrandingDataController.instance.branding.colors.primaryColor,
                      inactiveColor: unselectedFontColor,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: false,
                    controller: pinController,
                    scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 100
                    ),
                    keyboardType: TextInputType.number,
                    onCompleted: (v) {
                    },
                    onTap: () {
                    },
                    onChanged: (value) {
                    },
                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      return true;
                    },
                  ),
                ),
                const SizedBox(height: DimenSizes.dimen_100),
              ],
            )
        ),
      ),
      bottomSheet: SafeNextButtonWidget(
          text: "next".tr(),
          onPressedFunction: () {
            AppUtils.hideKeyboard();
            if(topUpAgentAmount.text.isNotEmpty) {
              AppUtils.hideKeyboard();
              if(pinController.text.isNotEmpty) {
                if(pinController.text.length == 4) {
                  AppUtils.hideKeyboard();
                  TopUpAgentRequest topUpAgentRequest = TopUpAgentRequest(
                      toAc: widget.walletNumber,
                      amount: NumberFormatter.parseOnlyDouble(topUpAgentAmount.text).toString(),
                      pin: AppEncoderDecoderUtility().base64Encoder(pinController.text),
                      txnType: featureDetailsSingleton.feature[FeatureDetailsKeys.dsrTopUpAgent]!.transactionType.toString()
                  );
                  ref.read(topUpAgentControllerProvider.notifier).topUpAgent(topUpAgentRequest);
                }
                else {
                  Toasts.showErrorToast("enter_correct_pin".tr());
                }
              }
              else {
                Toasts.showErrorToast("enter_pin_msg".tr());
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