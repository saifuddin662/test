import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/send_money/send_money_pin_screen.dart';
import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../ui/custom_widgets/custom_confirm_transaction_widget.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_utils.dart';

class SendMoneyConfirmScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;

  const SendMoneyConfirmScreen({
    Key? key,
    required this.confirmDialogModel,
  }) : super(key: key);

  @override
  ConsumerState<SendMoneyConfirmScreen> createState() => _SendMoneyConfirmScreenState();
}

class _SendMoneyConfirmScreenState extends BaseConsumerState<SendMoneyConfirmScreen> {

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
        messageString: '',
        onPressed: () {
          AppUtils.hideKeyboard();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  SendMoneyPinScreen(
                    confirmDialogModel: CommonConfirmDialogModel(
                        widget.confirmDialogModel.appBarTitle,
                        widget.confirmDialogModel.transactionTitle,
                        widget.confirmDialogModel.recipientSummary,
                        widget.confirmDialogModel.transactionSummary,
                        ApiUrls.sendMoneyApi
                    ),
                  )
              )
          );
        },
      ),
    );
  }
}