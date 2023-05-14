import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/base_consumer_state.dart';
import '../../common/common_api/get_transaction_fee/model/transaction_fee_request.dart';
import '../../common/common_api/get_transaction_fee/transaction_fee_controller.dart';
import '../../common/constants.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../common/model/summary_details_item.dart';
import '../../common/toasts.dart';
import '../../core/di/core_providers.dart';
import '../../core/flavor/flavor_provider.dart';
import '../../ui/configs/branding_data_controller.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_common_error_widget.dart';
import '../../ui/custom_widgets/custom_common_inputfield_widget.dart';
import '../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../utils/Colors.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_utils.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/pref_keys.dart';
import '../../utils/styles.dart';
import '../ekyc/ekyc_core/mixins/nid_validation_mixin.dart';
import '../statements/education_fees/data/statement_edu_data_controller.dart';
import 'api/model/EducationFeesRequest.dart';
import 'api/model/institute_list_response.dart';
import 'api/model/school_fees_request.dart';
import 'api/model/school_fees_response.dart';
import 'api/registration_info_controller.dart';
import 'education_fees_status_screen.dart';
import 'fee_list_screen.dart';

/// Created by Md. Awon-Uz-Zaman on 01/February/2023

class RegistrationInfoScreen extends ConsumerStatefulWidget {
  const RegistrationInfoScreen ({
    Key? key,
    required this.institute,
  }) : super(key: key);

  final Institute institute;

  @override
  BaseConsumerState<RegistrationInfoScreen> createState() => _RegistrationInfoScreenState();
}

class _RegistrationInfoScreenState extends BaseConsumerState<RegistrationInfoScreen> with NidValidationMixin{
  String typedRegistrationCode = "";
  String notificationNumber = "";
  bool isChecked = false;
  double amount = 0.0;
  final mobileRegExp = RegExp("(?:\\+88|88)?(01[3-9]\\d{8})");
  SchoolFeesResponse feeResponse = SchoolFeesResponse();

  var type = "";

  bool priceUpdateValue = false;

  @override
  void initState() {
    super.initState();
    type = "self";
  }

