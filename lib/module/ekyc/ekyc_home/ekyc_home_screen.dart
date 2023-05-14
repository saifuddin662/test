import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../../base/base_consumer_state.dart';
import '../../../ui/configs/branding_data_controller.dart';
import '../../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimens/app_dimens.dart';
import '../../../utils/dimens/dimensions.dart';
import '../../../utils/styles.dart';
import '../../ekyc/ekyc_core/cam_direction_provider.dart';
import '../../ekyc/ekyc_core/camera_direction_type.dart';
import '../../ekyc/nid_scan/front/nid_front_screen.dart';


class EkycHomeScreen extends ConsumerStatefulWidget {
  const EkycHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EkycHomeScreen> createState() => _EkycHomeScreenState();
}

class _EkycHomeScreenState extends BaseConsumerState<EkycHomeScreen> {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final getStartedButton = SafeNextButtonWidget(
        text: "start_ekyc".tr(),
        onPressedFunction: () {

          ref.watch(camDirectionProvider.notifier).updateDirection(CamDirection.back);

          Navigator.push(context,
            MaterialPageRoute(builder: (context) =>const NidFrontScreen()),
          );

        }
    );


    return Scaffold(
      backgroundColor:  ekycHomeScreenBackground,
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'ekyc'),
      bottomSheet: getStartedButton,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width:  screenWidth*0.82,
              height: screenHeight*0.68,
              child: Card(
                shape:  const RoundedRectangleBorder(borderRadius: AppDimen.commonCircularBorderRadius),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(DimenSizes.dimen_12),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: SvgPicture.asset('assets/svg_files/ic_ekyc_home_page.svg')),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(DimenSizes.dimen_18, DimenSizes.dimen_2, DimenSizes.dimen_18, DimenSizes.dimen_10),
                      child: CustomCommonTextWidget(
                          text: "follow_these_steps".tr(),
                          style: CommonTextStyle.bold_16,
                          color: BrandingDataController.instance.branding.colors.primaryColor,
                          textAlign :  TextAlign.center,
                          shouldShowMultipleLine : true
                      ),
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          width: screenWidth*0.6,
                          height: screenHeight*0.07,
                          margin: DimenEdgeInset.marginLTRB_ekyc_home_screen_steps,
                          child: Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: AppDimen.commonCircularBorderRadius),
                            color: ekycHomeScreenSteps,
                            child: Padding(
                              padding: DimenEdgeInset.paddingLTRB_ekyc_home_screen_steps,
                              child: CustomCommonTextWidget(
                                  text: "take_picture_of_nid".tr(),
                                  style: CommonTextStyle.regular_12,
                                  color: colorPrimaryText,
                                  textAlign :  TextAlign.center,
                                  shouldShowMultipleLine : true
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius:  AppDimen.circleAvatarRadius,
                          backgroundColor: BrandingDataController.instance.branding.colors.primaryColor ,
                          child: CustomCommonTextWidget(
                              text: "_1".tr(),
                              style: CommonTextStyle.regular_12,
                              color: bottomNavBarBackgroundColor,
                              textAlign :  TextAlign.center,
                              shouldShowMultipleLine : true
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          width: screenWidth*0.6,
                          height: screenHeight*0.07,
                          margin: DimenEdgeInset.marginLTRB_ekyc_home_screen_steps,
                          child: Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: AppDimen.commonCircularBorderRadius),
                            color: ekycHomeScreenSteps,
                            child: Padding(
                              padding: DimenEdgeInset.paddingLTRB_ekyc_home_screen_steps,
                              child: CustomCommonTextWidget(
                                  text: "submit_info".tr(),
                                  style: CommonTextStyle.regular_12,
                                  color: colorPrimaryText,
                                  textAlign :  TextAlign.center,
                                  shouldShowMultipleLine : true
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius:  AppDimen.circleAvatarRadius,
                          backgroundColor: BrandingDataController.instance.branding.colors.primaryColor ,
                          child: CustomCommonTextWidget(
                              text: "_2".tr(),
                              style: CommonTextStyle.regular_12,
                              color: bottomNavBarBackgroundColor,
                              textAlign :  TextAlign.center,
                              shouldShowMultipleLine : true
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          width: screenWidth*0.6,
                          height: screenHeight*0.07,
                          margin: DimenEdgeInset.marginLTRB_ekyc_home_screen_steps,
                          child: Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: AppDimen.commonCircularBorderRadius),
                            color: ekycHomeScreenSteps,
                            child: Padding(
                              padding: DimenEdgeInset.paddingLTRB_ekyc_home_screen_steps,
                              child: CustomCommonTextWidget(
                                  text: "take_picture".tr(),
                                  style: CommonTextStyle.regular_12,
                                  color: colorPrimaryText,
                                  textAlign :  TextAlign.center,
                                  shouldShowMultipleLine : true
                              ),

                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius:  AppDimen.circleAvatarRadius,
                          backgroundColor: BrandingDataController.instance.branding.colors.primaryColor ,
                          child: CustomCommonTextWidget(
                              text: "_3".tr(),
                              style: CommonTextStyle.regular_12,
                              color: bottomNavBarBackgroundColor,
                              textAlign :  TextAlign.center,
                              shouldShowMultipleLine : true
                          ),
                        ),
                      ],
                    )
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
