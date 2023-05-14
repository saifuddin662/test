import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../../base/base_consumer_state.dart';
import '../../../core/di/core_providers.dart';
import '../../../ui/configs/branding_data_controller.dart';
import '../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../../utils/Colors.dart';
import '../../../utils/dimens/dimensions.dart';
import '../../../utils/pref_keys.dart';
import '../../../utils/styles.dart';
import '../../dashboard/dashboard_screen.dart';


class CustomDeclineRequestSuccessWidget extends ConsumerStatefulWidget {

  final String userName;
  final String walletNumber;
  final String sendMoneyAmount;


  const CustomDeclineRequestSuccessWidget(this.userName, this.walletNumber, this.sendMoneyAmount,{
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CustomDeclineRequestSuccessWidget> createState() => _CustomDeclineRequestSuccessWidgetState();
}


class _CustomDeclineRequestSuccessWidgetState extends BaseConsumerState<CustomDeclineRequestSuccessWidget> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final userName = ref.read(localPrefProvider).getString(PrefKeys.keyUserName);
    final userWallet = ref.read(localPrefProvider).getString(PrefKeys.keyMsisdn);

    return WillPopScope(
      child: Scaffold(
        body: Container(
          color: BrandingDataController.instance.branding.colors.primaryColorLight,
          alignment: Alignment.center,
          width: screenWidth,
          padding: const EdgeInsets.only(top: DimenSizes.dimen_80, left: DimenSizes.dimen_20, right: DimenSizes.dimen_20, bottom: DimenSizes.dimen_100),
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: DimenSizes.dimen_30, bottom: DimenSizes.dimen_10),
                height: screenHeight * .7,
                child: Card(
                  shape:  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                  color: BrandingDataController.instance.branding.colors.primaryColor,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: DimenSizes.dimen_50),
                        SizedBox(
                          height: screenHeight * 0.07,
                          child: Column(
                            children: [
                              CustomCommonTextWidget(
                                text: "$userName",
                                style: CommonTextStyle.semiBold_14,
                                color: Colors.white,
                              ),
                              const SizedBox(height: DimenSizes.dimen_5),

                              CustomCommonTextWidget(
                                text:  "$userWallet",
                                style: CommonTextStyle.regular_14,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: greyColor,
                          height: DimenSizes.dimen_12,
                          thickness: DimenSizes.dimen_half,
                          indent: DimenSizes.dimen_2,
                          endIndent: DimenSizes.dimen_2,
                        ),

                        const SizedBox(height: DimenSizes.dimen_30),

                        SizedBox(
                          height: screenHeight * 0.35,
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/svg_files/ic_transaction_successful.svg',
                                height: MediaQuery.of(context).size.height * .06,
                                width: MediaQuery.of(context).size.width * .06,
                              ),
                              const SizedBox(height: DimenSizes.dimen_15),

                              Padding(
                                padding: const EdgeInsets.only(left:30, right: 30.0, top: 10, bottom: 10),
                                child: CustomCommonTextWidget(
                                  text: "decline_successful_msg".tr(),
                                  style: CommonTextStyle.semiBold_22,
                                  color: Colors.white,
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.01),

                              CustomCommonTextWidget(
                                text: "৳ ${widget.sendMoneyAmount}",
                                style: CommonTextStyle.semiBold_26,
                                color: Colors.white,
                              ),

                              SizedBox(height: screenHeight * 0.01),

                            //  const SizedBox(height: DimenSizes.dimen_10),

                              CustomCommonTextWidget(
                                text:  widget.userName,
                                style: CommonTextStyle.semiBold_16,
                                color: Colors.white,
                              ),

                              const SizedBox(height: DimenSizes.dimen_10),

                              CustomCommonTextWidget(
                                text:   "(${widget.walletNumber})",
                                style: CommonTextStyle.regular_14,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  'assets/svg_files/ic_first_cash_logo_successful.svg',
                ),
              ),
            ],
          ),
        ),
        bottomSheet: SafeNextButtonWidget(
            text: "back_to_home".tr(),
            onPressedFunction: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) => const DashboardScreen()
              ), (route) => false);
            }
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}