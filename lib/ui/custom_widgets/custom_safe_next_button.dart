import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/base_consumer_state.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/styles.dart';
import '../configs/branding_data_controller.dart';
import 'custom_common_text_widget.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 21,February,2023.

class SafeNextButtonWidget extends ConsumerStatefulWidget {
  final String text;
  final VoidCallback? onPressedFunction;
  final Duration reEnableTime;

  const SafeNextButtonWidget({
    super.key,
    required this.text,
    required this.onPressedFunction,
    this.reEnableTime = const Duration(milliseconds: 3000),
  });

  @override
  ConsumerState<SafeNextButtonWidget> createState() => _SafeNextButtonWidgetState();
}

class _SafeNextButtonWidgetState extends BaseConsumerState<SafeNextButtonWidget> {
  bool _canTap = true;

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: Platform.isIOS ? AppDimen.nextIosButtonPaddingLTRB : AppDimen.nextAndroidButtonPaddingLTRB,
      decoration: const BoxDecoration(
        borderRadius: AppDimen.commonCircularBorderRadius,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.transparent,
            offset: Offset(1.1, 1.1),
            blurRadius: 3.0,
          ),
        ],
      ),
      child: MaterialButton(
        color: BrandingDataController.instance.branding.colors.primaryColor,
        disabledColor: Colors.grey,
        minWidth: MediaQuery.of(context).size.width,
        padding: AppDimen.commonButtonTextPadding,
        shape: const RoundedRectangleBorder(
          borderRadius: AppDimen.commonCircularBorderRadius,
        ),
        onPressed: widget.onPressedFunction != null ? () => operate() : null,
        child: CustomCommonTextWidget(
            text: widget.text.tr(),
            style: CommonTextStyle.bold_14,
            color: bottomNavBarBackgroundColor,
            textAlign :  TextAlign.center,
            shouldShowMultipleLine : true
        ),
      ),
    );
  }

  void operate() {
    if (_canTap && widget.onPressedFunction != null) {
      _canTap = false;
      widget.onPressedFunction!();
      Future.delayed(widget.reEnableTime, () {
        if (mounted) {
          _canTap = true;
        }
      });
    } else {
      debugPrint(
          "===================================CLICK IGNORED===================================");
    }
  }
}
