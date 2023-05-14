import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../common/toasts.dart';
import '../../ui/custom_widgets/custom_common_pin_widget.dart';
import '../../utils/app_encoder_decoder_utility.dart';
import '../../utils/app_utils.dart';
import '../../utils/number_formatter.dart';
import 'agent_cash_out_success_screen.dart';
import 'api/agent_cash_out_controller.dart';
import 'api/model/agent_cash_out_request.dart';

class AgentCashOutPinScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;

  const AgentCashOutPinScreen({
    Key? key,
    required this.confirmDialogModel,
  }) : super(key: key);

  @override
  ConsumerState<AgentCashOutPinScreen> createState() => _AgentCashOutPinScreenState();
}

class _AgentCashOutPinScreenState extends BaseConsumerState<AgentCashOutPinScreen> {
  final pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      agentCashOutControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();
          Toasts.showSuccessToast("cash_out_success_msg".tr());
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AgentCashOutSuccessScreen(
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
              AgentCashOutRequest agentCashOutRequest = AgentCashOutRequest(
                  recipientNumber: widget.confirmDialogModel.recipientSummary[1],
                  amount: NumberFormatter.parseOnlyDouble(widget.confirmDialogModel.transactionSummary[0].description).toString(),
                  pin: AppEncoderDecoderUtility().base64Encoder(pinController.text)
              );
              ref.read(agentCashOutControllerProvider.notifier).agentCashOut(agentCashOutRequest);
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