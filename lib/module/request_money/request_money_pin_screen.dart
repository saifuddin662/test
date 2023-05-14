import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/request_money/request_money_success_screen.dart';
import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../common/toasts.dart';
import '../../ui/custom_widgets/custom_common_pin_widget.dart';
import '../../utils/app_encoder_decoder_utility.dart';
import '../../utils/app_utils.dart';
import '../../utils/number_formatter.dart';
import 'api/make_request_money/make_request_money_controller.dart';
import 'api/make_request_money/model/make_request_money_request.dart';

class RequestMoneyPinScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;
  final String requesterName;
  final String receiverName;


  const RequestMoneyPinScreen( this.requesterName, this.receiverName,{
    Key? key,
    required this.confirmDialogModel,
  }) : super(key: key);

  @override
  ConsumerState<RequestMoneyPinScreen> createState() => _RequestMoneyPinScreenState();
}

class _RequestMoneyPinScreenState extends BaseConsumerState<RequestMoneyPinScreen> {
  final pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      makeRequestMoneyControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();
          Toasts.showSuccessToast("request_successful".tr());
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => RequestMoneySuccessScreen(
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
              MakeRequestMoneyRequest makeRequestMoneyRequest = MakeRequestMoneyRequest(
                  pin: AppEncoderDecoderUtility().base64Encoder(pinController.text),
                  requestedAmount: NumberFormatter.parseOnlyDouble(widget.confirmDialogModel.transactionSummary[0].description).toString(),
                  requestTo: widget.confirmDialogModel.recipientSummary[1],
                  requesterName: widget.requesterName,
                  receiverName: widget.receiverName
              );
              ref.read(makeRequestMoneyControllerProvider.notifier).requestMoney(makeRequestMoneyRequest);
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