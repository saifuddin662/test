import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/request_money/api/pay_request_money/pay_request_money_controller.dart';
import 'package:red_cash_dfs_flutter/module/request_money/api/pay_request_money/pay_request_money_success_screen.dart';
import '../../../../base/base_consumer_state.dart';
import '../../../../common/model/common_confirm_dialog_model.dart';
import '../../../../common/toasts.dart';
import '../../../../ui/custom_widgets/custom_common_pin_widget.dart';
import '../../../../utils/app_encoder_decoder_utility.dart';
import '../../../../utils/app_utils.dart';
import 'model/pay_request_money_request.dart';


class PayRequestMoneyPinScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;
  final String requestId;
  final String transactionType;


  const PayRequestMoneyPinScreen(this.requestId, this.transactionType,{
    Key? key,
    required this.confirmDialogModel,
  }) : super(key: key);

  @override
  ConsumerState<PayRequestMoneyPinScreen> createState() => _PayRequestMoneyPinScreenState();
}

class _PayRequestMoneyPinScreenState extends BaseConsumerState<PayRequestMoneyPinScreen> {
  final pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      payRequestMoneyControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();
          log.info("got pay money response");
          Toasts.showSuccessToast("send_money_success_msg".tr());
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => PayRequestMoneySuccessScreen(
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
              AppUtils.hideKeyboard();
              PayRequestMoneyRequest  payRequestMoneyRequest  = PayRequestMoneyRequest (
                  requestId: widget.requestId,
                  transactionType: widget.transactionType,
                  pin: AppEncoderDecoderUtility().base64Encoder(pinController.text)
              );
              ref.read(payRequestMoneyControllerProvider.notifier).payMoney(payRequestMoneyRequest);
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