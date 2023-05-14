import 'package:flutter/material.dart';

import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/styles.dart';
import 'custom_common_text_widget.dart';

class CommonTitleWihDivider extends StatelessWidget {
  final String title;

  const CommonTitleWihDivider({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: AppDimen.appMarginHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // dense:true,
          // minVerticalPadding: 0,
          const SizedBox(height: DimenSizes.dimen_8),
          CustomCommonTextWidget(
            text: title ?? "",
            style: CommonTextStyle.semiBold_18,
            color: Colors.black,
            shouldShowMultipleLine: true,
          ),
         const Divider(
            color: Colors.grey,
            thickness: DimenSizes.dimen_half,
          ),
          const SizedBox(height: DimenSizes.dimen_8),
        ],
      ),
    );
  }
}
