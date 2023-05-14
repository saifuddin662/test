import 'package:android_sms_retriever/android_sms_retriever.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../base/base_consumer_state.dart';
import '../../../common/toasts.dart';
import '../../../core/di/core_providers.dart';
import '../../../core/di/singleton_provider.dart';
import '../../../ui/configs/branding_data_controller.dart';
import '../../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../ui/custom_widgets/custom_otp_resend_timer_button.dart';
import '../../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../../ui/custom_widgets/custom_timer_text_widget.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimens/app_dimens.dart';
import '../../../utils/dimens/dimensions.dart';
import '../../../utils/pref_keys.dart';
import '../../../utils/styles.dart';
import '../../dashboard/red_dashboard_screen.dart';
import '../../ekyc/ekyc_core/ekyc_status_type.dart';
import '../../ekyc/terms_condition/terms_condition_screen.dart';
import 'check_otp_input_controller.dart';

class CheckOtpInputScreen extends ConsumerStatefulWidget {
  const CheckOtpInputScreen({Key? key}) : super(key: key);
  static const routeName = '/otpInputScreen';

  @override
  ConsumerState<CheckOtpInputScreen> createState() =>
      _CheckOtpInputScreenState();
}

class _CheckOtpInputScreenState extends BaseConsumerState<CheckOtpInputScreen> {
  final otpTxtController = TextEditingController();
  final otpResendController = OtpTimerButtonController();

  String _otpCode = "";
  bool isNextButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    initOtpReader();
    initNextButtonListener();
  }

  @override
  Widget build(BuildContext context) {
    initAsyncListener(context);

    final confirmOtpButton = SafeNextButtonWidget(
        text: "confirm".tr(),
        onPressedFunction:
            isNextButtonEnabled ? () => nextButtonAction() : null);

    return Scaffold(
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'verify_otp'),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: AppDimen.appMarginHorizontal  , right:  AppDimen.appMarginHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: AppDimen.toolbarBottomGap),
              Container(
                  alignment: Alignment.centerLeft,
                  child:  CustomCommonTextWidget(
                  text:  "enter_otp".tr(),
                  style: CommonTextStyle.regular_14,
                  color: colorPrimaryText,
                  textAlign :  TextAlign.center,
                  shouldShowMultipleLine : true
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
                padding: DimenEdgeInset.marginTB_4_20,
                child: CustomCommonTextWidget(
                  text: "otp_title".tr(),
                  style: CommonTextStyle.regular_12,
                  color: greyColor,
                  textAlign :  TextAlign.left,
                  shouldShowMultipleLine : true
              ),
              ),

              Padding(
                padding: AppDimen.pinCodeTextFieldPaddingLTRB,
                child: PinCodeTextField(
                  appContext: context,
                  pastedTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  length: 6,
                  obscureText: false,
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderWidth: AppDimen.pinCodeTextFieldBorderWidth,
                      borderRadius: AppDimen.commonCircularBorderRadius,
                      fieldHeight: AppDimen.otpPinCodeTextFieldHW,
                      fieldWidth: AppDimen.otpPinCodeTextFieldHW,
                      activeFillColor: Colors.white,
                      activeColor: BrandingDataController.instance.branding.colors.primaryColor,
                      inactiveColor: unselectedFontColor),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: false,
                  controller: otpTxtController,
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 100),
                  keyboardType: TextInputType.number,
                  onCompleted: (v) {},
                  onTap: () {},
                  onChanged: (value) {},
                ),
              ),
              CustomTimerTextWidget(
                text: 'remaining_time'.tr(),
                minutes: 3,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(child: confirmOtpButton),
    );
  }

  void nextButtonAction() {
    AppUtils.hideKeyboard();
    ref
        .read(checkOtpInputControllerProvider.notifier)
        .validateCheckOtp(otpTxtController.text);
  }

  void initAsyncListener(BuildContext context) {
    final String ekycState = ref.read(globalDataControllerProvider).ekycState;

    ref.listen<AsyncValue>(
      checkOtpInputControllerProvider,
      (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("OTP Verify Failed : ${currentState.error}");
        } else {
          EasyLoading.dismiss();
          log.info("OTP success");


          // changing partial flow to ekyc flow here
          if (ekycState == EkycStatus.PARTIAL.name) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const TermsConditionScreen()),
            );
          } else {
            ref
                .read(localPrefProvider)
                .setBool(PrefKeys.keyIsUserLoggedIn, true);

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const RedDashboardScreen()),
                (route) => false);
          }
        }
      },
    );
  }

  void initOtpReader() {
    AndroidSmsRetriever.listenForOneTimeConsent().then((value) {
      setState(() {
        final intRegex = RegExp(r'\d+', multiLine: true);
        final code = intRegex.allMatches(value ?? '').first.group(0);
        _otpCode = code ?? '';
        otpTxtController.text = _otpCode;
      });
    });
  }

  void initNextButtonListener() {
    otpTxtController.addListener(() {
      setState(() {
        isNextButtonEnabled = otpTxtController.text.length == 6;
      });
    });
  }

  @override
  void dispose() {
    otpTxtController.dispose();
    super.dispose();
  }
}
