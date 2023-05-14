import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../module/dashboard/dashboard_screen.dart';
import '../../utils/colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/styles.dart';
import 'custom_common_text_widget.dart';

class CustomCommonErrorWidget extends StatelessWidget {

  final String errorTitle;
  final String errorMessage;
  final bool goHome;

  const CustomCommonErrorWidget({
    super.key,
    this.errorTitle = "Failed",
    required this.errorMessage,
    this.goHome = false,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        color: commonErrorColorLight,
        alignment: Alignment.center,
        width: screenWidth,
        height: screenHeight,
        padding: const EdgeInsets.only(top: DimenSizes.dimen_180, left: DimenSizes.dimen_20, right: DimenSizes.dimen_20, bottom: DimenSizes.dimen_180),
        child: Stack(
          children: [
            Center(
            child: Card(
              color: commonErrorDialogColor,
              shape:  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DimenSizes.dimen_20),
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: DimenSizes.dimen_40),
                    Align(
                      alignment: Alignment.topCenter,
                      child: SvgPicture.asset(
                        'assets/svg_files/ic_delete_user.svg',
                      ),
                    ),
                    const SizedBox(height: DimenSizes.dimen_30),
                    CustomCommonTextWidget(
                      text: errorTitle,
                      style: CommonTextStyle.semiBold_22,
                      color: commonCancelButtonColor,
                    ),
                   const SizedBox(height: DimenSizes.dimen_25),
                    Padding(
                      padding: const EdgeInsets.only(left: DimenSizes.dimen_18, right: DimenSizes.dimen_18,),
                      child: CustomCommonTextWidget(
                        text: errorMessage,
                        textAlign: TextAlign.center,
                        style: CommonTextStyle.regular_16,
                        color: commonCancelButtonColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
            Positioned(
              left: 4,
              right: 4,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(DimenSizes.dimen_20),
                      bottomRight: Radius.circular(DimenSizes.dimen_20)
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.transparent,
                      offset: Offset(1.1, 1.1),
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: Material(
                  elevation: 5.0,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(DimenSizes.dimen_20),
                      bottomRight: Radius.circular(DimenSizes.dimen_20)
                  ),
                  color: commonCancelButtonColor,

                  child: goHome == false?
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: AppDimen.commonButtonTextPadding,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(DimenSizes.dimen_20),
                          bottomRight: Radius.circular(DimenSizes.dimen_20)
                      ),
                    ),

                      child: CustomCommonTextWidget(
                          text: "Back",
                          style: CommonTextStyle.bold_14,
                          color: bottomNavBarBackgroundColor,
                          textAlign :  TextAlign.center,
                          shouldShowMultipleLine : true
                          ),
                      onPressed: () {
                          Navigator.of(context).pop();
                          }
                          ):
                  MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: AppDimen.commonButtonTextPadding,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(DimenSizes.dimen_20),
                            bottomRight: Radius.circular(DimenSizes.dimen_20)
                        ),
                      ),
                      child: CustomCommonTextWidget(
                          text: "Back To Home",
                          style: CommonTextStyle.bold_14,
                          color: bottomNavBarBackgroundColor,
                          textAlign :  TextAlign.center,
                          shouldShowMultipleLine : true
                      ),
                      onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DashboardScreen(),
                              ),
                              (route) => false);
                        }
                  )
                  ,
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}