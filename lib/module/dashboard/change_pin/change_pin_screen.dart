import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../base/base_consumer_state.dart';
import '../../../common/toasts.dart';
import '../../../core/di/core_providers.dart';
import '../../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../../ui/custom_widgets/custom_common_inputfield_widget.dart';
import '../../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../../utils/app_encoder_decoder_utility.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/dimens/app_dimens.dart';
import '../../../utils/dimens/dimensions.dart';
import '../../../utils/pref_keys.dart';
import '../../login_registration/login/login_screen.dart';
import 'api/change_pin_controller.dart';
import 'api/model/change_pin_request.dart';

class ChangePinScreen extends ConsumerStatefulWidget {
  const ChangePinScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends BaseConsumerState<ChangePinScreen> {

  final _formKey = GlobalKey<FormState>();
  final _oldPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmNewPinController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      changePinControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();
          Toasts.showSuccessToast("change_pin_success_msg".tr());
          ref.read(localPrefProvider).setString(PrefKeys.keyJwt, "");
          Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      },
    );

    return Scaffold(
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'change_pin'),
      body: Container(
          padding: const EdgeInsets.only(top: AppDimen.toolbarBottomGap),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  padding: AppDimen.commonLeftRightPadding,
                  child: Column(
                    children: [
                      getPinField(
                          "change_pin_enter_old_pin".tr(),
                          _oldPinController
                      ),
                      const SizedBox(height: DimenSizes.dimen_20),
                      getPinField(
                          "enter_new_pin".tr(),
                          _newPinController
                      ),
                      const SizedBox(height: DimenSizes.dimen_20),
                      getPinField(
                          "confirm_new_pin".tr(),
                          _confirmNewPinController
                      ),
                      const SizedBox(height: DimenSizes.dimen_20),
                    ],
                  ),
                )
              ],
            )
          )),
      bottomSheet: SafeNextButtonWidget(
          text: "confirm".tr(),
          onPressedFunction: () {
            AppUtils.hideKeyboard();
            if(_formKey.currentState!.validate()) {
              if(_newPinController.text != _confirmNewPinController.text) {
                Toasts.showErrorToast("change_pin_match_message".tr());
              }
              else {
                ChangePinRequest changePinRequest = ChangePinRequest(
                  oldPin: AppEncoderDecoderUtility().base64Encoder(_oldPinController.text),
                  newPin: AppEncoderDecoderUtility().base64Encoder(_newPinController.text),
                );
                ref.read(changePinControllerProvider.notifier).changePin(changePinRequest);
              }
            }
          }
      ),
    );
  }

  Widget getPinField(String labelText, TextEditingController controller) {
    return CustomCommonInputFieldWidget(
      controller: controller,
      obscureText: true,
      scrollPadding: const EdgeInsets.all(0.0),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
      keyboardType: TextInputType.number,
      maxLength: 4,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "required_field".tr();
        } else if (value.length < 4) {
          return "enter_4Digit".tr();
        }
        return null;
      },
    );
  }


  @override
  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    _confirmNewPinController.dispose();
    super.dispose();
  }
}

