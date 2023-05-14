import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../ui/custom_widgets/custom_confirm_transaction_widget.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_utils.dart';
import 'agent_cash_out_pin_screen.dart';

class AgentCashOutConfirmScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;

  const AgentCashOutConfirmScreen({
    Key? key,
    required this.confirmDialogModel,
  }) : super(key: key);

  @override
  ConsumerState<AgentCashOutConfirmScreen> createState() => _AgentCashOutConfirmScreenState();
}

class _AgentCashOutConfirmScreenState extends BaseConsumerState<AgentCashOutConfirmScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: CustomConfirmTransactionWidget(
        confirmDialogModel: CommonConfirmDialogModel(
            widget.confirmDialogModel.appBarTitle,
            widget.confirmDialogModel.transactionTitle,
            widget.confirmDialogModel.recipientSummary,
            widget.confirmDialogModel.transactionSummary,
            widget.confirmDialogModel.apiUrl
        ),
        onPressed: () {
          AppUtils.hideKeyboard();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  AgentCashOutPinScreen(
                    confirmDialogModel: CommonConfirmDialogModel(
                        widget.confirmDialogModel.appBarTitle,
                        widget.confirmDialogModel.transactionTitle,
                        widget.confirmDialogModel.recipientSummary,
                        widget.confirmDialogModel.transactionSummary,
                        ApiUrls.agentCashOut
                    ),
                  )));
        },
        messageString: "lowest_cash_out_charge_msg".tr(),
      ),
    );
  }
}