import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../module/education_fees/beneficiary/data/edu_fee_data_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/styles.dart';
import '../configs/branding_data_controller.dart';
import 'common_summary_item_tile.dart';
import 'common_title_with_divider.dart';
import 'custom_common_text_widget.dart';

class CustomConfirmTransactionWidget extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;
  final String messageString;
  final VoidCallback? onPressed;
  final bool isSaveEnabled;

  const CustomConfirmTransactionWidget({
    super.key,
    required this.confirmDialogModel,
    required this.messageString,
    required this.onPressed,
    this.isSaveEnabled = false,
  });

  @override
  BaseConsumerState<CustomConfirmTransactionWidget> createState() => _CustomConfirmTransactionWidgetState();
}

class _CustomConfirmTransactionWidgetState extends BaseConsumerState<CustomConfirmTransactionWidget> {

  bool isSaveChecked = false;

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
                    'assets/svg_files/ic_confirm_transaction.svg',
                    height: MediaQuery.of(context).size.height * .10,
                    width: MediaQuery.of(context).size.width * .10,
                  ),
                  const SizedBox(height: DimenSizes.dimen_10),
                  CustomCommonTextWidget(
                    text: widget.confirmDialogModel.transactionTitle,
                    style: CommonTextStyle.bold_22,
                    color: BrandingDataController.instance.branding.colors.primaryColor,
                  ),
                  Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(DimenSizes.dimen_10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: CustomCommonTextWidget(
                              text: widget.confirmDialogModel.recipientSummary[0],
                              textAlign: TextAlign.center,
                              style: CommonTextStyle.semiBold_16,
                              shouldShowMultipleLine: true,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: CustomCommonTextWidget(
                              text: widget.confirmDialogModel.recipientSummary[1],
                              textAlign: TextAlign.center,
                              style: CommonTextStyle.semiBold_16,
                              shouldShowMultipleLine: true,
                            ),
                          )
                        ],
                      )
                  ),
                  const SizedBox(height: DimenSizes.dimen_20),
                  (widget.isSaveEnabled && !EduFeeDataController.instance.fromSaved) ? Row(
                    children: <Widget>[
                      const SizedBox(width: 5), //SizedBox
                      Checkbox( //only check box
                          value: isSaveChecked, //unchecked
                          onChanged: (bool? value){
                            //value returned when checkbox is clicked
                            setState(() {
                              isSaveChecked = value!;
                              EduFeeDataController.instance.isSavedChecked = isSaveChecked;
                              log.info('checkbox value ---> $isSaveChecked');

                            });
                          }
                      ),
                      const SizedBox(
                        width: 0,
                      ), //SizedBox
                      CustomCommonTextWidget(
                        text: 'Save for later',
                        style: CommonTextStyle.regular_16,
                        color: colorPrimaryText,
                      ), //Text
                    ], //<Widget>[]
                  ) : const SizedBox(),
                  CommonTitleWihDivider(title: 'transaction_details'.tr()),
                  Container(
                    height: MediaQuery.of(context).size.height * .20,
                    margin: const EdgeInsets.fromLTRB(AppDimen.appMarginHorizontal, 0, AppDimen.appMarginHorizontal, 0),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 10/4
                      ),
                      itemCount: widget.confirmDialogModel.transactionSummary.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CommonSummaryItemTile(
                          title: widget.confirmDialogModel.transactionSummary[index].title,
                          subTitle: widget.confirmDialogModel.transactionSummary[index].description,
                        );
                      },
                    ),
                  ),
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
                      onPressed: widget.onPressed,
                      child: CustomCommonTextWidget(
                          text: "confirm".tr(),
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
