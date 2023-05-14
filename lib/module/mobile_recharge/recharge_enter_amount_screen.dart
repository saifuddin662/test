import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/utils/extensions/extension_two_decimal.dart';
import '../../base/base_consumer_state.dart';
import '../../common/common_api/check_balance/check_balance_controller.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../common/model/common_list_bottom_sheet_model.dart';
import '../../common/model/summary_details_item.dart';
import '../../common/toasts.dart';
import '../../core/di/core_providers.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_common_feature_top_item_widget.dart';
import '../../ui/custom_widgets/custom_common_inputfield_widget.dart';
import '../../utils/Colors.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_utils.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/number_formatter.dart';
import '../../utils/pref_keys.dart';
import 'mobile_recharge_confirm_screen.dart';


class RechargeEnterAmountScreen extends ConsumerStatefulWidget {

  final CommonListBottomSheetModel simType;
  final String number;
  final String name;
  final CommonListBottomSheetModel operator;

  const RechargeEnterAmountScreen({super.key,
    required this.simType,
    required this.number,
    required this.operator,
    required this.name
  });

  @override
  ConsumerState<RechargeEnterAmountScreen> createState() => _RechargeAmountState();
}

class _RechargeAmountState extends BaseConsumerState<RechargeEnterAmountScreen> {
  var controller = TextEditingController();
  bool isSwitched = false;
  final apiUrl = "top_up";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(checkBalanceControllerProvider.notifier).checkBalance();
    });
  }


  @override
  Widget build(BuildContext context) {
    final amountController = TextEditingController();
    final userWalletNumber = ref.read(localPrefProvider).getString(PrefKeys.keyMsisdn)!;
    final currentBalance = ref.read(localPrefProvider).getString(PrefKeys.keyUserBalance);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset : false,
      appBar: const CustomCommonAppBarWidget(appBarTitle: "mobile_recharge"),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          padding: const EdgeInsets.all(AppDimen.appMarginHorizontal),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomCommonFeatureTopItemWidget(
                networkSvgImage: true,
                iconUrl: widget.operator.icon!,
                title: widget.name,
              ),
              Card(
                  color: Colors.white,
                  elevation: 1,
                  child:
                  Column(
                      children: [
                        const SizedBox(height: DimenSizes.dimen_10),
                        Row(
                          children: [
                            Expanded(
                                child: CustomCommonInputFieldWidget(
                                    obscureText: false,
                                    scrollPadding: const EdgeInsets.all(0.0),
                                    controller: amountController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                    ],
                                    cursorColor: Colors.transparent,
                                    textAlign: TextAlign.left,
                                    decoration: InputDecoration(
                                        labelText: "enter_amount".tr(),
                                        suffixIcon: IconButton(
                                          onPressed: (){
                                            AppUtils.hideKeyboard();
                                            _check(amountController.text, currentBalance, userWalletNumber);
                                          },
                                          icon: const Icon(Icons.arrow_forward),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: AppDimen.commonCircularBorderRadius,
                                          borderSide:  BorderSide(color: greyColor, width: DimenSizes.dimen_2),
                                        )
                                    )
                                )
                            ),
                          ],
                        )
                      ])
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _check(amount, currentBalance, userWalletNumber){
    if(amount.isNotEmpty) {
      if(int.parse(amount) < 20){
        Toasts.showErrorToast("min_amount_msg_twenty".tr());
      }
      else {
        if((double.parse(currentBalance.toString()) - double.parse(amount)).isNegative) {
          Toasts.showErrorToast("insufficient_fund".tr());
        }
        else {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              MobileRechargeConfirmScreen(
                confirmDialogModel: CommonConfirmDialogModel(
                    "mobile_recharge".tr(),
                    "mobile_recharge".tr(),
                    [
                      widget.name,
                      widget.number
                    ],
                    [
                      SummaryDetailsItem(
                          "amount".tr(),
                          "৳ ${NumberFormatter.stringToDouble(amount)}"
                      ),
                      SummaryDetailsItem(
                          "new_balance".tr(),
                          "৳ ${(NumberFormatter.stringToDouble(currentBalance.toString()) - NumberFormatter.stringToDouble(amount)).convertTwoDecimal()}"
                      ),
                      SummaryDetailsItem(
                          "charge".tr(),
                          "৳ ${NumberFormatter.stringToDouble("0")}"
                      ),
                      SummaryDetailsItem(
                          "total".tr(),
                          "৳ ${NumberFormatter.stringToDouble(amount)}"
                      ),
                    ],
                    ApiUrls.mobileRechargeApi
                ),
                connectionType: widget.simType.name!,
                operator: widget.operator.name!,
              ))
          );
        }
      }
    }
    else {
      Toasts.showErrorToast("enter_amount".tr());
    }
  }

}