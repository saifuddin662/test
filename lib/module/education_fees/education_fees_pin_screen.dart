import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../common/toasts.dart';
import '../../core/di/core_providers.dart';
import '../../core/flavor/flavor_provider.dart';
import '../../ui/custom_widgets/custom_common_error_widget.dart';
import '../../ui/custom_widgets/custom_common_pin_widget.dart';
import '../../utils/app_encoder_decoder_utility.dart';
import '../../utils/app_utils.dart';
import '../../utils/pref_keys.dart';
import 'api/education_fees_controller.dart';
import 'api/model/EducationFeesRequest.dart';
import 'education_fees_success_screen.dart';


/// Created by Md. Awon-Uz-Zaman on 02/February/2023


class EducationFeesPinScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;
  final SchoolPaymentInfo schoolInfo;

  const EducationFeesPinScreen({
    Key? key,
    required this.confirmDialogModel,
    required this.schoolInfo,
  }) : super(key: key);

  @override
  ConsumerState<EducationFeesPinScreen> createState() => _EducationFeesPinScreenState();
}

class _EducationFeesPinScreenState extends BaseConsumerState<EducationFeesPinScreen> {
  final pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userWalletNumber = ref.read(localPrefProvider).getString(PrefKeys.keyMsisdn)!;

    ref.listen<AsyncValue>(
      educationFeesControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          //Toasts.showErrorToast("${currentState.error}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomCommonErrorWidget(
                errorMessage: '${currentState.error}',
              ),
            ),
          );
        } else {
          EasyLoading.dismiss();
          Toasts.showSuccessToast("education_fees_success_msg".tr());
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => EducationFeesSuccessScreen(
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
      body: CustomConfirmPinWidget(
        confirmDialogModel: widget.confirmDialogModel,
        pinController: pinController,
        onPressed: () {
          AppUtils.hideKeyboard();
          if(pinController.text.isNotEmpty) {
            if(pinController.text.length == 4) {
              EducationFeesRequest educationFeesRequest = EducationFeesRequest(
                  fromAc: userWalletNumber,
                  pin: AppEncoderDecoderUtility().base64Encoder(pinController.text),
                  schoolPaymentInfo: widget.schoolInfo,
                  toAc: widget.confirmDialogModel.recipientSummary[1],
                  userType: ref.read(flavorProvider).name
              );

              AppUtils.hideKeyboard();
              ref.read(educationFeesControllerProvider.notifier).educationFeePayment(educationFeesRequest);
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