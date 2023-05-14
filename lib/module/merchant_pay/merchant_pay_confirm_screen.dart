import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../ui/custom_widgets/custom_confirm_transaction_widget.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_utils.dart';
import 'merchant_pay_pin_screen.dart';

class MerchantPayConfirmScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;

  const MerchantPayConfirmScreen({
    Key? key,
    required this.confirmDialogModel,
  }) : super(key: key);

  @override
  ConsumerState<MerchantPayConfirmScreen> createState() => _MerchantPayConfirmScreenState();
}

class _MerchantPayConfirmScreenState extends BaseConsumerState<MerchantPayConfirmScreen> {

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
                  MerchantPayPinScreen(
                    confirmDialogModel: CommonConfirmDialogModel(
                        widget.confirmDialogModel.appBarTitle,
                        widget.confirmDialogModel.transactionTitle,
                        widget.confirmDialogModel.recipientSummary,
                        widget.confirmDialogModel.transactionSummary,
                        ApiUrls.merchantPayApi
                    ),
                  )));
        },
        messageString: "you_can_pay_and_win".tr(),
      ),
    );
  }
}