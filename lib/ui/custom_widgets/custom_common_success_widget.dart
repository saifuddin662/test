import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../../common/model/common_confirm_dialog_model.dart';
import '../../base/base_consumer_state.dart';
import '../../core/di/core_providers.dart';
import '../../module/dashboard/dashboard_screen.dart';
import '../../module/statements/core/pdf_services.dart';
import '../../module/statements/education_fees/data/statement_edu_data_controller.dart';
import '../../module/statements/education_fees/model/statement_edu_info_model.dart';
import '../../module/statements/education_fees/service/statement_edu_service.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/pref_keys.dart';
import '../../utils/styles.dart';
import '../configs/branding_data_controller.dart';
import 'custom_common_text_widget.dart';
import 'custom_safe_next_button.dart';
import 'custom_transaction_successful_background_widget.dart';


class CustomCommonSuccessWidget extends ConsumerStatefulWidget {

  final String title;
  final CommonConfirmDialogModel confirmDialogModel;
  final String? apiMessage;
  final bool hasStatement;

  const CustomCommonSuccessWidget({
    Key? key,
    required this.title, required
    this.confirmDialogModel,
    this.apiMessage,
    this.hasStatement = false,
  }) : super(key: key);

  @override
  ConsumerState<CustomCommonSuccessWidget> createState() => _CustomCommonSuccessWidgetState();
}


class _CustomCommonSuccessWidgetState extends BaseConsumerState<CustomCommonSuccessWidget> {
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
                                  text: "transaction_successful".tr(),
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

                          widget.hasStatement ? Container(
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
                              color: downloadStatementButton,
                              child: MaterialButton(
                                minWidth: MediaQuery.of(context).size.width,
                                padding: AppDimen.commonButtonTextPadding,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(DimenSizes.dimen_8),
                                      bottomRight: Radius.circular(DimenSizes.dimen_8)
                                  ),
                                ),
                                onPressed: () async {
                                  final eduStatementData =
                                  StatementEduInfoModel(
                                      title: 'Education Fees',
                                      insCode: 0, //currently not used
                                      amount: 'BDT ${StatementEduDataController.instance.eduInfo.amount}',
                                      regId: StatementEduDataController.instance.eduInfo.regId,
                                      insName: StatementEduDataController.instance.eduInfo.insName,
                                      studentName: StatementEduDataController.instance.eduInfo.studentName,
                                      txnId: StatementEduDataController.instance.eduInfo.txnId,
                                      txnDate: '01 April, 2023',//currently not used
                                      charge: 'BDT ${StatementEduDataController.instance.eduInfo.charge}',
                                      totalPaid: '0'); //currently not used

                                  final pdfFile = await StatementEduService.generateStatement(eduStatementData);
                                  debugPrint(pdfFile.path);
                                  PdfServices.openFile(pdfFile);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.download,
                                    color : Colors.white,
                                    size: 20.0),
                                    const SizedBox(width: 8),
                                    CustomCommonTextWidget(
                                        text: 'download_statement'.tr(),
                                        style: CommonTextStyle.bold_14,
                                        color: bottomNavBarBackgroundColor,
                                        textAlign :  TextAlign.center,
                                        shouldShowMultipleLine : true
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ) : const SizedBox(height: 0),
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