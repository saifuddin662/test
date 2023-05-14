import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../../base/base_consumer_state.dart';
import '../../../common/toasts.dart';
import '../../../ui/configs/branding_data_controller.dart';
import '../../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../utils/colors.dart';
import '../../../utils/date_time_formatter.dart';
import '../../../utils/dimens/app_dimens.dart';
import '../../../utils/dimens/dimensions.dart';
import '../../../utils/styles.dart';
import 'api/txn_list_controller.dart';


class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends BaseConsumerState<TransactionListScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(txnListControllerProvider.notifier).getTxnList();
    });
  }


  @override
  Widget build(BuildContext context) {
    final txnData = ref.watch(txnListControllerProvider);
    final txnList = txnData.value?.statement ?? [];
    return Scaffold(
        appBar: const CustomCommonAppBarWidget(
            appBarTitle: 'transaction_list',
            automaticallyImplyLeading: false
        ),
        body: SizedBox(
          child: txnData.isLoading ?
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListView.builder(
              padding: AppDimen.commonAllSidePadding20,
              itemBuilder: (_, __) => Container(
                height: 100,
                decoration: const BoxDecoration(
                  borderRadius: AppDimen.commonCircularBorderRadius,
                ),
                child: Card(
                  margin: const EdgeInsets.only(bottom: DimenSizes.dimen_20),
                  elevation: 1.0,
                  child: SvgPicture.asset('assets/svg_files/ic_placeholder.svg'),
                ),
              ),
              itemCount: 15,
            ),
          ) :
          txnList.isNotEmpty ?
          ListView.builder(
            padding: AppDimen.commonAllSidePadding20,
            itemCount: txnList.length,
            itemBuilder: (context, index) {
              final txn = txnList[index];
              return GestureDetector(
                onTap: () async {
                  HapticFeedback.mediumImpact();
                  Clipboard.setData(ClipboardData(text: txn.txCode??"")).then((_){
                    Toasts.showSuccessToast("txn_copied".tr());
                  });
                },
                child: Container(
                    margin: const EdgeInsets.only(bottom: DimenSizes.dimen_20),
                    padding: const EdgeInsets.only(
                        top: DimenSizes.dimen_8,
                        bottom: DimenSizes.dimen_8,
                        left: DimenSizes.dimen_12,
                        right: DimenSizes.dimen_12
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: BrandingDataController.instance.branding.colors.primaryColor,
                        width: DimenSizes.dimen_half,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(DimenSizes.dimen_4)),
                    ),
                    child: txn.actionType == "DEBIT" ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomCommonTextWidget(text: txn.typeName.toString(), style: CommonTextStyle.semiBold_14, color: BrandingDataController.instance.branding.colors.primaryColor),
                              const SizedBox(height: DimenSizes.dimen_4),
                              txn.receiverName == null ?
                              CustomCommonTextWidget(text: txn.receiverNumber.toString(), style: CommonTextStyle.regular_14, color: eclipse):
                              CustomCommonTextWidget(text: "${txn.receiverName} (${txn.receiverNumber})", style: CommonTextStyle.regular_14, color: eclipse),
                              const SizedBox(height: DimenSizes.dimen_3),
                              CustomCommonTextWidget(text: "Txn No: ${txn.txCode.toString()}", style: CommonTextStyle.regular_10, color: eclipse),
                              const SizedBox(height: DimenSizes.dimen_5),
                              CustomCommonTextWidget(text: CustomDateTimeFormatter.dateFormatter(txn.transactionDate), style: CommonTextStyle.regular_10, color: suvaGray),
                            ],
                          ),
                        ),
                        CustomCommonTextWidget(
                            text: " - ৳ ${txn.amount}",
                            style: CommonTextStyle.semiBold_16,
                            color: Colors.red
                        ),
                      ],
                    ) :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomCommonTextWidget(text: txn.typeName.toString(), style: CommonTextStyle.semiBold_14, color: BrandingDataController.instance.branding.colors.primaryColor),
                              const SizedBox(height: DimenSizes.dimen_4),
                              txn.senderNumber == null ?
                              CustomCommonTextWidget(text: txn.senderNumber.toString(), style: CommonTextStyle.regular_14, color: eclipse) :
                              CustomCommonTextWidget(text: "${txn.senderName} (${txn.senderNumber})", style: CommonTextStyle.regular_14, color: eclipse),
                              const SizedBox(height: DimenSizes.dimen_3),
                              CustomCommonTextWidget(text: "Txn No: ${txn.txCode.toString()}", style: CommonTextStyle.regular_10, color: eclipse),
                              const SizedBox(height: DimenSizes.dimen_5),
                              CustomCommonTextWidget(text: CustomDateTimeFormatter.dateFormatter(txn.transactionDate), style: CommonTextStyle.regular_10, color: suvaGray),
                            ],
                          ),
                        ),
                        CustomCommonTextWidget(
                            text: " + ৳ ${txn.amount}",
                            style: CommonTextStyle.semiBold_16,
                            color: BrandingDataController.instance.branding.colors.primaryColor
                        ),
                      ],
                    )
                ),
              );
            },
          ) :
          Center(
            child: CustomCommonTextWidget(
              text: "no_transaction_found".tr(),
              style: CommonTextStyle.regular_14,
              color: eclipse ,
            ),

          ),
        )
    );
  }
}