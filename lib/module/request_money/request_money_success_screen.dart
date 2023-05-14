import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import 'Widgets/custom_request_money_success_widget.dart';

class RequestMoneySuccessScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;
  final String? apiMessage;

  const RequestMoneySuccessScreen({
    Key? key,
    required this.confirmDialogModel,
    this.apiMessage
  }) : super(key: key);

  @override
  ConsumerState<RequestMoneySuccessScreen> createState() => _RequestMoneySuccessScreenState();
}

class _RequestMoneySuccessScreenState extends BaseConsumerState<RequestMoneySuccessScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: CustomRequestMoneySuccessWidget(
            title: "request_money",
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