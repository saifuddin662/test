import 'package:flutter/material.dart';

import '../../utils/Colors.dart';
import '../../utils/styles.dart';
import 'custom_common_text_widget.dart';

class CommonSummaryItemTile extends StatelessWidget{

  final String title;
  final String subTitle;
  const CommonSummaryItemTile({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return  Container(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCommonTextWidget(text: title ?? "", style: CommonTextStyle.regular_14,color: suvaGray,shouldShowMultipleLine: true,),
          CustomCommonTextWidget(
            text: subTitle  ?? "",
            style: CommonTextStyle.bold_14,
            color: Colors.black,
            shouldShowMultipleLine: true,
          ),
          // ListTile(
          //   // dense:true,
          //   // minVerticalPadding: 0,
          //   contentPadding: EdgeInsets.zero,
          //   title: CustomCommonTextWidget(text: title ?? "",
          //       style: CommonTextStyle.regular_14,color: suvaGray,shouldShowMultipleLine: true,),
          //   subtitle: CustomCommonTextWidget(
          //     text: subTitle  ?? "",
          //     style: CommonTextStyle.bold_14,
          //     color: Colors.black,
          //     shouldShowMultipleLine: true,
          //   ),
          // ),
        ],
      ),
    );
  }
}