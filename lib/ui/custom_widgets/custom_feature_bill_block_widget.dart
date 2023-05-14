import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/toasts.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/styles.dart';
import 'custom_common_text_widget.dart';

class CustomFeatureBillBlockWidget extends StatelessWidget {
  final String iconUrl;
  final String text;
  final bool isActive;
  final VoidCallback onPressed;
  final bool networkSvgImage;

  const CustomFeatureBillBlockWidget({
    super.key,
    required this.iconUrl,
    required this.text,
    required this.isActive,
    required this.onPressed, required this.networkSvgImage,
  });

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: isActive
          ? ColorFilter.mode(Colors.white.withOpacity(0.0), BlendMode.srcATop)
          : ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.srcATop),
      child: InkWell(
        onTap: isActive
            ? onPressed
            : () {
          Toasts.showInformationToast("feature_currently_inactive".tr());
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DimenSizes.dimen_10),
          ),
          padding: const EdgeInsets.all(DimenSizes.dimen_10),
          child: Column(
            children: [
              networkSvgImage ?
              loadSvgAsset() :
              CircleAvatar(
                  backgroundColor: utilityIconBackground,
                  radius: 24,
                  child: loadImageAsset()),
              const SizedBox(height: DimenSizes.dimen_5),
              Expanded(
                  child: CustomCommonTextWidget(
                      text: text,
                      textAlign: TextAlign.center,
                      style: CommonTextStyle.regular_12,
                      color: colorPrimaryText,
                      softWrap: true)),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadImageAsset() {
    if (isImageUrl(iconUrl)) {

      return FadeInImage.assetNetwork(
        image:iconUrl,
        height: DimenSizes.dimen_40,
        width: DimenSizes.dimen_40,
        placeholder: 'assets/images/ic_placeholder.png',
      );

    } else {
      return Image.asset(
        iconUrl,
        height: DimenSizes.dimen_40,
        width: DimenSizes.dimen_40,
      );
    }
  }

  SvgPicture loadSvgAsset() {
    if (isImageUrl(iconUrl)) {
      return SvgPicture.network(iconUrl,
          height: DimenSizes.dimen_40,
          width: DimenSizes.dimen_40,
          placeholderBuilder: (BuildContext context) => Image.asset('assets/images/ic_placeholder.png'));
    } else {
      return SvgPicture.asset(
        iconUrl,
        height: DimenSizes.dimen_40,
        width: DimenSizes.dimen_40,
      );
    }
  }

  bool isImageUrl(String url) {
    return url.contains('http') ? true : false;
  }
}
