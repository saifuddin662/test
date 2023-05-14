import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/base_consumer_state.dart';
import '../../common/common_api/check_balance/check_balance_controller.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../common/model/summary_details_item.dart';
import '../../common/toasts.dart';
import '../../core/di/core_providers.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../utils/number_formatter.dart';
import '../../utils/pref_keys.dart';
import '../dashboard/dashboard_screen.dart';
import 'du_confirm_screen.dart';
import 'du_core/model/utility_info_model.dart';
import 'du_core/widgets/utility_status_widget.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 14,March,2023.

class DynamicUtilityInfoScreen extends ConsumerStatefulWidget {
  final UtilityInfoModel utilityInfo;

  const DynamicUtilityInfoScreen(this.utilityInfo, {Key? key})
      : super(key: key);

  @override
  ConsumerState<DynamicUtilityInfoScreen> createState() =>
      _DynamicUtilityInfoScreenState();
}

class _DynamicUtilityInfoScreenState
    extends BaseConsumerState<DynamicUtilityInfoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(checkBalanceControllerProvider.notifier).checkBalance();
    });
  }

  @override
  Widget build(BuildContext context) {

    final currentBalance = ref.read(localPrefProvider).getDouble(PrefKeys.keyCheckBalance);
    final dueAmount = NumberFormatter.stringToDouble(widget.utilityInfo.dueAmount);

    var txnList = widget.utilityInfo.transactionSummary!.map((e) => SummaryDetailsItem(e.label!, e.value!)).toList();

    final CommonConfirmDialogModel confirmDialogModel =
        CommonConfirmDialogModel(
            widget.utilityInfo.utilityTitle,
            widget.utilityInfo.utilityTitle,
            [
              '',
              '৳ ${widget.utilityInfo.dueAmount}'
            ],
            txnList,
            widget.utilityInfo.logoUrl);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'utility_bill'),
      body: UtilityStatusWidget(
        utilityInfo: widget.utilityInfo,
      ),
      bottomSheet: SafeNextButtonWidget(
          text: widget.utilityInfo.isPaid ? "home".tr() : "next".tr(),
          onPressedFunction: () {
            if (widget.utilityInfo.isPaid) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardScreen()),
                  (route) => false);
            } else {
              if (currentBalance! < dueAmount) {
                Toasts.showErrorToast("insufficient_fund".tr());
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DynamicUtilityConfirmScreen(confirmDialogModel)));
              }
            }
          }),
    );
  }
}
