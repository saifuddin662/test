import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/Colors.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/styles.dart';
import 'custom_common_text_widget.dart';

class CustomCommonFeatureTopItemWidget extends StatelessWidget {

  final bool networkSvgImage;
  final String iconUrl;
  final String title;

  const CustomCommonFeatureTopItemWidget({
    super.key,
    required this.networkSvgImage,
    required this.iconUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            networkSvgImage ?
            loadSvgAsset() :
            loadImageAsset(),
            const SizedBox(width: DimenSizes.dimen_10),
            Expanded(
                child: CustomCommonTextWidget(
                  text: title,
                  style: CommonTextStyle.regular_16,
                  color: eclipse ,
                ),
            )
          ],
        ),
        const Divider(
          color: Colors.grey,
          height: DimenSizes.dimen_12,
          thickness: DimenSizes.dimen_half,
          indent: DimenSizes.dimen_2,
          endIndent: DimenSizes.dimen_2,
        ),
      ],
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