import 'package:flutter/material.dart';

import '../../../ui/configs/branding_data_controller.dart';
import '../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../utils/Colors.dart';
import '../../../utils/dimens/dimensions.dart';
import '../../../utils/styles.dart';

class CustomSummaryRequestedMoneyItemTile extends StatelessWidget{

  final String title;
  final String subTitle;
  const CustomSummaryRequestedMoneyItemTile ({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return  Container(
      alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCommonTextWidget(
              text: title ?? "",
              style: CommonTextStyle.bold_16,
              color: colorPrimaryText,
              textAlign: TextAlign.center,
              shouldShowMultipleLine: true,),

            const SizedBox(height: DimenSizes.dimen_10),

            CustomCommonTextWidget(
              text: subTitle  ?? "",
              style: CommonTextStyle.bold_24,
              color: BrandingDataController.instance.branding.colors.primaryColor,
              textAlign: TextAlign.center,
              shouldShowMultipleLine: true,
            ),
          ],
        ),
    );
  }
}