import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';

import '../../base/base_consumer_state.dart';
import '../../common/toasts.dart';
import '../../core/di/core_providers.dart';
import '../../core/di/feature_details_singleton.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_common_enter_amout_widget.dart';
import '../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../utils/app_utils.dart';
import '../../utils/feature_details_keys.dart';
import '../../utils/pref_keys.dart';
import '../dashboard/dashboard_screen.dart';
import 'api/add_money_controller.dart';
import 'api/model/get_transaction_id_request.dart';
import 'api/model/get_transaction_id_response.dart';

/// Created by Md. Awon-Uz-Zaman on 25/February/2023

class AddMoneyAmountScreen extends ConsumerStatefulWidget {
  final String type;
  final String featureIcon;

  const AddMoneyAmountScreen({
    super.key,
    required this.type,
    required this.featureIcon
  });

  @override
  ConsumerState<AddMoneyAmountScreen> createState() =>
      _AddMoneyAmountScreenState();
}

class _AddMoneyAmountScreenState extends BaseConsumerState<AddMoneyAmountScreen> {
  var addMoneyAmountController = TextEditingController();
  late double amount;

  @override
  Widget build(BuildContext context) {
    var amountList = [50, 100, 200, 500, 1000, 2000];
    FeatureDetailsSingleton featureDetailsSingleton = FeatureDetailsSingleton();

    final userName = ref.read(localPrefProvider).getString(PrefKeys.keyUserName)!;
    final currentBalance = ref.read(localPrefProvider).getString(PrefKeys.keyUserBalance);

    final featureTitle = featureDetailsSingleton.feature[FeatureDetailsKeys.addMoney]?.featureTitle;

    ref.listen<AsyncValue>(
      addMoneyControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();
          // Toasts.showSuccessToast("mobile_recharge_success_msg".tr());

          final data = ref.watch(addMoneyControllerProvider);
          sslCommerzGeneralCall(data.value!, widget.type);
        }
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomCommonAppBarWidget(appBarTitle: featureTitle ?? ""),
      body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: CustomCommonEnterAmountWidget(
            amountList: amountList,
            imageUrl: widget.featureIcon,
            networkSvgImage: false,
            username: userName,
            currentBalance: '$currentBalance',
            amountController: addMoneyAmountController,
          ),
        ),
      bottomSheet: SafeNextButtonWidget(
          text: "next".tr(),
          onPressedFunction: () {
            AppUtils.hideKeyboard();
            if(addMoneyAmountController.text.isNotEmpty) {
              AppUtils.hideKeyboard();
              ref.read(addMoneyControllerProvider.notifier).getAddMoneyInfo(GetTransactionRequest(amount: double.parse(addMoneyAmountController.text)));
            } else {
              Toasts.showErrorToast("enter_amount".tr());
            }
          }
      ),
    );
  }

  Future<void> sslCommerzGeneralCall(GetTransactionIdResponse transactionIdResponse, String type) async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        //Use the ipn if you have valid one, or it will fail the transaction.
        ipn_url: transactionIdResponse.ipnUrl,
        multi_card_name: type,
        currency: SSLCurrencyType.BDT,
        product_category: "MFS",
        sdkType:  SSLCSdkType.TESTBOX /*: SSLCSdkType.LIVE*/,
        store_id: transactionIdResponse.storeId!,
        store_passwd: transactionIdResponse.storePassword!,
        total_amount: transactionIdResponse.amount!,
        tran_id: transactionIdResponse.tranId!,
      ),
    );
    try {
      SSLCTransactionInfoModel result = await sslcommerz.payNow();

      if (result.status!.toLowerCase() == "failed") {
        print("Transaction is Failed....");
        Toasts.showErrorToast("Transaction is Failed....");
      } else if (result.status!.toLowerCase() == "closed") {
        print("SDK Closed by User");
        // Toasts.showErrorToast("SDK Closed by User");
      } else {
        print("Transaction is ${result.status} and Amount is ${result.amount}");
        Toasts.showSuccessToast("Transaction is ${result.status} and Amount is ${result.amount}");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => const DashboardScreen()
        ), (route) => false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
