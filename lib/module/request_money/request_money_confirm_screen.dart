import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/request_money/request_money_pin_screen.dart';
import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_utils.dart';
import 'Widgets/custom_confirm_requested_money_widget.dart';

class RequestMoneyConfirmScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;
  final String requesterName;
  final String receiverName;

  const RequestMoneyConfirmScreen( this.requesterName, this.receiverName,{
    Key? key,
    required this.confirmDialogModel,
  }) : super(key: key);

  @override
  ConsumerState<RequestMoneyConfirmScreen> createState() => _RequestMoneyConfirmScreenState();
}

class _RequestMoneyConfirmScreenState extends BaseConsumerState<RequestMoneyConfirmScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomConfirmRequestedMoneyWidget(
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
                  RequestMoneyPinScreen(
                    confirmDialogModel: CommonConfirmDialogModel(
                        widget.confirmDialogModel.appBarTitle,
                        widget.confirmDialogModel.transactionTitle,
                        widget.confirmDialogModel.recipientSummary,
                        widget.confirmDialogModel.transactionSummary,
                        ApiUrls.makeRequestApi
                    ),
                      widget.requesterName,
                      widget.receiverName,
                  )
              )
          );
        },
      ),
    );
  }
}