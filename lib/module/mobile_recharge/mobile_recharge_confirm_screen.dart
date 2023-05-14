import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../ui/custom_widgets/custom_confirm_transaction_widget.dart';
import '../../utils/api_urls.dart';
import 'mobile_recharge_pin_screen.dart';

class MobileRechargeConfirmScreen extends ConsumerStatefulWidget {
  const MobileRechargeConfirmScreen({
    Key? key,
    required this.confirmDialogModel,
    required this.connectionType,
    required this.operator,
  }) : super(key: key);

  final CommonConfirmDialogModel confirmDialogModel;
  final String connectionType;
  final String operator;

  @override
  ConsumerState<MobileRechargeConfirmScreen> createState() => _MobileRechargeConfirmScreenState();
}

class _MobileRechargeConfirmScreenState extends BaseConsumerState<MobileRechargeConfirmScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CustomCommonAppBarWidget(appBarTitle: 'mobile_recharge'),
      body: CustomConfirmTransactionWidget(
        confirmDialogModel: CommonConfirmDialogModel(
            widget.confirmDialogModel.appBarTitle,
            widget.confirmDialogModel.transactionTitle,
            widget.confirmDialogModel.recipientSummary,
            widget.confirmDialogModel.transactionSummary,
            widget.confirmDialogModel.apiUrl
        ),
        messageString: "amazing_offers_msg".tr(),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  MobileRechargePinScreen(
                    confirmDialogModel: CommonConfirmDialogModel(
                        widget.confirmDialogModel.appBarTitle,
                        widget.confirmDialogModel.transactionTitle,
                        widget.confirmDialogModel.recipientSummary,
                        widget.confirmDialogModel.transactionSummary,
                        ApiUrls.sendMoneyApi
                    ),
                    connectionType: widget.connectionType,
                    operator: widget.operator,
                  )
              )
          );
        },
      ),
    );
  }
}