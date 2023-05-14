import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../ui/custom_widgets/custom_confirm_transaction_widget.dart';
import 'du_pin_screen.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 15,March,2023.

class DynamicUtilityConfirmScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;

  const DynamicUtilityConfirmScreen(this.confirmDialogModel, {Key? key}) : super(key: key);

  @override
  ConsumerState<DynamicUtilityConfirmScreen> createState() =>
      _DynamicUtilityConfirmScreenState();
}

class _DynamicUtilityConfirmScreenState
    extends BaseConsumerState<DynamicUtilityConfirmScreen> {
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
        messageString: "amazing_offers_msg".tr(),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>
              DynamicUtilityPinScreen(
                confirmDialogModel: widget.confirmDialogModel,
              ))
          );
        },
      ),
    );
  }
}
