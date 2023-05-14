import 'package:android_sms_retriever/android_sms_retriever.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:red_cash_dfs_flutter/module/ekyc/ekyc_core/ekyc_status_type.dart';
import 'package:red_cash_dfs_flutter/module/ekyc/terms_condition/terms_condition_screen.dart';
import 'package:red_cash_dfs_flutter/module/otp/reg_otp/validate_reg_otp/validate_reg_otp_controller.dart';
import '../../../base/base_consumer_state.dart';
import '../../../common/toasts.dart';
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
import '../../../utils/styles.dart';
import '../../dashboard/red_dashboard_screen.dart';

class RegOtpInputScreen extends ConsumerStatefulWidget {
  const RegOtpInputScreen({Key? key}) : super(key: key);
  static const routeName = '/otpInputScreen';

  @override
  ConsumerState<RegOtpInputScreen> createState() => _RegOtpInputScreenState();
}

class _RegOtpInputScreenState extends BaseConsumerState<RegOtpInputScreen> {
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
                  child: CustomCommonTextWidget(
                  text: "enter_otp".tr(),
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
                padding:  AppDimen.pinCodeTextFieldPaddingLTRB,
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
                      inactiveColor: unselectedFontColor
                  ),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: false,
                  controller: otpTxtController,
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
              // Container(
              //     alignment: Alignment.center,
              //     margin: DimenEdgeInset.marginTop_5,
              //     child: otpTextInput),
               CustomTimerTextWidget(
                text: 'remaining_time'.tr(),
                minutes: 3,
              ),

            ],
          ),
        ),
      ),
      bottomSheet: Container(
          child: confirmOtpButton
      ),
    );
  }

  void nextButtonAction() {
    AppUtils.hideKeyboard();
    ref
        .read(validateRegOtpControllerProvider.notifier)
        .validateRegOtp(otpTxtController.text);
  }

  void initAsyncListener(BuildContext context) {
    final String walletStatus =
        ref.read(globalDataControllerProvider).ekycState.toUpperCase();

    ref.listen<AsyncValue>(
      validateRegOtpControllerProvider,
      (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("OTP Verify Failed : ${currentState.error}"); //to do afia
        } else {
          EasyLoading.dismiss();
          log.info("OTP success");

          if (walletStatus == EkycStatus.NEW.name ||
              walletStatus == EkycStatus.INCOMPLETE.name ||
              walletStatus == EkycStatus.INVALID.name ||
              walletStatus == EkycStatus.FAILED.name) {
            //goto terms page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const TermsConditionScreen()),
            );
          } else if (walletStatus == EkycStatus.ACTIVE.name) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const RedDashboardScreen()), (route) => false
            );
          }
        }
      },
    );
  }

  void initOtpReader() {
    AndroidSmsRetriever.listenForOneTimeConsent().then((value) {
      setState(() {
        try {
          final intRegex = RegExp(r'\d+', multiLine: true);
          final code = intRegex.allMatches(value ?? '').first.group(0);
          _otpCode = code ?? '';
          otpTxtController.text = _otpCode;
        } on Exception catch (e) {
         log.info('set otp failed ${e.toString()}');
        }
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
