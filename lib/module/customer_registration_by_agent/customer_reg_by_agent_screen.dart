import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/base_consumer_state.dart';
import '../../common/toasts.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_common_inputfield_widget.dart';
import '../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/styles.dart';
import '../dashboard/dashboard_screen.dart';
import '../ekyc/ekyc_core/mixins/nid_validation_mixin.dart';
import 'api/customer_reg_by_agent_controller.dart';
import 'api/model/customer_reg_by_agent_request.dart';
import '../../utils/extensions/extension_text_style.dart';


class CustomerRegByAgentScreen extends ConsumerStatefulWidget {

  const CustomerRegByAgentScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomerRegByAgentScreen> createState() => _CustomerRegByAgentScreenState();
}

class _CustomerRegByAgentScreenState extends BaseConsumerState<CustomerRegByAgentScreen> with NidValidationMixin {

  final  _regFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final nidController = TextEditingController();
  final dobController = TextEditingController();

  dynamic dob;

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      customerRegByAgentControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();
          Toasts.showSuccessToast("${currentState.value.message}");
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) => const DashboardScreen()
          ), (route) => false);
        }
      },
    );


    return Scaffold(
      appBar: const CustomCommonAppBarWidget(appBarTitle: "customer_reg"),
      backgroundColor: Colors.white,
      body: Form(
        key: _regFormKey,
          child: Padding(
            padding: const EdgeInsets.only(
                top: AppDimen.toolbarBottomGap,
                bottom: AppDimen.toolbarBottomGap
            ),

            child: SingleChildScrollView(
              padding: AppDimen.scrollViewPaddingLTRB,
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                   CustomCommonTextWidget(
                    text: "set_up_account".tr(),
                    style: CommonTextStyle.bold_14,
                    color: colorPrimaryText,
                    shouldShowMultipleLine: true
                   ),

                  const SizedBox( height: DimenSizes.dimen_10),

                  const Divider(
                    color: Colors.grey,
                    height: DimenSizes.dimen_12,
                    thickness: DimenSizes.dimen_half,
                    indent: DimenSizes.dimen_2,
                    endIndent: DimenSizes.dimen_2,
                  ),

                  const SizedBox( height: DimenSizes.dimen_10),

                  CustomCommonInputFieldWidget(
                    controller: nameController ,
                    obscureText: false,
                    scrollPadding: const EdgeInsets.all(0),
                    keyboardType: TextInputType.name,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: validateBasicText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: AppDimen.commonCircularBorderRadius,
                        borderSide:  BorderSide(color: greyColor, width: DimenSizes.dimen_2),
                      ),
                      labelText: "name_bangla_nid".tr(),
                      labelStyle: FontStyle.l_14_regular(color: colorPrimaryText),
                      hintText: "enter_your_full_name".tr(),
                      hintStyle: FontStyle.l_12_regular(color: suvaGray),
                    ),
                  ),

                  const SizedBox( height: DimenSizes.dimen_25),

                  CustomCommonInputFieldWidget(
                    controller: mobileNumberController,
                    obscureText: false,
                    scrollPadding: const EdgeInsets.all(0),
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: validateMobileNo,
                    maxLength: 11,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: AppDimen.commonCircularBorderRadius,
                        borderSide:  BorderSide(color: greyColor, width: DimenSizes.dimen_2),
                      ),
                      labelText: 'mobile_number'.tr(),
                      labelStyle: FontStyle.l_14_regular(),
                      hintText: "enter_mobile_number".tr(),
                      hintStyle: FontStyle.l_12_regular(color: suvaGray),
                    ),
                  ),

                  const SizedBox( height: DimenSizes.dimen_15),

                  CustomCommonInputFieldWidget(
                    controller: nidController,
                    obscureText: false,
                    scrollPadding: const EdgeInsets.all(0),
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: validateNid,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: AppDimen.commonCircularBorderRadius,
                        borderSide:  BorderSide(color: greyColor, width: DimenSizes.dimen_2),
                      ),
                      labelText: "nid_num".tr(),
                      labelStyle: FontStyle.l_14_regular(),
                      hintText: "enter_nid_number".tr(),
                      hintStyle: FontStyle.l_12_regular(color: suvaGray),
                    ),
                  ),

                  const SizedBox( height: DimenSizes.dimen_25),

                  CustomCommonInputFieldWidget(
                    controller: dobController,
                    obscureText: false,
                    validator: validateBasicText,
                    scrollPadding: const EdgeInsets.all(0),
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onTap: () async {
                      log.info('Date of birth clicked');

                      FocusScope.of(context).requestFocus(FocusNode());

                      await processDob(context);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: AppDimen.commonCircularBorderRadius,
                        borderSide:  BorderSide(color: greyColor, width: DimenSizes.dimen_2),
                      ),
                      labelText: "dob".tr(),
                      labelStyle: FontStyle.l_14_regular(),
                      hintStyle: FontStyle.l_12_regular(color: suvaGray),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),

      bottomSheet: SafeNextButtonWidget(
          text: "submit".tr(),
          onPressedFunction: () {
            if (_regFormKey.currentState!.validate()) {
              CustomerRegByAgentRequest customerRegByAgentRequest = CustomerRegByAgentRequest(
                  name: nameController.text,
                  mobileNumber: mobileNumberController.text,
                  nid: nidController.text,
                  dob: dobController.text
              );
              ref.read(customerRegByAgentControllerProvider.notifier).customerRegByAgent(customerRegByAgentRequest);
            } else {
              Toasts.showErrorToast("give_all_inputs".tr());
            }
          }),
    );
  }

  Future<void> processDob(BuildContext context) async {
    var datePicked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: DateTime(1994),
      firstDate: DateTime(1923),
      lastDate: DateTime.now(),
      dateFormat: "yyyy-MMMM-dd",
      looping: true,
    );

    if (datePicked == null) {
      log.info('null');
    } else {
      dob = datePicked;

      var outputFormatForServer = DateFormat('yyyy-MM-dd');

      var outputForServer = outputFormatForServer.format(dob);

      dobController.text = outputForServer;
      log.info('picked dob server -------> $outputForServer');
    }
  }
}
