import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../common/toasts.dart';
import '../../core/di/feature_details_singleton.dart';
import '../../ui/custom_widgets/custom_common_pin_widget.dart';
import '../../utils/app_encoder_decoder_utility.dart';
import '../../utils/app_utils.dart';
import '../../utils/feature_details_keys.dart';
import '../../utils/number_formatter.dart';
import 'api/merchant_pay_controller.dart';
import 'api/model/merchant_pay_request.dart';
import 'merchant_pay_success_screen.dart';


class MerchantPayPinScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;

  const MerchantPayPinScreen({
    Key? key,
    required this.confirmDialogModel,
  }) : super(key: key);

  @override
  ConsumerState<MerchantPayPinScreen> createState() => _MerchantPayPinScreenState();
}

class _MerchantPayPinScreenState extends BaseConsumerState<MerchantPayPinScreen> {

  FeatureDetailsSingleton featureCodeSingleton = FeatureDetailsSingleton();
  final pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      merchantPayControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();
          Toasts.showSuccessToast("merchant_payment_success_msg".tr() );
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MerchantPaySuccessScreen(
                confirmDialogModel: CommonConfirmDialogModel(
                    widget.confirmDialogModel.appBarTitle,
                    widget.confirmDialogModel.transactionTitle,
                    widget.confirmDialogModel.recipientSummary,
                    widget.confirmDialogModel.transactionSummary,
                    widget.confirmDialogModel.apiUrl
                ),
                apiMessage: currentState.value?.message,
              )));
        }
      },
    );

    return Scaffold(
      body: CustomConfirmPinWidget(
        confirmDialogModel: widget.confirmDialogModel,
        pinController: pinController,
        onPressed: () {
          AppUtils.hideKeyboard();
          if(pinController.text.isNotEmpty) {
            if(pinController.text.length == 4) {
              MerchantPayRequest merchantPayRequest = MerchantPayRequest(
                  recipientNumber: widget.confirmDialogModel.recipientSummary[1],
                  amount: NumberFormatter.parseOnlyDouble(widget.confirmDialogModel.transactionSummary[0].description).toString(),
                  txnType: featureCodeSingleton.feature[FeatureDetailsKeys.merchantPayment]?.transactionType,
                  pin: AppEncoderDecoderUtility().base64Encoder(pinController.text)
              );
              ref.read(merchantPayControllerProvider.notifier).merchantPay(merchantPayRequest);
            }
            else {
              Toasts.showErrorToast("enter_correct_pin".tr());
            }
          }
          else {
            Toasts.showErrorToast("enter_pin".tr());
          }
        },
      ),
    );
  }
}