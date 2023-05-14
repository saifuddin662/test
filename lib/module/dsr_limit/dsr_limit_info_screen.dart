import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../base/base_consumer_state.dart';
import '../../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/configs/branding_data_controller.dart';
import '../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/number_formatter.dart';
import '../../utils/styles.dart';
import 'api/dsr_limit_info_controller.dart';


class DsrLimitInfoListScreen extends ConsumerStatefulWidget {
  const DsrLimitInfoListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DsrLimitInfoListScreen> createState() => _DsrLimitInfoListScreenState();
}

class _DsrLimitInfoListScreenState extends BaseConsumerState<DsrLimitInfoListScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(dsrLimitInfoControllerProvider.notifier).getDsrLimitInfo();
    });
  }


  @override
  Widget build(BuildContext context) {

    final data = ref.watch(dsrLimitInfoControllerProvider);
    String topUpLimit = data.value?.data?.dsrDailyTopUp.toString() ?? "0";
    String cashOutLimit = data.value?.data?.dsrDailyCashOut.toString() ?? "0";

    ref.listen<AsyncValue>(
      dsrLimitInfoControllerProvider, (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
        } else {
          EasyLoading.dismiss();
        }
      },
    );

    return Scaffold(
        appBar: const CustomCommonAppBarWidget(appBarTitle: 'dsr_limit'),
        backgroundColor: commonBackgroundColor,
        body: (data.hasValue || data.isRefreshing) ?
        ListView(
          padding: AppDimen.commonAllSidePadding20,
          children: [
            CustomCommonTextWidget(
                text: "top_up_limit".tr(),
                style: CommonTextStyle.semiBold_18,
                color: colorPrimaryText,
                shouldShowMultipleLine : true
            ),
            const SizedBox(height: DimenSizes.dimen_10),
            Container(
              height: DimenSizes.dimen_150,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(DimenSizes.dimen_4))
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomCommonTextWidget(
                              text: "৳ ${data.value?.data?.dsrTopUpLimit}",
                              style: CommonTextStyle.semiBold_20,
                              color: BrandingDataController.instance.branding.colors.primaryColor
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: DimenSizes.dimen_1,
                      height: DimenSizes.dimen_90,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomCommonTextWidget(
                              text: "daily_top_up".tr(),
                              style: CommonTextStyle.regular_14,
                          ),
                          const SizedBox(height: 10.0),
                          CustomCommonTextWidget(
                              text: "৳ ${NumberFormatter.stringToDouble(topUpLimit)}",
                              style: CommonTextStyle.semiBold_18,
                              color: BrandingDataController.instance.branding.colors.primaryColor
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: DimenSizes.dimen_40),
            CustomCommonTextWidget(
                text: "cash_out_limit".tr(),
                style: CommonTextStyle.semiBold_18,
                color: colorPrimaryText,
                shouldShowMultipleLine : true
            ),
            const SizedBox(height: DimenSizes.dimen_10),
            Container(
              height: 150,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(DimenSizes.dimen_4))
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomCommonTextWidget(
                              text: "৳ ${data.value?.data?.dsrCashOutLimit}",
                              style: CommonTextStyle.semiBold_20,
                              color: BrandingDataController.instance.branding.colors.primaryColor
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 90,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomCommonTextWidget(
                            text: "daily_cash_out".tr(),
                            style: CommonTextStyle.regular_14,
                          ),
                          const SizedBox(height: 10.0),
                          CustomCommonTextWidget(
                              text: "৳ ${NumberFormatter.stringToDouble(cashOutLimit)}",
                              style: CommonTextStyle.semiBold_18,
                              color: BrandingDataController.instance.branding.colors.primaryColor
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ) :
        data.hasError ?
        Center(
          child: CustomCommonTextWidget(
              text: "${data.error}",
              style: CommonTextStyle.semiBold_18,
              color: colorPrimaryText,
              shouldShowMultipleLine : true
          ),
        ) :
        const SizedBox.shrink()
    );
  }
}