import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/base_consumer_state.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../ui/custom_widgets/custom_confirm_transaction_widget.dart';
import 'api/model/EducationFeesRequest.dart';
import 'education_fees_pin_screen.dart';


/// Created by Md. Awon-Uz-Zaman on 06/February/2023


class EducationFeesConfirmScreen extends ConsumerStatefulWidget {
  const EducationFeesConfirmScreen({
    Key? key,
    required this.confirmDialogModel,
    required this.schoolInfo
  }) : super(key: key);

  final CommonConfirmDialogModel confirmDialogModel;
  final SchoolPaymentInfo schoolInfo;

  @override
  ConsumerState<EducationFeesConfirmScreen> createState() => _EducationFeesConfirmScreenState();
}

class _EducationFeesConfirmScreenState extends BaseConsumerState<EducationFeesConfirmScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //saveEduTxnInfo();
    });
  }

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
        isSaveEnabled: true,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>
              EducationFeesPinScreen(
                confirmDialogModel: widget.confirmDialogModel,
                schoolInfo: widget.schoolInfo,
              ))
          );
        },
      ),
    );
  }
}