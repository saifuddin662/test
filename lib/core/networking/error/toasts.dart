import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../../utils/colors.dart';
import '../../../ui/configs/branding_data_controller.dart';
import '../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../utils/styles.dart';

class Toasts {
  static void showErrorToast(message) async {
    showOverlayNotification(
      (context) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Material(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(12.0),
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

  static void showSuccessToast(message) async {
    showOverlayNotification(
      (context) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Material(
              color: BrandingDataController.instance.branding.colors.primaryColor,
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(12.0),
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
      duration: Duration(seconds: 2),
    );
  }
}
