import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../base/base_consumer_state.dart';
import '../../../common/toasts.dart';
import '../../../core/di/core_providers.dart';
import '../../../core/di/singleton_provider.dart';
import '../../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../../utils/Colors.dart';
import '../../../utils/dimens/app_dimens.dart';
import '../../../utils/dimens/dimensions.dart';
import '../../../utils/pref_keys.dart';
import '../../../utils/styles.dart';
import '../../dashboard/dashboard_screen.dart';
import '../api/update_user/model/update_user_response.dart';
import '../api/update_user/update_user_controller.dart';
import '../ekyc_core/cam_direction_provider.dart';
import '../ekyc_core/camera_direction_type.dart';
import '../face_scan/face_screen.dart';
import '/../utils/extensions/extension_text_style.dart';


/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 18,February,2023.


class AdditionalInfoScreen extends ConsumerStatefulWidget {
  const AdditionalInfoScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdditionalInfoScreen> createState() =>
      _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState
    extends BaseConsumerState<AdditionalInfoScreen> {
  final _additionalFormKey = GlobalKey<FormState>();

  String? _selectedTextGender;
  String? _selectedTextBloodGroup;
  String? _selectedTextSourceOfIncome;
  String? _selectedTextOccupation;
  String? _selectedTextMonthlyIncome;

  final List<String> _genders = ['পুরুষ ', 'মহিলা', 'অন্যান্য'];

  final List<String> _bloodGroup = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];

  final List<String> _occupation = [
    'সরকারী চাকরী',
    'বেসরকারী চাকরী',
    'ব্যবসা',
    'আত্নকর্মসংস্থান',
    'শিক্ষার্থী',
    'গৃহিণী',
    'অবসরপ্রাপ্ত',
    'বেকার'
  ];

  final List<String> _sourceOfIncome = [
    'বেতন',
    'ব্যবসায়িক আয়',
    'ব্যক্তিগত আয়',
    'ব্যক্তিগত সঞ্চয়',
    'উত্তরাধিকার সূত্রে প্রাপ্ত',
    'স্বামী/স্ত্রী কর্তৃক প্রদত্ত অর্থ',
    'সম্পত্তি বিক্রয় থেকে প্রাপ্ত',
    'ভাড়া থেকে প্রাপ্ত আয়',
    ' বিনিয়োগের লভ্যাংশ/সমাপ্তি'
  ];

  final List<String> _monthlyIncome = [
    '১,০০০ টাকার নিম্নে',
    '১০০০ টাকা থেকে ৫০০০ টাকা ',
    '৫০০১ টাকা থেকে ১০,০০০ টাকা',
    '১০,০০১ টাকা থেকে ২০,০০০ টাকা',
    '২০,০০১ টাকা থেকে ৫০,০০০ টাকা',
    '৫০,০০১ টাকা থেকে ১,০০,০০০ টাকা',
    '১,০০,০০১ টাকা থেকে ২,০০,০০০ টাকা',
    '২,০০,০০০ টাকা'
  ];

  @override
  Widget build(BuildContext context) {
    initAsyncListener();

    final ekycInfo = ref.read(globalDataControllerProvider).ekycInfos;
    final String ekycState = ref.read(globalDataControllerProvider).ekycState;

    final genderDropdown = DropdownButtonFormField(
      value: _selectedTextGender,
      isExpanded: true,
      style: FontStyle.l_14_regular(),
      items: _genderDropDownItem(),
      decoration:  InputDecoration(
        labelText: 'gender'.tr(),
        labelStyle: FontStyle.l_14_regular(),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DimenSizes.dimen_20,
          vertical: DimenSizes.dimen_16,
        ),
      ),
      onChanged: (value) {
        _selectedTextGender = value!;
        ekycInfo.gender = _selectedTextGender;
        setState(() {});
      },
      validator: (value) {
        if (value == null) {
          return 'gender_required'.tr();
        }
        return null;
      },
    );

