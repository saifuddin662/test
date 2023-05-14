import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import '../ui/custom_widgets/custom_common_text_widget.dart';
import '../utils/Colors.dart';
import '../utils/dimens/app_dimens.dart';
import '../utils/dimens/dimensions.dart';
import '../utils/styles.dart';

class Toasts {

  static void showSuccessToast(message) async {
    showOverlayNotification(
          (context) {
        return SafeArea(
          child: Padding(
            padding: AppDimen.toastVerticalHorizontalPadding,
            child: Material(
              color: Colors.green,
              borderRadius: AppDimen.commonCircularBorderRadius,
              child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(DimenSizes.dimen_12),
                  child: CustomCommonTextWidget(
                      text: message,
                      maxLines: 5,
                      textAlign: TextAlign.center,
                      style : CommonTextStyle.regular_14,
                      color: bottomNavBarBackgroundColor
                  )
              ),
            ),
          ),
        );
      },
      position: NotificationPosition.top,
      duration: const Duration(seconds: 2),
    );
  }

  static void showErrorToast(message) async {
    showOverlayNotification(
      (context) {
        return SafeArea(
          child: Padding(
            padding: AppDimen.toastVerticalHorizontalPadding,
            child: Material(
              color: Colors.red,
              borderRadius: AppDimen.commonCircularBorderRadius,
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(DimenSizes.dimen_12),
                child: CustomCommonTextWidget(
                      text: message,
                      maxLines: 5,
                      textAlign: TextAlign.center,
                      style : CommonTextStyle.regular_14,
                      color: bottomNavBarBackgroundColor
                  )
              ),
            ),
          ),
        );
      },
      position: NotificationPosition.top,
      duration: const Duration(seconds: 2),
    );
  }

  static void showInformationToast(message) async {
    showOverlayNotification(
          (context) {
        return SafeArea(
          child: Padding(
            padding: AppDimen.toastVerticalHorizontalPadding,
            child: Material(
              color: Colors.blue,
              borderRadius:AppDimen.commonCircularBorderRadius,
              child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(DimenSizes.dimen_12),
                  child: CustomCommonTextWidget(
                      text: message,
                      maxLines: 5,
                      textAlign: TextAlign.center,
                      style : CommonTextStyle.regular_14,
                      color: bottomNavBarBackgroundColor
                  )
              ),
            ),
          ),
        );
      },
      position: NotificationPosition.top,
      duration: const Duration(seconds: 2),
    );
  }

}
