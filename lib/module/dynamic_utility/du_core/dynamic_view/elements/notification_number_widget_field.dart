import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../base/base_consumer_state.dart';
import '../../../../../core/di/core_providers.dart';
import '../../../../../ui/configs/branding_data_controller.dart';
import '../../../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../../../utils/Colors.dart';
import '../../../../../utils/dimens/app_dimens.dart';
import '../../../../../utils/dimens/dimensions.dart';
import '../../../../../utils/pref_keys.dart';
import '../../../../../utils/styles.dart';
import '../../../du_detail_screen.dart';
import '../../api/du_detail/model/utility_detail_response.dart';
import '../data/dynamic_utility_data_controller.dart';
import '../mixins/dynamic_utility_validation_mixin.dart';
import '../utils/du_utils.dart';
import '../widgets/dynamic_element_label.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 20,March,2023.

class NotificationNumberWidget extends ConsumerStatefulWidget {
  final FieldItemList element;
  final DynamicValueListener valueListener;
  final NextButtonValueListener updateNextButton;
  final NormalStateValueListener updateNormalState;

  const NotificationNumberWidget({
    super.key,
    required this.element,
    required this.valueListener,
    required this.updateNextButton,
    required this.updateNormalState,
  });

  @override
  ConsumerState<NotificationNumberWidget> createState() =>
      _NotificationNumberWidgetState();
}

class _NotificationNumberWidgetState extends BaseConsumerState<NotificationNumberWidget> with DynamicUtilityValidationMixin{
  String type = 'self';
  bool isInputVisible = false;
  bool isForceDisabled = false;
  bool isFocused = false;
  final FocusNode notiFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint(' DynamicUtilityDetailScreen : noti build');

    final phoneNo = ref.read(localPrefProvider).getString(PrefKeys.keyPhoneNo);

    setSelfNumber(phoneNo);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DynamicElementLabel(
          element: widget.element,
        ),
        const SizedBox(height: DimenSizes.dimen_10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color:
                          type == "self" ? BrandingDataController.instance.branding.colors.primaryColor : unselectedFontColor),
                      borderRadius: AppDimen.commonCircularBorderRadius),
                  child: RadioListTile(
                    title: CustomCommonTextWidget(
                        text: "_self".tr(),
                        style: CommonTextStyle.regular_16,
                        color: colorPrimaryText,
                        shouldShowMultipleLine: true),
                    value: "self",
                    activeColor: BrandingDataController.instance.branding.colors.primaryColor,
                    groupValue: type,
                    onChanged: (value) {
                      setState(() {
                        isFocused = false;
                        isInputVisible = false;
                        widget.updateNormalState(true);
                        type = value.toString();
                        setSelfNumber(phoneNo);
                      });
                    },
                  ),
                )),
            const SizedBox(width: DimenSizes.dimen_10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: type == "other"
                            ? BrandingDataController.instance.branding.colors.primaryColor
                            : unselectedFontColor),
                    borderRadius: AppDimen.commonCircularBorderRadius),
                child: RadioListTile(
                  title: CustomCommonTextWidget(
                      text: "_other".tr(),
                      style: CommonTextStyle.regular_16,
                      color: colorPrimaryText,
                      shouldShowMultipleLine: true),
                  value: "other",
                  activeColor: BrandingDataController.instance.branding.colors.primaryColor,
                  groupValue: type,
                  onChanged: (value) {
                    setState(() {
                      widget.updateNextButton(false);
                      isInputVisible = true;
                      type = value.toString();
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isInputVisible ? DimenSizes.dimen_30 : DimenSizes.dimen_0),
        Visibility(
          visible: isInputVisible,
          child: Builder(builder: (context) {
            //debugPrint(' DynamicUtilityDetailScreen : input build');

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              //debugPrint(' DynamicUtilityDetailScreen : input post frame');

              if (!isFocused) {
                notiFocus.requestFocus();
                isFocused = true;
              }

              if (!isForceDisabled) {
                widget.updateNextButton(false);
                isForceDisabled = true;
              }
            });

            return SizedBox(
              height: 150,
              child: TextFormField(
                keyboardType: DuUtils().setKeyboardType(widget.element),
                focusNode: notiFocus,
                scrollPadding: const EdgeInsets.only(top: 1000000),
                decoration: InputDecoration(
                  hintText: "${widget.element.hint}",
                  border:  OutlineInputBorder(
                    borderRadius: AppDimen.commonCircularBorderRadius,
                    borderSide:  BorderSide(color: greyColor, width: DimenSizes.dimen_2),
                  ),
                ),
                onChanged: (value) {
                  widget.valueListener(widget.element.key!, value);
                  DynamicUtilityDataController.instance.utilityInfo.notificationNumber = value;
                },
                validator: (value) =>
                    validateNotificationField(value, widget.element),
              ),
            );
          }),
        ),
      ],
    );
  }

  void setSelfNumber(String? phoneNo) {
    DynamicUtilityDataController.instance.fieldValue[widget.element.key!] = phoneNo;
    DynamicUtilityDataController.instance.utilityInfo.notificationNumber = phoneNo;
  }
}
