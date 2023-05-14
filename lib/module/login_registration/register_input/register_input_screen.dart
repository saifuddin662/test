import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../base/base_consumer_state.dart';
import '../../../common/enum/user_type.dart';
import '../../../common/enums/mobile_operators.dart';
import '../../../common/toasts.dart';
import '../../../core/di/singleton_provider.dart';
import '../../../core/flavor/flavor_provider.dart';
import '../../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../../ui/custom_widgets/custom_common_inputfield_widget.dart';
import '../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimens/app_dimens.dart';
import '../../../utils/dimens/dimensions.dart';
import '../../../utils/styles.dart';
import '../../confirm_pin/confirm_pin_screen.dart';
import '../../ekyc/api/ekyc_status/api/model/ekyc_status_response.dart';
import '../../ekyc/api/ekyc_status/ekyc_status_controller.dart';
import '../../ekyc/ekyc_core/ekyc_status_type.dart';
import '../../ekyc/pending/ekyc_pending_screen.dart';
import '../../otp/reg_otp/reg_otp_input_screen.dart';
import '../../otp/reg_otp/request_reg_otp/reg_otp_input_controller.dart';
import 'api/model/register_request.dart';
import '/../utils/extensions/extension_text_style.dart';

class RegisterInputScreen extends ConsumerStatefulWidget {
  const RegisterInputScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends BaseConsumerState<RegisterInputScreen> {
  final msisdnTextController = TextEditingController();
  final operatorTextController = TextEditingController();

  String? _selectedText;
  bool isNextButtonEnabled = false;

  final List<String> _operators = [
    'Robi',
    'Grameenphone',
    'Banglalink',
    'Airtel',
    'Teletalk'
  ];

  @override
  void initState() {
    super.initState();
    initNextButtonListener();
  }

  @override
  Widget build(BuildContext context) {
    initAsyncListener(context);

    final msisdnField = CustomCommonInputFieldWidget(
      controller: msisdnTextController,
      scrollPadding: const EdgeInsets.all(0.0),
      obscureText: false,
      maxLength: 11,
      keyboardType: TextInputType.phone,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      onChanged: (value) => changeMobileOperator(value),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: AppDimen.commonCircularBorderRadius,
        ),
          labelText: "mobile_number".tr(),
          labelStyle: FontStyle.l_14_regular(color: eclipse),
          hintText: "enter_mobile_number".tr(),
          hintStyle: FontStyle.l_14_regular(color: suvaGray)
      ),
          style: FontStyle.l_16_regular(color: colorPrimaryText),
    );

    final nextButton = SafeNextButtonWidget(
        text: "next".tr(),
        onPressedFunction: isNextButtonEnabled ? () => nextButtonAction(context) : null
    );

