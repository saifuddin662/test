import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/base_consumer_state.dart';
import '../../common/common_api/check_user/check_user_controller.dart';
import '../../common/toasts.dart';
import '../../ui/configs/branding_data_controller.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_common_inputfield_widget.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import 'cash_out_enter_amount_screen.dart';

class CashOutNumberScreen extends ConsumerStatefulWidget {

  const CashOutNumberScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CashOutNumberScreen> createState() => _CashOutNumberScreenState();
}

class _CashOutNumberScreenState extends BaseConsumerState<CashOutNumberScreen> {

  final agentNumberTextController = TextEditingController();

  @override
  void dispose() {
    agentNumberTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final checkUser = ref.read(checkUserControllerProvider.notifier);

    ref.listen<AsyncValue>(
      checkUserControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();
          if(currentState.value.userType == "AGENT") {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                CashOutEnterAmountScreen(
                    agentName: currentState.value.userName,
                    agentNumber: agentNumberTextController.text
                )
            ));
          }
          else {
            Toasts.showErrorToast("invalid_account_type".tr());
          }
        }
      },
    );

    return Scaffold(
        appBar: const CustomCommonAppBarWidget(appBarTitle: 'cash_out'),
        body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: AppDimen.toolbarBottomGap),
              Form(
                child: Padding(
                  padding: AppDimen.commonLeftRightPadding,
                  child: CustomCommonInputFieldWidget(
                      controller: agentNumberTextController,
                      obscureText: false,
                      scrollPadding: const EdgeInsets.all(0.0),
                      maxLength: 12,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: 'enter_agent_wallet_num'.tr(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              if(agentNumberTextController.text.isNotEmpty) {
                                checkUser.checkUser(agentNumberTextController.text);
                              }
                              else {
                                Toasts.showErrorToast("enter_agent_num".tr());
                              }
                            },
                            icon: const Icon(Icons.arrow_forward),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: AppDimen.commonCircularBorderRadius,
                            borderSide:  BorderSide(color: BrandingDataController.instance.branding.colors.primaryColor, width: DimenSizes.dimen_half),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: AppDimen.commonCircularBorderRadius,
                            borderSide: BorderSide(color: greyColor, width: DimenSizes.dimen_2),
                          )
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (val) {
                        if (val!.length < 12) {
                          return "enter_valid_wallet_num".tr();
                        }
                        return null;
                      },
                    ),
                ),
              ),
            ]
        )
    );
  }
}

