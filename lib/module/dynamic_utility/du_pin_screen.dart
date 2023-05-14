import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/dynamic_utility/du_core/api/du_payment/du_payment_controller.dart';
import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../common/toasts.dart';
import '../../ui/custom_widgets/custom_common_pin_widget.dart';
import '../../utils/app_encoder_decoder_utility.dart';
import '../../utils/app_utils.dart';
import '../../utils/number_formatter.dart';
import '../cash_out/api/model/cash_out_request.dart';
import 'du_success_screen.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 16,March,2023.

class DynamicUtilityPinScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;

  const DynamicUtilityPinScreen({
    Key? key,
    required this.confirmDialogModel,
  }) : super(key: key);

  @override
  ConsumerState<DynamicUtilityPinScreen> createState() => _DynamicUtilityPinScreenState();
}

class _DynamicUtilityPinScreenState extends BaseConsumerState<DynamicUtilityPinScreen> {
  final pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      duPaymentControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();
          Toasts.showSuccessToast('utility_payment_successful'.tr());


          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DynamicUtilitySuccessScreen(
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
              ref.read(duPaymentControllerProvider.notifier).utilityPayment(AppEncoderDecoderUtility().base64Encoder(pinController.text));
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