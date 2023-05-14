import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../ui/custom_widgets/custom_common_success_widget.dart';

/// Created by Md. Awon-Uz-Zaman on 12/February/2023



class MobileRechargeSuccessScreen extends ConsumerStatefulWidget {

  final CommonConfirmDialogModel confirmDialogModel;
  final String? apiMessage;

  const MobileRechargeSuccessScreen({
    Key? key,
    required this.confirmDialogModel,
    this.apiMessage
  }) : super(key: key);

  @override
  ConsumerState<MobileRechargeSuccessScreen> createState() => _MobileRechargeSuccessScreenState();
}

class _MobileRechargeSuccessScreenState extends BaseConsumerState<MobileRechargeSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomCommonSuccessWidget(
        title: "mobile_recharge".tr(),
        apiMessage: widget.apiMessage,
        confirmDialogModel: CommonConfirmDialogModel(
            widget.confirmDialogModel.appBarTitle,
            widget.confirmDialogModel.transactionTitle,
            widget.confirmDialogModel.recipientSummary,
            widget.confirmDialogModel.transactionSummary,
            widget.confirmDialogModel.apiUrl
        ),
      ),
    );
  }
}