  @override
  Widget build(BuildContext context) {
    final userWalletNumber = ref.read(localPrefProvider).getString(PrefKeys.keyMsisdn)!;
    final currentBalance = ref.read(localPrefProvider).getString(PrefKeys.keyUserBalance);

    final userType = ref.read(flavorProvider).name;
    var txnType = 'PAYMENT';

    if (userType == AppConstants.userTypeAgent) {
      txnType = 'AGENT_ASSISTED_PAYMENT';
    } else {
      txnType = 'PAYMENT';
    }

    ref.listen<AsyncValue>(
      transactionFeeControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();

          log.info('-------------------------------------------------------> transactionFeeControllerProvider = reg info screen ');

          var amount = feeResponse.amount;
          var charge = currentState.value.chargeAmount?.toString() ?? "0";
          var totalAmount = (currentState.value.chargeAmount ?? 0.0) + (feeResponse.amount ?? 0.0);



          if (widget.institute.isOpenInstitute == 0) {
            _navigate(amount, charge, totalAmount, currentBalance, userWalletNumber,txnType, Constants.unpaid);
          }

        }
      },
    );

    ref.listen<AsyncValue>(
      registrationInfoControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          //Toasts.showErrorToast("${currentState.error}");
          log.info('======================================================================== registrationInfoControllerProvider 1');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomCommonErrorWidget(
                errorTitle: 'Error',
                errorMessage: '${currentState.error}',
              ),
            ),
          );
        } else {
          EasyLoading.dismiss();
          final data = ref.watch(registrationInfoControllerProvider);

          feeResponse = data.value!;
          StatementEduDataController.instance.eduInfo.regId = typedRegistrationCode;
          if(notificationNumber == ""){
            notificationNumber = userWalletNumber;
          }
          if(widget.institute.isOpenInstitute == 1 && data.value?.feeList != null && data.value!.feeList!.length > 0){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                FeeListScreen(
                  feeResponse: data.value,
                  institute: widget.institute,
                  regId: typedRegistrationCode,
                  notificationNumber: notificationNumber,
                )
            ));
          } else {

            amount = feeResponse.amount!;
            if(amount > 0.0) {
              ref.read(transactionFeeControllerProvider.notifier)
                  .getTransactionFee(
                  TransactionFeeRequest(
                      userWalletNumber,
                      data.value?.institutionWallet ?? "",
                      txnType,
                      data.value?.amount.toString()
                  )
              );
            } else {
              _navigate(amount.toString(), "0", amount, currentBalance, userWalletNumber, txnType, Constants.notFound);
            }
          }
          //todo go to status page with array
        }
      },
    );

    return Scaffold(
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'education_fees'),
      body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: AppDimen.toolbarBottomGap),
            Padding(
              padding: AppDimen.commonLeftRightPadding,
              child: CustomCommonTextWidget(
                  text: "student_reg_id".tr(),
                  style: CommonTextStyle.regular_16,
                  color: colorPrimaryText,
                  textAlign :  TextAlign.start,
                  shouldShowMultipleLine : true
              ),
            ),
            const SizedBox(height: DimenSizes.dimen_15),
            Padding(
              padding: AppDimen.commonLeftRightPadding,
              child: CustomCommonInputFieldWidget(
                obscureText: false,
                scrollPadding: const EdgeInsets.all(0.0),
                onChanged: (value) {
                  typedRegistrationCode = value;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'enter_reg_id'.tr(),
                    border:  OutlineInputBorder(
                      borderRadius: AppDimen.commonCircularBorderRadius,
                      borderSide: BorderSide(color: greyColor, width: DimenSizes.dimen_2),
                    )
                ),
              ),
            ),
            const SizedBox(height: DimenSizes.dimen_10),
            Visibility(
              visible: priceUpdateValue,
              child: Padding(
                padding: AppDimen.commonLeftRightPadding,
                child: CustomCommonInputFieldWidget(
                  obscureText: false,
                  maxLength: 11,
                  scrollPadding: const EdgeInsets.all(0.0),
                  onChanged: (value) {
                notificationNumber = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                  labelText: 'enter_mobile_number'.tr(),
                  border:  OutlineInputBorder(
                    borderRadius: AppDimen.commonCircularBorderRadius,
                    borderSide: BorderSide(color: greyColor, width: DimenSizes.dimen_2),
                  )
                  ),
                ),
              ),
            ),
            const SizedBox(height: DimenSizes.dimen_10),
            Padding(
              padding: AppDimen.commonLeftRightPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: type=="self" ? BrandingDataController.instance.branding.colors.primaryColor: unselectedFontColor),
                            borderRadius: AppDimen.commonCircularBorderRadius
                        ),
                        child: RadioListTile(
                          title: CustomCommonTextWidget(
                              text: "_self".tr(),
                              style: CommonTextStyle.regular_16,
                              color: colorPrimaryText,
                              shouldShowMultipleLine : true
                          ),
                          value: "self",
                          activeColor: BrandingDataController.instance.branding.colors.primaryColor,
                          groupValue: type,
                          onChanged: (value){
                            setState(() {
                              priceUpdateValue = false;
                              type = value.toString();
                            });
                          },
                        ),
                      )
                  ),
                  const SizedBox(width: DimenSizes.dimen_10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: type=="other" ? BrandingDataController.instance.branding.colors.primaryColor: unselectedFontColor),
                          borderRadius: AppDimen.commonCircularBorderRadius
                      ),
                      child: RadioListTile(
                        title: CustomCommonTextWidget(
                            text: "_other".tr(),
                            style: CommonTextStyle.regular_16,
                            color: colorPrimaryText,
                            shouldShowMultipleLine : true
                        ),
                        value: "other",
                        activeColor: BrandingDataController.instance.branding.colors.primaryColor,
                        groupValue: type,
                        onChanged: (value){
                          setState(() {
                            priceUpdateValue = true;
                            type = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: DimenSizes.dimen_10),
          ]
      ),
      bottomSheet: SafeNextButtonWidget(
          text: "next".tr(),
          onPressedFunction: () {
            AppUtils.hideKeyboard();

            if(priceUpdateValue == true){
              if(typedRegistrationCode.isNotEmpty){
                if (notificationNumber.isNotEmpty && notificationNumber != userWalletNumber){
                  if (mobileRegExp.hasMatch(notificationNumber)) {
                          ref.read(registrationInfoControllerProvider.notifier).getFees(SchoolFeesRequest(insCode: widget.institute.code, regId: typedRegistrationCode));
                  }else {
                    Toasts.showErrorToast("enter_valid_mobile_no".tr());
                  }
                }
                else {
                  Toasts.showErrorToast("input_mobile_number".tr());
                }
              }
              else {
                Toasts.showErrorToast("input_reg_number".tr());
              }
            }
            else{
              if (typedRegistrationCode.isNotEmpty) {
                ref.read(registrationInfoControllerProvider.notifier).getFees(
                    SchoolFeesRequest(insCode: widget.institute.code,
                        regId: typedRegistrationCode));
              } else {
                Toasts.showErrorToast("input_reg_number".tr());
              }
            }
          }
      ),
    );
  }

  void _navigate(amount, charge, totalAmount, currentBalance, userWalletNumber, txnType, status){

    final mAmount  = amount ?? 0.0;
    var amountInput = 0.0;

    try {
      amountInput = double.parse(mAmount);
    } catch (e) {
      amountInput = mAmount;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        EducationFeesStatusScreen(
          isPaid: amountInput <= 0.0 ? true : false,
          isOpen: widget.institute.isOpenInstitute == 0 ? true : false, // todo server is sending wrong status
          confirmDialogModel: CommonConfirmDialogModel(
              "education_fees".tr(),
              "education_fees".tr(),
              [
                feeResponse.institutionName ?? "",
                feeResponse.institutionWallet.toString(),
                currentBalance,
              ],
              [
                SummaryDetailsItem(
                    "ins_code".tr(),
                    widget.institute.code.toString()
                ),
                SummaryDetailsItem(
                    "ins_name".tr(),
                    feeResponse.institutionName.toString()
                ),
                SummaryDetailsItem(
                    "amount".tr(),
                    "৳ $amount"
                ),
                SummaryDetailsItem(
                    "student_name".tr(),
                    feeResponse.studentName.toString()
                ),
                SummaryDetailsItem(
                    "reg_id".tr(),
                    typedRegistrationCode
                ),
                SummaryDetailsItem(
                    "charge".tr(),
                    charge ?? '0.0'
                ),
              ],
              ApiUrls.schoolPayment
          ),
          schoolInfo: SchoolPaymentInfo(
            amount: totalAmount.toInt(),
            channel: "App",
            fromAc: userWalletNumber,
            insCode: widget.institute.code,
            insWallet: widget.institute.wallet,
            notificationNumber: notificationNumber,
            regId: typedRegistrationCode,
            remarks: "N/A",
            status: "",
            txnNo: "",
            txnTime: "",
            txnType: txnType,
          ),
          status: status,
        ))
    );
  }
}