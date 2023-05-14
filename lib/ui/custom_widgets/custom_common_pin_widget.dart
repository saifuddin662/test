import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/styles.dart';
import '../configs/branding_data_controller.dart';
import 'common_title_with_divider.dart';
import 'custom_common_text_widget.dart';

class CustomConfirmPinWidget extends StatelessWidget {

  final CommonConfirmDialogModel confirmDialogModel;
  final TextEditingController pinController;
  final VoidCallback? onPressed;

  const CustomConfirmPinWidget({
    super.key,
    required this.confirmDialogModel,
    required this.pinController,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: BrandingDataController.instance.branding.colors.primaryColorLight,
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: const EdgeInsets.only(left: DimenSizes.dimen_20, right: DimenSizes.dimen_20),
          height: MediaQuery.of(context).size.height * AppDimen.dialogContentHeight,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(DimenSizes.dimen_10))
          ),
          child: Stack(
            children: [
              Positioned(
                top:0.0,
                right: 0.0,
                child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/svg_files/ic_cross.svg',
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/svg_files/ic_confirm_pin.svg',
                    height: MediaQuery.of(context).size.height * .10,
                    width: MediaQuery.of(context).size.width * .10,
                  ),
                  const SizedBox(height: DimenSizes.dimen_10),
                  CustomCommonTextWidget(
                      text:  confirmDialogModel.transactionTitle,
                      style: CommonTextStyle.bold_20,
                      color: BrandingDataController.instance.branding.colors.primaryColor,
                      textAlign :  TextAlign.center,
                  ),

                  const SizedBox(height: DimenSizes.dimen_10),
                  Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(DimenSizes.dimen_20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: CustomCommonTextWidget(
                              text: confirmDialogModel.recipientSummary[0],
                              textAlign: TextAlign.center,
                              style: CommonTextStyle.semiBold_16,
                              shouldShowMultipleLine: true,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: CustomCommonTextWidget(
                              text: confirmDialogModel.recipientSummary[1],
                              textAlign: TextAlign.center,
                              style: CommonTextStyle.semiBold_16,
                              shouldShowMultipleLine: true,
                            ),
                          )
                        ],
                      )
                  ),
                  const SizedBox(height: DimenSizes.dimen_20),
                  CommonTitleWihDivider(title: 'enter_pin'.tr()),
                  Container(
                    padding:  DimenEdgeInset.marginLTRB_confirmPin,
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      length: 4,
                      obscureText: true,
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderWidth: 1,
                        borderRadius: AppDimen.commonCircularBorderRadius,
                        fieldHeight: AppDimen.pinCodeTextFieldHeightWidth,
                        fieldWidth: AppDimen.pinCodeTextFieldHeightWidth,
                        activeFillColor: Colors.white,
                        activeColor: BrandingDataController.instance.branding.colors.primaryColor,
                        inactiveColor: unselectedFontColor,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: false,
                      controller: pinController,
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom + 100
                      ),
                      keyboardType: TextInputType.number,
                      onCompleted: (v) {
                      },
                      onTap: () {
                      },
                      onChanged: (value) {
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        return true;
                      },
                    ),
                  )
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(DimenSizes.dimen_8),
                        bottomRight: Radius.circular(DimenSizes.dimen_8)
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
                        bottomLeft: Radius.circular(DimenSizes.dimen_8),
                        bottomRight: Radius.circular(DimenSizes.dimen_8)
                    ),
                    color: BrandingDataController.instance.branding.colors.primaryColor,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: AppDimen.commonButtonTextPadding,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(DimenSizes.dimen_8),
                            bottomRight: Radius.circular(DimenSizes.dimen_8)
                        ),
                      ),
                      onPressed: onPressed,
                      child: CustomCommonTextWidget(
                          text: "confirm_pin".tr(),
                          style: CommonTextStyle.bold_14,
                          color: bottomNavBarBackgroundColor,
                          textAlign :  TextAlign.center,
                          shouldShowMultipleLine : true
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
