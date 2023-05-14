import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/request_money/api/pay_request_money/pay_request_money_pin_screen.dart';
import '../../../../base/base_consumer_state.dart';
import '../../../../common/model/common_confirm_dialog_model.dart';
import '../../../../ui/custom_widgets/custom_confirm_transaction_widget.dart';
import '../../../../utils/api_urls.dart';
import '../../../../utils/app_utils.dart';


class PayRequestMoneyConfirmScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;
  final String requestId;
  final String transactionType;


  const PayRequestMoneyConfirmScreen(this.requestId, this.transactionType, {
    Key? key,
    required this.confirmDialogModel,
  }) : super(key: key);

  @override
  ConsumerState<PayRequestMoneyConfirmScreen> createState() => _PayRequestMoneyConfirmScreenState();
}

class _PayRequestMoneyConfirmScreenState extends BaseConsumerState<PayRequestMoneyConfirmScreen> {

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
                  PayRequestMoneyPinScreen(
                    confirmDialogModel: CommonConfirmDialogModel(
                        widget.confirmDialogModel.appBarTitle,
                        widget.confirmDialogModel.transactionTitle,
                        widget.confirmDialogModel.recipientSummary,
                        widget.confirmDialogModel.transactionSummary,
                        ApiUrls.payMoneyApi
                    ),
                    widget.requestId,
                    widget.transactionType
                  )
              )
          );
        },
      ),
    );
  }
}