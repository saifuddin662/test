import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/dynamic_utility/du_core/api/du_info/du_info_controller.dart';
import 'package:red_cash_dfs_flutter/module/dynamic_utility/du_core/dynamic_view/elements/dynamic_text_field.dart';
import 'package:red_cash_dfs_flutter/module/dynamic_utility/du_core/dynamic_view/elements/notification_number_widget_field.dart';
import 'package:red_cash_dfs_flutter/module/dynamic_utility/du_core/dynamic_view/enum/dynamic_view_type.dart';
import 'package:red_cash_dfs_flutter/module/dynamic_utility/du_core/model/utility_info_model.dart';
import 'package:red_cash_dfs_flutter/utils/dimens/app_dimens.dart';
import 'package:red_cash_dfs_flutter/utils/dimens/dimensions.dart';
import '../../base/base_consumer_state.dart';
import '../../common/common_api/check_balance/check_balance_controller.dart';
import '../../common/toasts.dart';
import '../../core/di/core_providers.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../utils/number_formatter.dart';
import '../../utils/pref_keys.dart';
import 'du_core/api/du_detail/model/utility_detail_response.dart';
import 'du_core/api/du_info/model/utility_info_response.dart';
import 'du_core/dynamic_view/data/dynamic_utility_data_controller.dart';
import 'du_info_screen.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 08,March,2023.

typedef DynamicValueListener = void Function(String key, dynamic value);
typedef NextButtonValueListener = void Function(bool isEnable);
typedef NormalStateValueListener = void Function(bool value);

class DynamicUtilityDetailScreen extends ConsumerStatefulWidget {
  final UtilityDetailResponse detailResponse;

  const DynamicUtilityDetailScreen(this.detailResponse, {Key? key})
      : super(key: key);

  @override
  ConsumerState<DynamicUtilityDetailScreen> createState() =>
      _DynamicUtilityDetailScreenState();
}

class _DynamicUtilityDetailScreenState
    extends BaseConsumerState<DynamicUtilityDetailScreen> {
  final dynamicUtilityKey = GlobalKey<FormState>();
  bool isNextButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initialButtonState();
      ref.read(checkBalanceControllerProvider.notifier).checkBalance();
    });
  }

  @override
  Widget build(BuildContext context) {
    initAsyncListener();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: const CustomCommonAppBarWidget(appBarTitle: "utility_detail"),
      body: Form(
        key: dynamicUtilityKey,
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              ListView.builder(
                  physics: const ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.detailResponse.fieldItemList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final element = widget.detailResponse.fieldItemList![index];

                    return Container(
                      margin: const EdgeInsets.only(
                          left: AppDimen.appMarginHorizontal ,
                          right: AppDimen.appMarginHorizontal ,
                          top: AppDimen.toolbarBottomGap),
                      child: populateViews(element, updateFormValue),
                    );
                  }),
              Gap.h80
            ],
          ),
        ),
      ),
      bottomSheet: SafeNextButtonWidget(
          text: "next".tr(),
          onPressedFunction:
              isNextButtonEnabled ? () => nextButtonAction() : null),
    );
  }

  void nextButtonAction() {
    if (dynamicUtilityKey.currentState!.validate()) {
      ref.read(duInfoControllerProvider.notifier).utilityInfo();
    } else {
      Toasts.showErrorToast('enter_required_info'.tr());
    }
  }

  Widget populateViews(FieldItemList element, DynamicValueListener valueListener) {
    DynamicViewType viewType;

    try {
      viewType = DynamicViewType.toType(element.fieldType);
    } catch (e) {
      viewType = DynamicViewType.none;
    }

    switch (viewType) {
      case DynamicViewType.text:
        {
          updateRequired(element);
          return DynamicTextField(
            element: element,
            valueListener: valueListener,
          );
        }
      case DynamicViewType.notificationWidget:
        {

          return NotificationNumberWidget(
            element: element,
            valueListener: valueListener,
            updateNextButton: updateNextButton,
            updateNormalState: updateNextButtonStateTest,

          );
        }
      default:
        return ListTile(
            leading: const Icon(Icons.add), title: Text(element.fieldType));
    }
  }

  void updateRequired(FieldItemList element) {
    if (element.required! && DynamicUtilityDataController.instance.requiredMap[element.key!] != true) {
      DynamicUtilityDataController.instance.requiredMap[element.key!] = false;
    }
  }

  void updateFormValue(String key, dynamic value) {
    updateNextButtonState();

    DynamicUtilityDataController.instance.fieldValue[key] = value;
    log.info('DynamicUtility: key -> $key, value -> $value');
  }

  void updateNextButton(bool isEnable) {
    if (isEnable) {
      setState(() {
        isNextButtonEnabled = true;
      });
    } else {
      setState(() {
        isNextButtonEnabled = false;
      });
    }
    log.info('DynamicUtility: nex button updated');
  }

  void updateNextButtonStateTest(bool value) {

    Timer(const Duration(milliseconds: 200), () {
      if (dynamicUtilityKey.currentState!.validate() && !DynamicUtilityDataController.instance.requiredMap.containsValue(false)) {
        setState(() {
          isNextButtonEnabled = true;
        });
      } else {
        setState(() {
          isNextButtonEnabled = false;
        });
      }
    });


  }

  void updateNextButtonState() {
    if (dynamicUtilityKey.currentState!.validate() && !DynamicUtilityDataController.instance.requiredMap.containsValue(false)) {
      setState(() {
        isNextButtonEnabled = true;
      });
    } else {
      setState(() {
        isNextButtonEnabled = false;
      });
    }
  }

  void initialButtonState() {
    if (DynamicUtilityDataController.instance.requiredMap.isEmpty ||
        DynamicUtilityDataController.instance.requiredMap == {}) {
      setState(() {
        isNextButtonEnabled = true;
      });
    }
  }

  void initAsyncListener() {

    final currentBalance = ref.read(localPrefProvider).getDouble(PrefKeys.keyCheckBalance);

    ref.listen<AsyncValue>(
      duInfoControllerProvider,
      (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();

          if (currentState.value != null) {
            final infoResponse = currentState.value as UtilityInfoResponse;

            DynamicUtilityDataController.instance.utilityInfo.transactionId = infoResponse.transactionId;

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DynamicUtilityInfoScreen(UtilityInfoModel(
                          utilityTitle: '${widget.detailResponse.utilityTitle!} Bill Payment',
                          logoUrl: widget.detailResponse.utilityImage!,
                          isPaid: NumberFormatter.parseOnlyDouble(
                                      infoResponse.dueAmount!) <=
                                  0
                              ? true
                              : false,
                          dueAmount: infoResponse.dueAmount!,
                          currentBalance: currentBalance.toString(),
                          txnId: infoResponse.transactionId!,
                          transactionSummary: infoResponse.infoItemArrayList,
                          recipientSummary: [
                            widget.detailResponse.utilityTitle!,
                            infoResponse.dueAmount!
                          ],
                          utilityCode: widget.detailResponse.utilityCode!,
                        ))));
          }
        }
      },
    );
  }
}
