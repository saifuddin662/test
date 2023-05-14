import 'package:flutter/material.dart';

import '../../module/education_fees/api/model/institute_list_response.dart';
import '../../utils/Colors.dart';
import '../../utils/styles.dart';
import 'custom_common_text_widget.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 02,March,2023.

class CustomInstituteTileWidget extends StatelessWidget {
  const CustomInstituteTileWidget({
    super.key, this.instituteItem, this.onPressedFunction,
  });

  final Institute? instituteItem;
  final VoidCallback? onPressedFunction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: CustomCommonTextWidget(
            text: instituteItem!.name,
            style: CommonTextStyle.regular_16,
            color: colorPrimaryText,
            shouldShowMultipleLine : true
        ),

        subtitle: CustomCommonTextWidget(
            text: instituteItem!.code,
            style: CommonTextStyle.regular_14,
            color: greyColor,
            shouldShowMultipleLine : true
        ),
        onTap: () => onPressedFunction!());
  }
}