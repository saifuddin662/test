/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 15,March,2023.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:red_cash_dfs_flutter/common/constants.dart';
import 'package:red_cash_dfs_flutter/ui/custom_widgets/common_summary_item_tile.dart';
import 'package:red_cash_dfs_flutter/ui/custom_widgets/common_title_with_divider.dart';
import 'package:red_cash_dfs_flutter/ui/custom_widgets/custom_common_feature_top_item_widget.dart';
import 'package:red_cash_dfs_flutter/utils/dimens/app_dimens.dart';
import '../../../../ui/configs/branding_data_controller.dart';
import '../../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../../utils/Colors.dart';
import '../../../../utils/dimens/dimensions.dart';
import '../../../../utils/number_formatter.dart';
import '../../../../utils/styles.dart';
import '../model/utility_info_model.dart';

class UtilityStatusWidget extends StatelessWidget {
  final UtilityInfoModel utilityInfo;

  const UtilityStatusWidget({
    super.key,
    required this.utilityInfo,
  });

  @override
  Widget build(BuildContext context) {
    double amount = NumberFormatter.parseOnlyDouble(utilityInfo.dueAmount);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: AppDimen.appMarginHorizontal,
                top: DimenSizes.dimen_10,
                right: AppDimen.gapBetweenTextField,
                bottom: 0.0),
            child: CustomCommonFeatureTopItemWidget(
                networkSvgImage: false,
                iconUrl: utilityInfo.logoUrl,
                title: utilityInfo.utilityTitle),
          ),
          Container(
              height: DimenSizes.dimen_150,
              padding: const EdgeInsets.fromLTRB(
                  DimenSizes.dimen_20,
                  DimenSizes.dimen_10,
                  DimenSizes.dimen_20,
                  DimenSizes.dimen_10),
              child: (amount <= 0)
                  ? SvgPicture.asset(
                      'assets/svg_files/ic_bill_already_paid_common.svg',
                      height: DimenSizes.dimen_120,
                      width: DimenSizes.dimen_120)
                  : SvgPicture.asset('assets/svg_files/bill_unpaid.svg',
                      height: DimenSizes.dimen_120,
                      width: DimenSizes.dimen_120)),
          Column(
            children: [
              CustomCommonTextWidget(
                text:
                    utilityInfo.isPaid ? Constants.notFound : Constants.unpaid,
                style: CommonTextStyle.bold_20,
                color: utilityInfo.isPaid ? BrandingDataController.instance.branding.colors.primaryColor : Colors.red,
              ),
              const SizedBox(height: DimenSizes.dimen_10),
              Visibility(
                visible: (amount > 0),
                child: Column(
                  children: [
                    CustomCommonTextWidget(
                      text: "${'total_due'.tr()}: ৳ ${utilityInfo.dueAmount}",
                      style: CommonTextStyle.regular_16,
                      color: colorPrimaryText,
                    ),
                    CustomCommonTextWidget(
                      text:
                          "${'current_balance'.tr()}: ৳ ${utilityInfo.currentBalance}",
                      style: CommonTextStyle.regular_16,
                      color: colorPrimaryText,
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: DimenSizes.dimen_20),
          Visibility(
              visible: (amount > 0),
              child: CommonTitleWihDivider(title: 'transaction_details'.tr())),
          (amount <= 0) ? showPaid() : showUnpaid(context)
        ],
      ),
    );
  }

  Column showPaid() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        utilityInfo.transactionSummary!.length,
        (index) => Card(
          margin: const EdgeInsets.only(
              left: DimenSizes.dimen_20,
              right: DimenSizes.dimen_20,
              bottom: DimenSizes.dimen_10),
          child: CustomCommonTextWidget(
              text:
                  "${utilityInfo.transactionSummary![index].label} : ${utilityInfo.transactionSummary![index].value}"
                      .tr(),
              style: CommonTextStyle.regular_14,
              color: eclipse),
        ),
      ),
    );
  }

  SingleChildScrollView showUnpaid(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .30,
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 8 / 3),
          itemCount: utilityInfo.transactionSummary!.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return CommonSummaryItemTile(
              title: utilityInfo.transactionSummary![index].label!,
              subTitle: utilityInfo.transactionSummary![index].value!,
            );
          },
        ),
      ),
    );
  }
}