    final bloodGrpDropdown = DropdownButtonFormField(
      value: _selectedTextBloodGroup,
      isExpanded: true,
      style: FontStyle.l_14_regular(),
      items: _bloodGroupDropDownItem(),
      decoration:  InputDecoration(
        labelText: 'blood_group'.tr(),
        labelStyle: FontStyle.l_14_regular(),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DimenSizes.dimen_20,
          vertical: DimenSizes.dimen_16,
        ),
      ),
      onChanged: (value) {
        _selectedTextBloodGroup = value!;
        ekycInfo.blood_group = _selectedTextBloodGroup;
        setState(() {});
      },
      validator: (value) {
        if (value == null) {
          return 'blood_grp_required'.tr();
        }
        return null;
      },
    );

    final occupationDropdown = DropdownButtonFormField(
      value: _selectedTextOccupation,
      isExpanded: true,
      style: FontStyle.l_14_regular(),
      items: _occupationDropDownItem(),
      decoration:  InputDecoration(
        labelText: 'occupation'.tr(),
        labelStyle: FontStyle.l_14_regular(),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DimenSizes.dimen_20,
          vertical: DimenSizes.dimen_16,
        ),
      ),
      onChanged: (value) {
        _selectedTextOccupation = value!;
        ekycInfo.profession = _selectedTextOccupation;
        setState(() {});
      },
      validator: (value) {
        if (value == null) {
          return 'profession_required'.tr();
        }
        return null;
      },
    );

    final sourceOfIncomeDropdown = DropdownButtonFormField(
      value: _selectedTextSourceOfIncome,
      isExpanded: true,
      style: FontStyle.l_14_regular(),
      items: _sourceOfIncomeDropDownItem(),
      decoration: InputDecoration(
        labelText: 'source_of_income'.tr(),
        labelStyle: FontStyle.l_14_regular(),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DimenSizes.dimen_20,
          vertical: DimenSizes.dimen_16,
        ),
      ),
      onChanged: (value) {
        _selectedTextSourceOfIncome = value!;
        ekycInfo.source_of_income = _selectedTextSourceOfIncome;
        setState(() {});
      },
      validator: (value) {
        if (value == null) {
          return 'source_of_income_required'.tr();
        }
        return null;
      },
    );

    final monthlyIncomeDropdown = DropdownButtonFormField(
      value: _selectedTextMonthlyIncome,
      isExpanded: true,
      style: FontStyle.l_14_regular(),
      items: _monthlyIncomeDropDownItem(),
      decoration: InputDecoration(
        labelText: 'approx_monthly_income'.tr(),
        labelStyle: FontStyle.l_14_regular(),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DimenSizes.dimen_20,
          vertical: DimenSizes.dimen_16,
        ),
      ),
      onChanged: (value) {
        _selectedTextMonthlyIncome = value!;
        ekycInfo.income_amount = _selectedTextMonthlyIncome;
        setState(() {});
      },
      validator: (value) {
        if (value == null) {
          return 'monthly_income_required'.tr();
        }
        return null;
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: const CustomCommonAppBarWidget(appBarTitle: "additional_info"),
      bottomSheet: SafeNextButtonWidget(
          text: "next".tr(),
          onPressedFunction: () {
            if (_additionalFormKey.currentState!.validate()) {

              // changing partial to ekyc flow here
              gotoFaceVerificationFlow(context);
              /*
              if (ekycState == EkycStatus.PARTIAL.name) {
                updateUser();
              } else {
                gotoFaceVerificationFlow(context);
              }
               */
            } else {
              Toasts.showErrorToast("give_all_inputs".tr());
            }
          }),
      body: Form(
        key: _additionalFormKey,
        child: SingleChildScrollView(
          padding:  EdgeInsets.all(AppDimen.appMarginHorizontal),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: DimenEdgeInset.marginTB_8_2,
                  child: genderDropdown),
              Container(
                  alignment: Alignment.center,
                  padding:  DimenEdgeInset.marginTB_8_2,
                  margin: const EdgeInsets.only(top: AppDimen.gapBetweenTextField),
                  child: bloodGrpDropdown),
              Container(
                  alignment: Alignment.center,
                  padding:  DimenEdgeInset.marginTB_8_2,
                  margin: const EdgeInsets.only(top: AppDimen.gapBetweenTextField),
                  child: occupationDropdown),
              Container(
                  alignment: Alignment.center,
                  padding:  DimenEdgeInset.marginTB_8_2,
                  margin: const EdgeInsets.only(top: AppDimen.gapBetweenTextField),
                  child: sourceOfIncomeDropdown),
              Container(
                  alignment: Alignment.center,
                  padding:  DimenEdgeInset.marginTB_8_2,
                  margin: const EdgeInsets.only(top: AppDimen.gapBetweenTextField),
                  child: monthlyIncomeDropdown),
            ],
          ),
        ),
      ),
    );
  }

  void updateUser() {
    ref
        .watch(updateUserControllerProvider.notifier)
        .updateUser();
  }

  void gotoFaceVerificationFlow(BuildContext context) {
    ref
        .watch(camDirectionProvider.notifier)
        .updateDirection(CamDirection.front);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const FaceScreen()),
    );
  }

  List<DropdownMenuItem<String>> _genderDropDownItem() {
    return _genders
        .map((value) => DropdownMenuItem(
              value: value,
              child: Center(
                child: CustomCommonTextWidget(
                    text: value,
                    style: CommonTextStyle.regular_14,
                    color: colorPrimaryText,
                    textAlign :  TextAlign.center,
                    shouldShowMultipleLine : true
                ),
              ),
            ))
        .toList();
  }

  List<DropdownMenuItem<String>> _bloodGroupDropDownItem() {
    return _bloodGroup
        .map((value) => DropdownMenuItem(
              value: value,
              child: Center(
                child: CustomCommonTextWidget(
                    text: value,
                    style: CommonTextStyle.regular_14,
                    color: colorPrimaryText,
                    textAlign :  TextAlign.center,
                    shouldShowMultipleLine : true
                ),
              ),
            ))
        .toList();
  }

  List<DropdownMenuItem<String>> _occupationDropDownItem() {
    return _occupation
        .map((value) => DropdownMenuItem(
              value: value,
              child: Center(
                child: CustomCommonTextWidget(
                    text: value,
                    style: CommonTextStyle.regular_14,
                    color: colorPrimaryText,
                    textAlign :  TextAlign.center,
                    shouldShowMultipleLine : true
                ),
              ),
            ))
        .toList();
  }

  List<DropdownMenuItem<String>> _sourceOfIncomeDropDownItem() {
    return _sourceOfIncome
        .map((value) => DropdownMenuItem(
              value: value,
              child: Center(
                child: CustomCommonTextWidget(
                    text: value,
                    style: CommonTextStyle.regular_14,
                    color: colorPrimaryText,
                    textAlign :  TextAlign.center,
                    shouldShowMultipleLine : true
                ),
              ),
            ))
        .toList();
  }

  List<DropdownMenuItem<String>> _monthlyIncomeDropDownItem() {
    return _monthlyIncome
        .map((value) => DropdownMenuItem(
              value: value,
              child: Center(
                child: CustomCommonTextWidget(
                    text: value,
                    style: CommonTextStyle.regular_14,
                    color: colorPrimaryText,
                    textAlign :  TextAlign.center,
                    shouldShowMultipleLine : true
                ),
              ),
            ))
        .toList();
  }

  void initAsyncListener() {
    ref.listen<AsyncValue>(
      updateUserControllerProvider,
      (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast(currentState.error);
        } else {
          EasyLoading.dismiss();
          log.info("success");

          final updateUserResponse = currentState.value as UpdateUserResponse;

          ref.read(localPrefProvider).setBool(PrefKeys.keyIsUserLoggedIn, true);

          Toasts.showSuccessToast(updateUserResponse.message);

          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
            return const DashboardScreen();
          }), (r){
            return false;
          });
        }
      },
    );
  }
}
