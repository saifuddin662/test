import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../../base/base_consumer_state.dart';
import '../../../common/model/common_confirm_dialog_model.dart';
import '../../../core/di/core_providers.dart';
import '../../../ui/configs/branding_data_controller.dart';
import '../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../../ui/custom_widgets/custom_transaction_successful_background_widget.dart';
import '../../../utils/Colors.dart';
import '../../../utils/dimens/dimensions.dart';
import '../../../utils/pref_keys.dart';
import '../../../utils/styles.dart';
import '../../dashboard/dashboard_screen.dart';



class CustomRequestMoneySuccessWidget extends ConsumerStatefulWidget {

  final String title;
  final CommonConfirmDialogModel confirmDialogModel;
  final String? apiMessage;
  final bool hasStatement;

  const CustomRequestMoneySuccessWidget({
    Key? key,
    required this.title, required
    this.confirmDialogModel,
    this.apiMessage,
    this.hasStatement = false,
  }) : super(key: key);

  @override
  ConsumerState<CustomRequestMoneySuccessWidget> createState() => _CustomRequestMoneySuccessWidgetState();
}


class _CustomRequestMoneySuccessWidgetState extends BaseConsumerState<CustomRequestMoneySuccessWidget> {
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
                height: screenHeight * .80,
                child: CustomPaint(
                  painter: CustomTransactionSuccessfulBackgroundWidget(
                    borderColor: Colors.white,
                    bgColor: BrandingDataController.instance.branding.colors.primaryColor,
                  ),
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
                        const SizedBox(height: DimenSizes.dimen_10),
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

                              CustomCommonTextWidget(
                                text: "request_successful".tr(),
                                style: CommonTextStyle.semiBold_22,
                                color: Colors.white,
                              ),

                              SizedBox(height: screenHeight * 0.01),

                              CustomCommonTextWidget(
                                text: widget.confirmDialogModel.transactionSummary[0].description,
                                style: CommonTextStyle.semiBold_26,
                                color: Colors.white,
                              ),

                              SizedBox(height: screenHeight * 0.01),


                              CustomCommonTextWidget(
                                text: widget.confirmDialogModel.transactionTitle,
                                style: CommonTextStyle.regular_14,
                                color: Colors.white,
                              ),

                              const SizedBox(height: DimenSizes.dimen_10),

                              CustomCommonTextWidget(
                                text:  widget.confirmDialogModel.recipientSummary[0],
                                style: CommonTextStyle.semiBold_16,
                                color: Colors.white,
                              ),

                              const SizedBox(height: DimenSizes.dimen_10),

                              CustomCommonTextWidget(
                                text:   "(${widget.confirmDialogModel.recipientSummary[1]})",
                                style: CommonTextStyle.regular_14,
                                color: Colors.white,
                              ),
                              const SizedBox(height: DimenSizes.dimen_10),

                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(10.0),
                            child: CustomCommonTextWidget(
                                text: widget.apiMessage.toString().tr(),
                                style: CommonTextStyle.regular_14,
                                color:bottomNavBarBackgroundColor,
                                textAlign :  TextAlign.center,
                                shouldShowMultipleLine : true
                            ),
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