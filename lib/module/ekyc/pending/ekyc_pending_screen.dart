import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../../base/base_consumer_state.dart';
import '../../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimens/app_dimens.dart';
import '../../../utils/dimens/dimensions.dart';
import '../../../utils/styles.dart';
import '../../login_registration/registration/get_started_screen.dart';

class EkycPendingScreen extends ConsumerStatefulWidget {
  const EkycPendingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EkycPendingScreen> createState() => _EkycPendingScreenState();
}

class _EkycPendingScreenState extends BaseConsumerState<EkycPendingScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final getStartedButton = SafeNextButtonWidget(
        text: "back_to_startPage".tr(),
        onPressedFunction: () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
            return const GetStartedScreen();
          }), (r){
            return false;
          });
        });

    return Scaffold(
      backgroundColor: ekycHomeScreenBackground,
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'ekyc'),
      bottomSheet: getStartedButton,
      body:  Container(
        alignment: Alignment.center,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
          alignment: Alignment.center,
          width:  screenWidth*0.85,
          height: screenHeight*0.55,
          child: Card(
            shape: const RoundedRectangleBorder(
                borderRadius: AppDimen.commonCircularBorderRadius),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: DimenEdgeInset.paddingLTRB_ekyc_pending_pic,
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: SvgPicture.asset(
                          'assets/svg_files/ic_pending_page.svg')),
                ),
                Padding(
                  padding: DimenEdgeInset.paddingLTRB_ekyc_pending_title,
                  child: CustomCommonTextWidget(
                      text:  "verification_pending".tr(),
                      style: CommonTextStyle.bold_16,
                      color: ekycPendingTitle,
                      textAlign :  TextAlign.center,
                      shouldShowMultipleLine : true
                  ),

                ),
                Padding(
                  padding: DimenEdgeInset.paddingLTRB_ekyc_pending_subtitle,
                  child: CustomCommonTextWidget(
                      text:  "your_verification_pending_msg".tr(),
                      style: CommonTextStyle.regular_12,
                      color: colorPrimaryText,
                      textAlign :  TextAlign.center,
                      shouldShowMultipleLine : true
                  ),
                ),
              ],
            ),
          ),
          ),
          const SizedBox(height: DimenSizes.dimen_60),
        ],
      ),
      ),
    );
  }
}