    final operatorDropdown = DropdownButtonFormField(
      value: _selectedText,
      items: _dropDownItem(),
      onChanged: (value) {
        _selectedText = value!;
        setState(() {});
      },
      hint: CustomCommonTextWidget(
        text: 'select_operator'.tr(),
        style: CommonTextStyle.regular_14,
        color: suvaGray,
      ),
      decoration: InputDecoration(
        labelStyle: FontStyle.l_14_regular(color: eclipse),
        labelText: 'operator'.tr(),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DimenSizes.dimen_12,
          vertical: DimenSizes.dimen_16,
        ),
      )
      ,
    );

    return Scaffold(
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'reg_or_SignIn'),
      backgroundColor: Colors.white,
      bottomSheet: Container(
          child: nextButton
      ),
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
                  alignment: Alignment.center,
                  child: msisdnField),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: AppDimen.gapBetweenTextField),
                  child: operatorDropdown),
              //const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void initAsyncListener(BuildContext context) {
    ref.listen<AsyncValue>(
      ekycStatusControllerProvider,
      (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast(" ${currentState.error}");
        } else {
          EasyLoading.dismiss();

          final ekycStatus = currentState.value as EkycStatusResponse;
          final walletStatus = ekycStatus.walletStatus?.toUpperCase() ?? "";
          final userType = ref.read(flavorProvider).name;

          if (userType == UserType.CUSTOMER.name) {
            if (walletStatus == EkycStatus.NEW.name ||
                walletStatus == EkycStatus.INCOMPLETE.name ||
                walletStatus == EkycStatus.INVALID.name ||
                walletStatus == EkycStatus.FAILED.name) {
              ref.read(globalDataControllerProvider).phoneNo =
                  msisdnTextController.text;
              ref.read(regOtpInputControllerProvider.notifier).requestRegOtp();
            } else if (walletStatus == EkycStatus.ACTIVE.name) {
              //goto confirm pin screen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConfirmPinScreen()));
            } else if (walletStatus == EkycStatus.PARTIAL.name) {
              //goto partial confirm pin
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConfirmPinScreen()));
            } else if (walletStatus == EkycStatus.SUBMITTED.name ||
                walletStatus == EkycStatus.PENDING.name) {
              //goto ekyc pending screen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EkycPendingScreen()));
            } else if (walletStatus == EkycStatus.WALLET_CREATION_FAILED.name) {
              //show error from server
              Toasts.showErrorToast(ekycStatus.message);
            } else {
              Toasts.showErrorToast("error".tr());
            }
          } else {
            if (walletStatus == EkycStatus.ACTIVE.name) {
              //goto confirm pin screen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConfirmPinScreen()));
            } else {
              Toasts.showErrorToast('$userType User not Found');
            }
          }
        }
      },
    );

    ref.listen<AsyncValue>(
      regOtpInputControllerProvider,
      (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("OTP SEND FAILED : ${currentState.error}");
        } else {
          EasyLoading.dismiss();
          log.info("OTP SEND success");

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const RegOtpInputScreen()));
        }
      },
    );
  }

  void nextButtonAction(BuildContext context) {
    log.info("Next CLicked");

    AppUtils.hideKeyboard();

    //RegisterRequest registerRequest = RegisterRequest(msisdnTextController.text, ref.read(flavorProvider).name);
    RegisterRequest registerRequest = RegisterRequest(msisdnTextController.text, 'CUSTOMER'); // todo shaj userType XXX must change this to flavor

    ref.read(globalDataControllerProvider).mno = _selectedText!;

    ref.read(ekycStatusControllerProvider.notifier).getEkycStatus(registerRequest);
  }

  changeMobileOperator(String value) {
    if (value.startsWith('013') || value.startsWith('017')) {
      setState(() {
        _selectedText = MobileOperators.GP.name;
      });
    } else if (value.startsWith('018')) {
      setState(() {
        _selectedText = MobileOperators.ROBI.name;
      });
    } else if (value.startsWith('016')) {
      setState(() {
        _selectedText = MobileOperators.Airtel.name;
      });
    } else if (value.startsWith('019') || value.startsWith('014')) {
      setState(() {
        _selectedText = MobileOperators.BL.name;
      });
    } else if (value.startsWith('015')) {
      setState(() {
        _selectedText = MobileOperators.Teletalk.name;
      });
    } else {
      setState(() {
        _selectedText = null;
      });
    }
  }

  bool isPhoneNoValid(String? phoneNo) {
    if (phoneNo == null || phoneNo.isEmpty) return false;
    final regExp = RegExp("(?:\\+88|88)?(01[3-9]\\d{8})");
    return regExp.hasMatch(phoneNo);
  }

  List<DropdownMenuItem<String>> _dropDownItem() {
    return _operators
        .map((value) => DropdownMenuItem(
              value: value,
              child: Center(
                child: CustomCommonTextWidget(
                  text: value,
                  style: CommonTextStyle.regular_16,
                  color: colorPrimaryText,
                ),
              ),
            ))
        .toList();
  }

  void initNextButtonListener() {
    msisdnTextController.addListener(() {
      setState(() {
        isNextButtonEnabled = isPhoneNoValid(msisdnTextController.text);
      });
    });
  }

  @override
  void dispose() {
    msisdnTextController.dispose();
    operatorTextController.dispose();
    super.dispose();
  }
}
