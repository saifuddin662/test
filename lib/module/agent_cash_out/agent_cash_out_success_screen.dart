import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../ui/custom_widgets/custom_common_success_widget.dart';

class AgentCashOutSuccessScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;
  final String? apiMessage;

  const AgentCashOutSuccessScreen({
    Key? key,
    required this.confirmDialogModel,
    this.apiMessage
  }) : super(key: key);

  @override
  ConsumerState<AgentCashOutSuccessScreen> createState() => _AgentCashOutSuccessScreenState();
}

class _AgentCashOutSuccessScreenState extends BaseConsumerState<AgentCashOutSuccessScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: CustomCommonSuccessWidget(
            title: "cash_out_money".tr(),
            apiMessage: widget.apiMessage,
            confirmDialogModel: CommonConfirmDialogModel(
                widget.confirmDialogModel.appBarTitle,
                widget.confirmDialogModel.transactionTitle,
                widget.confirmDialogModel.recipientSummary,
                widget.confirmDialogModel.transactionSummary,
                widget.confirmDialogModel.apiUrl
            ),
          ),
        )
    );
  }
}