import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../common/toasts.dart';
import '../../ui/custom_widgets/custom_common_pin_widget.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_encoder_decoder_utility.dart';
import '../../utils/app_utils.dart';
import '../../utils/number_formatter.dart';
import 'api/mobile_recharge_controller.dart';
import 'api/model/mobile_recharge_request.dart';
import 'mobile_recharge_success_screen.dart';

class MobileRechargePinScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;
  final String connectionType;
  final String operator;

  const MobileRechargePinScreen({
    Key? key,
    required this.confirmDialogModel,
    required this.connectionType,
    required this.operator,
  }) : super(key: key);

  @override
  ConsumerState<MobileRechargePinScreen> createState() => _MobileRechargePinScreenState();
}

class _MobileRechargePinScreenState extends BaseConsumerState<MobileRechargePinScreen> {
  final pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      mobileRechargeControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();
          Toasts.showSuccessToast("mobile_recharge_success_msg".tr());
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MobileRechargeSuccessScreen(
                confirmDialogModel: CommonConfirmDialogModel(
                    widget.confirmDialogModel.appBarTitle,
                    widget.confirmDialogModel.transactionTitle,
                    widget.confirmDialogModel.recipientSummary,
                    widget.confirmDialogModel.transactionSummary,
                    widget.confirmDialogModel.apiUrl
                ),
                apiMessage: currentState.value?.message,
              )));
          // Navigator.pushReplacement(context,
          //   MaterialPageRoute(builder: (context) => const DashboardScreen()),
          // );
        }
      },
    );

    return Scaffold(
      // resizeToAvoidBottomInset : false,
      // appBar: const CustomCommonAppBarWidget(appBarTitle: 'mobile_recharge'),
      body: CustomConfirmPinWidget(
        confirmDialogModel: widget.confirmDialogModel,
        pinController: pinController,
        onPressed: () {
          AppUtils.hideKeyboard();
          if(pinController.text.isNotEmpty) {
            if(pinController.text.length == 4) {
              MobileRechargeRequest mobileRechargeRequest = MobileRechargeRequest(
                secretKey: ApiUrls.topUpApiSecretKey,
                recipientNumber: widget.confirmDialogModel.recipientSummary[1],
                amount: NumberFormatter.parseOnlyDouble(widget.confirmDialogModel.transactionSummary[0].description).toInt(),
                connectionType: widget.connectionType,
                operator: widget.operator,
                isBundle: false,
                pin: AppEncoderDecoderUtility().base64Encoder(pinController.text),
              );
              AppUtils.hideKeyboard();
              ref.read(mobileRechargeControllerProvider.notifier).mobileRecharge(mobileRechargeRequest);
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