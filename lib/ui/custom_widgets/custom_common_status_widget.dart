import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../base/base_consumer_state.dart';
import '../../common/constants.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../core/di/core_providers.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/number_formatter.dart';
import '../../utils/pref_keys.dart';
import '../../utils/styles.dart';
import '../configs/branding_data_controller.dart';
import 'common_summary_item_tile.dart';
import 'common_title_with_divider.dart';
import 'custom_common_feature_top_item_widget.dart';
import 'custom_common_text_widget.dart';

class CustomCommonStatusWidget extends ConsumerStatefulWidget {
  final CommonConfirmDialogModel confirmDialogModel;
  final String status;
  final String imageUrl;

  const CustomCommonStatusWidget({
    super.key,
    required this.status,
    required this.confirmDialogModel,
    required this.imageUrl,
  });

  @override
  ConsumerState<CustomCommonStatusWidget> createState() => _CustomCommonStatusWidgetState();
}

class _CustomCommonStatusWidgetState extends BaseConsumerState<CustomCommonStatusWidget> {
  @override
  Widget build(BuildContext context) {

    double amount = NumberFormatter.parseOnlyDouble(widget.confirmDialogModel.recipientSummary[1]);
    final currentBalance = ref.read(localPrefProvider).getDouble(PrefKeys.keyCheckBalance);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: AppDimen.appMarginHorizontal,top: DimenSizes.dimen_10,right: AppDimen.gapBetweenTextField,bottom: 0.0),
            child: CustomCommonFeatureTopItemWidget(
                networkSvgImage: true,
                iconUrl: widget.imageUrl,
                title: widget.confirmDialogModel.recipientSummary[0]
            ),
          ),
          Container(
              height: DimenSizes.dimen_150,
              padding: const EdgeInsets.fromLTRB(DimenSizes.dimen_20, DimenSizes.dimen_10, DimenSizes.dimen_20, DimenSizes.dimen_10),
              child: (amount <= 0) ? SvgPicture.asset(
                  'assets/svg_files/ic_bill_already_paid_common.svg',
                  height: DimenSizes.dimen_120,
                  width: DimenSizes.dimen_120
              ) : SvgPicture.asset('assets/svg_files/bill_unpaid.svg', height: DimenSizes.dimen_120, width: DimenSizes.dimen_120)
          ),
          Column(
            children: [
              CustomCommonTextWidget(
                text: widget.status,
                style: CommonTextStyle.bold_20,
                color: widget.status == Constants.unpaid ? Colors.red : BrandingDataController.instance.branding.colors.primaryColor,
              ),
              const SizedBox(height: DimenSizes.dimen_10),
              Visibility(
                visible: (amount > 0),
                child: Column(
                  children: [
                    CustomCommonTextWidget(
                      text: "${'total_due'.tr()}: ${widget.confirmDialogModel.transactionSummary[2].description}",
                      style: CommonTextStyle.regular_16,
                      color: colorPrimaryText,
                    ),
                    CustomCommonTextWidget(
                      text: "${'current_balance'.tr()}: $currentBalance",
                      style: CommonTextStyle.regular_16,
                      color: colorPrimaryText,
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: DimenSizes.dimen_20),
          Visibility(visible: (amount > 0),
              child: CommonTitleWihDivider(title: 'transaction_details'.tr())
          ),
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
        widget.confirmDialogModel.transactionSummary.length,
        (index) => Card(
          margin: const EdgeInsets.only(left: DimenSizes.dimen_20, right: DimenSizes.dimen_20, bottom: DimenSizes.dimen_10),
          child: CustomCommonTextWidget(
              text: "${widget.confirmDialogModel.transactionSummary[index].title} : ${widget.confirmDialogModel.transactionSummary[index].description}".tr(),
              style: CommonTextStyle.regular_14,
              color: eclipse
          ),
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
          itemCount: widget.confirmDialogModel.transactionSummary.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return CommonSummaryItemTile(
              title: widget.confirmDialogModel.transactionSummary[index].title,
              subTitle: widget.confirmDialogModel.transactionSummary[index].description,
            );
          },
        ),
      ),
    );
  }
}
