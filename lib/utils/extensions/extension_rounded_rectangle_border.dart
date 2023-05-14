import 'package:flutter/material.dart';
import '../../ui/configs/branding_data_controller.dart';
import '../colors.dart';
import '../dimens/app_dimens.dart';

extension ShapeStyle on  RoundedRectangleBorder{

  static RoundedRectangleBorder listItemShape() {
    return  RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimen.itemCornerRadiusCommon),//<-- SEE HERE
      side: BorderSide(
        color: BrandingDataController.instance.branding.colors.primaryColor,
        width: 0.5,
      ),
    );
  }

}

