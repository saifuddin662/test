import 'package:flutter/material.dart';

import '../../../module/education_fees/api/model/EducationFeesRequest.dart';
import '../../../utils/Colors.dart';
import '../../../utils/styles.dart';
import '../custom_common_text_widget.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 03,April,2023.

class SavedInstituteTileWidget extends StatelessWidget {
  const SavedInstituteTileWidget({
    super.key, this.onPressedFunction, this.schoolPaymentInfo, required this.insName,
  });

  final SchoolPaymentInfo? schoolPaymentInfo;
  final String insName;
  final VoidCallback? onPressedFunction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: CustomCommonTextWidget(
            text: insName,
            style: CommonTextStyle.regular_16,
            color: colorPrimaryText,
            shouldShowMultipleLine : true
        ),

        subtitle: CustomCommonTextWidget(
            text: schoolPaymentInfo!.insCode,
            style: CommonTextStyle.regular_14,
            color: greyColor,
            shouldShowMultipleLine : true
        ),
        onTap: () => onPressedFunction!());
  }
}