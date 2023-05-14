import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../base/base_consumer_state.dart';
import '../../common/toasts.dart';
import '../../core/di/singleton_provider.dart';
import '../../ui/configs/branding_data_controller.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../utils/app_encoder_decoder_utility.dart';
import '../../utils/app_utils.dart';
import '../../utils/colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/styles.dart';
import '../ekyc/ekyc_core/ekyc_status_type.dart';
import '../otp/check_otp/check_otp_input_screen.dart';
import '../otp/reg_otp/reg_otp_input_screen.dart';
import 'confirm_pin_controller.dart';

class ConfirmPinScreen extends ConsumerStatefulWidget {
  const ConfirmPinScreen({Key? key}) : super(key: key);
  static const routeName = '/confirmPinScreen';

  @override
  ConsumerState<ConfirmPinScreen> createState() => _ConfirmPinScreenState();
}

class _ConfirmPinScreenState extends BaseConsumerState<ConfirmPinScreen> {
  final pinTextController = TextEditingController();
  bool isNextButtonEnabled = false;
  FocusNode pinFocus = FocusNode();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0),(){
      pinFocus.requestFocus();
    });
    super.initState();
    initNextButtonListener();
  }

  @override
  Widget build(BuildContext context) {
    initAsyncListener(context);

    final confirmPinButton = SafeNextButtonWidget(
        text: "confirm".tr(),
        onPressedFunction:
            isNextButtonEnabled ? () => nextButtonAction() : null);

    return Scaffold(
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'confirm_pin'),
      backgroundColor: Colors.white,
      body:  Container(
          color: Colors.white,
          child: SingleChildScrollView(
            padding:  AppDimen.commonLeftRightPadding ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: AppDimen.toolbarBottomGap),
                Container(
                    alignment: Alignment.centerLeft,
                    child: CustomCommonTextWidget(
                          text:  "enter_pin".tr(),
                          style: CommonTextStyle.regular_14,
                          color: colorPrimaryText ,
                ),

      ),

                const Divider(
                  color: Colors.grey,
                  height: DimenSizes.dimen_12,
                  thickness: DimenSizes.dimen_half,
                  indent: DimenSizes.dimen_2,
                  endIndent: DimenSizes.dimen_2,
                ),

                Container(
                  alignment: Alignment.centerLeft,
                  margin: DimenEdgeInset.marginTB_5,
                  child: CustomCommonTextWidget(
                    text: "enter_pin_msg".tr(),
                    style: CommonTextStyle.regular_12,
                    color: suvaGray,
                  ),
                ),
                Padding(
                  padding: DimenEdgeInset.marginLTRB_confirmPin,
                  child: PinCodeTextField(
                    focusNode: pinFocus,
                    appContext: context,
                    pastedTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    length: 4,
                    obscureText: true,
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderWidth: AppDimen.pinCodeTextFieldBorderWidth,
                        borderRadius: AppDimen.commonCircularBorderRadius,
                        fieldHeight: AppDimen.pinCodeTextFieldHeightWidth,
                        fieldWidth: AppDimen.pinCodeTextFieldHeightWidth,
                        activeFillColor: Colors.white,
                        activeColor: BrandingDataController.instance.branding.colors.primaryColor,
                        inactiveColor: unselectedFontColor
                    ),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: false,
                    controller: pinTextController,
                    scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 100
                    ),
                    keyboardType: TextInputType.number,
                    onCompleted: (v) {

                    },
                    onTap: () {

                    },
                    onChanged: (value) {

                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      bottomSheet: Container(
          child: confirmPinButton
      ),
    );
  }

  void nextButtonAction() {
    log.info("pin click");

    AppUtils.hideKeyboard();

    ref.read(confirmPinControllerProvider.notifier).checkDevice(
        AppEncoderDecoderUtility().base64Encoder(pinTextController.text));
  }

  void initAsyncListener(BuildContext context) {
    final String ekycState = ref.read(globalDataControllerProvider).ekycState;

    ref.listen<AsyncValue>(
      confirmPinControllerProvider,
      (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();

          log.info('current ekyc state -------> $ekycState');

          if (ekycState == EkycStatus.PARTIAL.name ||
              ekycState == EkycStatus.ACTIVE.name) {
            // goto user details flow
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const CheckOtpInputScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const RegOtpInputScreen()),
            );
          }
        }
      },
    );
  }

  void initNextButtonListener() {
    pinTextController.addListener(() {
      setState(() {
        isNextButtonEnabled = pinTextController.text.length == 4;
      });
    });
  }
}
