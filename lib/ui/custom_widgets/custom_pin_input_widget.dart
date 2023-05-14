import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/Colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../configs/branding_data_controller.dart';

class CustomPinInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final int maxLength;

  const CustomPinInputWidget({super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
    required this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      controller: controller,
      obscureText: obscureText,
      maxLength: maxLength,
      keyboardType: TextInputType.number,
      scrollPadding: AppDimen.textFieldScrollPadding,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
            borderRadius: AppDimen.commonCircularBorderRadius,
            borderSide:  BorderSide(color: BrandingDataController.instance.branding.colors.primaryColor, width: DimenSizes.dimen_half),
          ),
          border: OutlineInputBorder(
            borderRadius: AppDimen.commonCircularBorderRadius,
            borderSide:  BorderSide(color: greyColor, width: DimenSizes.dimen_2),
          )
      ),
    );
  }
}