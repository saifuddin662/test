import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../../base/base_consumer_state.dart';
import '../../../common/toasts.dart';
import '../../../core/di/core_providers.dart';
import '../../../ui/configs/branding_data_controller.dart';
import '../../../ui/custom_widgets/custom_common_inputfield_widget.dart';
import '../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../ui/custom_widgets/custom_localization_toggle_widget.dart';
import '../../../ui/custom_widgets/custom_pin_input_widget.dart';
import '../../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../../utils/Colors.dart';
import '../../../utils/app_encoder_decoder_utility.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/device_utils.dart';
import '../../../utils/dimens/app_dimens.dart';
import '../../../utils/dimens/dimensions.dart';
import '../../../utils/pref_keys.dart';
import '../../../utils/styles.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../dashboard/red_dashboard_screen.dart';
import 'api/login_controller.dart';
import 'api/model/login_request.dart';

class LoginScreen extends ConsumerStatefulWidget {

  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseConsumerState<LoginScreen> {

  bool isSwitched = false;
  final msisdnTextController = TextEditingController();
  final pinTextController = TextEditingController();

  String? deviceId;
  bool isNextButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    initNextButtonListener();
    getDeviceId();
  }

  @override
  Widget build(BuildContext context) {

    if (context.locale.languageCode == "en") {
      setState(() {
        isSwitched = false;
      });
    } else {
      setState(() {
        isSwitched = true;
      });
    }

    msisdnTextController.text = ref.read(localPrefProvider).getString(PrefKeys.keyMsisdn)!;

    initAsyncListener(context);

    final msisdnField = CustomCommonInputFieldWidget(
      obscureText: false,
      scrollPadding: const EdgeInsets.all(0.0),
      controller: msisdnTextController,
      enabled: false,
      maxLength: 12,
      style: TextStyle(color: colorPrimaryText, fontSize: 16, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
          labelText: 'wallet_number'.tr(),
          labelStyle: const TextStyle(fontWeight: FontWeight.normal),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppDimen.commonCircularBorderRadius,
            borderSide:  BorderSide(color: BrandingDataController.instance.branding.colors.primaryColor, width: DimenSizes.dimen_half),
          ),
          border: OutlineInputBorder(
            borderRadius: AppDimen.commonCircularBorderRadius,
            borderSide:  BorderSide(color: greyColor, width: DimenSizes.dimen_2),
          )
      ),
    );

    final pinInput = CustomPinInputWidget(
      controller: pinTextController,
      labelText: "enter_pin".tr(),
      obscureText: true,
      maxLength: 4,
    );

    final loginButton = SafeNextButtonWidget(
        text: "login".tr(),
        onPressedFunction:
        isNextButtonEnabled ? () => nextButtonAction() : null);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: AppDimen.commonAllSidePadding20,
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset('assets/svg_files/ic_first_cash_logo_login.svg',
                      height: AppDimen.signInFirstCashLogoHeight,
                      width: AppDimen.signInFirstCashLogoWidth
                  ),
                  CustomLocalizationToggle(
                    textColor: Colors.white,
                    values: const ['English', 'বাংলা'],
                    buttonColor: BrandingDataController.instance.branding.colors.primaryColor,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    // alignment: Alignment.center,
                    child: Column(
                      children: [
                        const SizedBox(height: DimenSizes.dimen_40),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(0),
                          child: CustomCommonTextWidget(
                            text:   "login".tr(),
                            style: CommonTextStyle.bold_24,
                            color: BrandingDataController.instance.branding.colors.primaryColor ,
                          ),

                        ),
                        const SizedBox(height: DimenSizes.dimen_40),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(0),
                            margin: DimenEdgeInset.marginTop_10,
                            child: msisdnField
                        ),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(0),
                            margin: const EdgeInsets.only(bottom: DimenSizes.dimen_60),
                            child: pinInput
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomSheet: loginButton,
    );
  }

  void nextButtonAction() {
    AppUtils.hideKeyboard();
    LoginRequest loginRequest = LoginRequest(
        msisdnTextController.text,
        AppEncoderDecoderUtility().base64Encoder(pinTextController.text),
        deviceId);
    ref.read(loginControllerProvider.notifier).login(loginRequest);
  }

  void initAsyncListener(BuildContext context) {
    ref.listen<AsyncValue>(
      loginControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();
          log.info("login success");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RedDashboardScreen()),
          );
        }
      },
    );
  }

  void initNextButtonListener() {
    pinTextController.addListener(() {
      setState(() {
        if (pinTextController.text.length == 4) {
          //FocusManager.instance.primaryFocus?.unfocus();
          isNextButtonEnabled = true;
        } else {
          isNextButtonEnabled = false;
        }
      });
    });
  }

  getDeviceId() async {
    deviceId = await DeviceUtils().uuid();
  }

  @override
  void dispose() {
    pinTextController.dispose();
    msisdnTextController.dispose();
    super.dispose();
  }
}
