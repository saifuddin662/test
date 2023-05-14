import 'package:flutter/material.dart';
import '../../utils/styles.dart';
import '../../utils/extensions/extension_text_style.dart';

class CustomCommonTextWidget extends StatelessWidget {
  final String text;
  final CommonTextStyle style;
  final Color color;
  final TextAlign? textAlign;
  final bool shouldShowMultipleLine;
  final  int? maxLines;
  final bool? softWrap;

  const CustomCommonTextWidget({super.key,
      required this.text,
      this.style = CommonTextStyle.regular_12,
      this.color = Colors.black,
      this.textAlign = TextAlign.left,
      this.shouldShowMultipleLine = true,
      this.maxLines = 1,
      this.softWrap
      });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = FontStyle.l_12_regular(color: color);

    switch (style) {
      case CommonTextStyle.bold_10:
        textStyle = FontStyle.h1_10_bold(color: color);
        break;
      case CommonTextStyle.bold_12:
        textStyle = FontStyle.h1_12_bold(color: color);
        break;
      case CommonTextStyle.bold_14:
        textStyle = FontStyle.h1_14_bold(color: color);
        break;
      case CommonTextStyle.bold_16:
        textStyle = FontStyle.h1_16_bold(color: color);
        break;
      case CommonTextStyle.bold_18:
        textStyle = FontStyle.h1_18_bold(color: color);
        break;
      case CommonTextStyle.bold_20:
        textStyle = FontStyle.h1_20_bold(color: color);
        break;
      case CommonTextStyle.bold_22:
        textStyle = FontStyle.h1_22_bold(color: color);
        break;
      case CommonTextStyle.bold_24:
        textStyle = FontStyle.h1_24_bold(color: color);
        break;

      case CommonTextStyle.semiBold_10:
        textStyle = FontStyle.h2_10_semibold(color: color);
        break;
      case CommonTextStyle.semiBold_12:
        textStyle = FontStyle.h2_12_semibold(color: color);
        break;
      case CommonTextStyle.semiBold_14:
        textStyle = FontStyle.h2_14_semibold(color: color);
        break;
      case CommonTextStyle.semiBold_16:
        textStyle = FontStyle.h2_16_semibold(color: color);
        break;
      case CommonTextStyle.semiBold_18:
        textStyle = FontStyle.h2_18_semibold(color: color);
        break;
      case CommonTextStyle.semiBold_20:
        textStyle = FontStyle.h2_20_semibold(color: color);
        break;
      case CommonTextStyle.semiBold_22:
        textStyle = FontStyle.h2_22_semibold(color: color);
        break;
      case CommonTextStyle.semiBold_26:
        textStyle = FontStyle.h2_26_semibold(color: color);
        break;

      case CommonTextStyle.regular_10:
        textStyle = FontStyle.l_10_regular(color: color);
        break;
      case CommonTextStyle.regular_12:
        textStyle = FontStyle.l_12_regular(color: color);
        break;
      case CommonTextStyle.regular_14:
        textStyle = FontStyle.l_14_regular(color: color);
        break;
      case CommonTextStyle.regular_16:
        textStyle = FontStyle.l_16_regular(color: color);
        break;
      case CommonTextStyle.regular_18:
        textStyle = FontStyle.l_18_regular(color: color);
        break;
      case CommonTextStyle.regular_20:
        textStyle = FontStyle.l_20_regular(color: color);
        break;
      case CommonTextStyle.regular_28:
        textStyle = FontStyle.l_28_regular(color: color);
        break;
      case CommonTextStyle.regular_48:
        textStyle = FontStyle.l_48_regular(color: color);
        break;
    }

    if (shouldShowMultipleLine == false) {
      return FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: textStyle,
            textAlign: textAlign,
          ));
    } else {
      return Text(
          text,
          style: textStyle,
          textAlign: textAlign
      );
    }
  }
}
