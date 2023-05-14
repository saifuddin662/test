import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:red_cash_dfs_flutter/module/request_money/request_money_core/enum/transaction_status_type.dart';
import 'package:red_cash_dfs_flutter/module/request_money/request_money_number_screen.dart';
import 'package:red_cash_dfs_flutter/module/request_money/widgets/custom_decline_request_success_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../../../base/base_consumer_state.dart';
import '../../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../common/common_api/check_balance/check_balance_controller.dart';
import '../../common/common_api/get_transaction_fee/model/transaction_fee_request.dart';
import '../../common/common_api/get_transaction_fee/transaction_fee_controller.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../common/model/summary_details_item.dart';
import '../../common/toasts.dart';
import '../../core/di/core_providers.dart';
import '../../core/di/feature_details_singleton.dart';
import '../../ui/configs/branding_data_controller.dart';
import '../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../utils/Colors.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_utils.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/feature_details_keys.dart';
import '../../utils/number_formatter.dart';
import '../../utils/pref_keys.dart';
import '../../utils/styles.dart';
import 'api/decline_request_money/decline_request_money_controller.dart';
import 'api/get_all_requests/get_all_requests_controller.dart';
import 'api/get_all_requests/model/get_all_requests_response.dart';
import 'api/pay_request_money/pay_request_money_confirm_screen.dart';


class RequestMoneyScreen extends ConsumerStatefulWidget {

  const RequestMoneyScreen(
      this.getAllRequestsResponse,  {Key? key}) : super(key: key);

  final GetAllRequestsResponse getAllRequestsResponse;

  @override
  ConsumerState<RequestMoneyScreen> createState() => _RequestMoneyScreenState();
}

class _RequestMoneyScreenState extends BaseConsumerState<RequestMoneyScreen> {

  FeatureDetailsSingleton featureDetailsSingleton = FeatureDetailsSingleton();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(checkBalanceControllerProvider.notifier).checkBalance();
    });
  }

  @override
  Widget build(BuildContext context) {
     final allRequestsData = ref.watch(getAllRequestsControllerProvider);
     final currentBalance = ref.read(localPrefProvider).getString(PrefKeys.keyUserBalance);
     final transactionType = featureDetailsSingleton.feature[FeatureDetailsKeys.requestMoney]?.transactionType;
     var sendMoneyAmount = '0';
     var userName = '';
     var walletNumber = '';
     var requestId = '';

     ref.listen<AsyncValue>(
       transactionFeeControllerProvider,
           (previousState, currentState) async {
         if (currentState.isLoading || currentState.isRefreshing) {
           EasyLoading.show();
         } else if (currentState.hasError) {
           EasyLoading.dismiss();
           Toasts.showErrorToast("${currentState.error}");
         } else {
           EasyLoading.dismiss();
           log.info("got fee charge response");

           (NumberFormatter.stringToDouble(currentBalance.toString())
               - NumberFormatter.stringToDouble(sendMoneyAmount)
               - NumberFormatter.stringToDouble(currentState.value.chargeAmount.toString())).isNegative ?

           Toasts.showErrorToast("insufficient_fund".tr()) :

           Navigator.push(context, MaterialPageRoute(builder: (context) =>
               PayRequestMoneyConfirmScreen(
                 confirmDialogModel: CommonConfirmDialogModel(
                     "send_money".tr(),
                     "send_money".tr(),
                     [
                       userName,
                       walletNumber
                     ],
                     [
                       SummaryDetailsItem(
                           "transaction_amount".tr(),
                           "৳ ${(NumberFormatter.stringToDouble(sendMoneyAmount))}"
                       ),
                       SummaryDetailsItem(
                           "new_balance".tr(),
                           "৳ ${(NumberFormatter.stringToDouble(currentBalance.toString())
                               - NumberFormatter.stringToDouble(sendMoneyAmount)
                               - NumberFormatter.stringToDouble(currentState.value.chargeAmount.toString()))}"
                       ),
                       SummaryDetailsItem(
                           "charge".tr(),
                           "৳ ${NumberFormatter.stringToDouble(currentState.value.chargeAmount.toString())}"
                       ),
                       SummaryDetailsItem(
                           "total_amount".tr(),
                           "৳ ${(NumberFormatter.stringToDouble(currentState.value.chargeAmount.toString()) + NumberFormatter.stringToDouble(sendMoneyAmount))}"
                       )
                     ],
                     ApiUrls.payMoneyApi
                 ),
                   requestId,
                   transactionType!

               )));
         }
       },
     );

     ref.listen<AsyncValue>(
       declineRequestMoneyControllerProvider,
           (previousState, currentState) async {
         if (currentState.isLoading || currentState.isRefreshing) {
           EasyLoading.show();
         } else if (currentState.hasError) {
           EasyLoading.dismiss();
           Toasts.showErrorToast("${currentState.error}");
         } else {
           EasyLoading.dismiss();

           log.info('got decline money request response');

           if (currentState.value != null) {
             Navigator.push(
               context,
               MaterialPageRoute(
                   builder: (context) =>  CustomDeclineRequestSuccessWidget(
                       userName, walletNumber,sendMoneyAmount
                     )));
           }
           else {
             Toasts.showErrorToast("currently_unavailable".tr());
           }
         }
       },
     );


    return  Scaffold(
      backgroundColor: commonBackgroundColor ,
      appBar: const CustomCommonAppBarWidget(appBarTitle: "request_money"),
      body:  SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

          const SizedBox(height: DimenSizes.dimen_20),

          Container(
              alignment: Alignment.center,
              child: SafeNextButtonWidget(
                text: 'new_request'.tr(),
                onPressedFunction: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RequestMoneyNumberScreen()),
                  );
                },
              ),
          ),

          const SizedBox(height: DimenSizes.dimen_10),

          Container(
            padding: AppDimen.commonLeftRightPadding,
              child: CustomCommonTextWidget(text: 'transactions'.tr(), style: CommonTextStyle.regular_18, color: colorPrimaryText, textAlign: TextAlign.left)
          ),

          const SizedBox(height: DimenSizes.dimen_12),

          SizedBox(
            height: DimenSizes.dimen_600,
            child: Card(
              color: bottomNavBarBackgroundColor,
              margin: const EdgeInsets.all(0),
              child: DefaultTabController(
                  length: 2, // length of tabs
                  initialIndex: 0,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                    TabBar(
                      padding: const EdgeInsets.only(top: DimenSizes.dimen_10),
                      labelColor: Colors.black,
                      unselectedLabelColor: unselectedFontColor,
                      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      tabs: [
                        Tab(text: 'your_request'.tr()),
                        Tab(text: 'request_to_you'.tr()),
                      ],
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height*0.6, //height of TabBarView
                        child: TabBarView(children: <Widget>[
                          allRequestsData.isLoading? Shimmer.fromColors(
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
                            ):
                            widget.getAllRequestsResponse.outgoingRequest!.isNotEmpty ?
                            ListView.builder(
                              padding: AppDimen.commonAllSidePadding20,
                              itemCount: widget.getAllRequestsResponse.outgoingRequest!.length,
                              itemBuilder: (context, index) {
                                final outgoing = widget.getAllRequestsResponse.outgoingRequest![index];
                                return GestureDetector(
                                  onTap: () async {
                                    HapticFeedback.mediumImpact();
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
                                    child: outgoing.transactionStatus == TransactionStatusType.Pending.name ?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomCommonTextWidget(text: outgoing.receiverName.toString(), style: CommonTextStyle.regular_16, color: BrandingDataController.instance.branding.colors.primaryColor),
                                              const SizedBox(height: DimenSizes.dimen_5),
                                              CustomCommonTextWidget(text: outgoing.requestTo.toString(), style: CommonTextStyle.regular_14, color: colorPrimaryText),
                                              const SizedBox(height: DimenSizes.dimen_5),
                                              CustomCommonTextWidget(text: outgoing.requestDateTime.toString(), style: CommonTextStyle.regular_10, color: suvaGray),
                                          ],
                                        ),
                                      ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomCommonTextWidget(
                                                text: "${outgoing.transactionStatus}",
                                                style: CommonTextStyle.semiBold_14,
                                                color: pendingStatus
                                            ),
                                            const SizedBox(height: 20),
                                            CustomCommonTextWidget(
                                                text: "৳ ${outgoing.requestedAmount}",
                                                style: CommonTextStyle.semiBold_12,
                                                color: colorPrimaryText
                                            ),
                                          ],
                                        ),
                                      ],
                                    ):
                                    outgoing.transactionStatus == TransactionStatusType.Declined.name?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomCommonTextWidget(text: outgoing.receiverName.toString(), style: CommonTextStyle.regular_16, color: BrandingDataController.instance.branding.colors.primaryColor),
                                              const SizedBox(height: DimenSizes.dimen_5),
                                              CustomCommonTextWidget(text: outgoing.requestTo.toString(), style: CommonTextStyle.regular_14, color: colorPrimaryText),
                                              const SizedBox(height: DimenSizes.dimen_5),
                                              CustomCommonTextWidget(text: outgoing.requestDateTime.toString(), style: CommonTextStyle.regular_10, color: suvaGray),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomCommonTextWidget(
                                                text: "${outgoing.transactionStatus}",
                                                style: CommonTextStyle.semiBold_14,
                                                color: canceledStatus
                                            ),
                                            const SizedBox(height: 20),
                                            CustomCommonTextWidget(
                                                text: "৳ ${outgoing.requestedAmount}",
                                                style: CommonTextStyle.semiBold_12,
                                                color: colorPrimaryText
                                            ),
                                          ],
                                        ),
                                      ],
                                    ):
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomCommonTextWidget(text: outgoing.receiverName.toString(), style: CommonTextStyle.regular_16, color: BrandingDataController.instance.branding.colors.primaryColor),
                                              const SizedBox(height: DimenSizes.dimen_5),
                                              CustomCommonTextWidget(text: outgoing.requestTo.toString(), style: CommonTextStyle.regular_14, color: colorPrimaryText),
                                              const SizedBox(height: DimenSizes.dimen_5),
                                              CustomCommonTextWidget(text: outgoing.requestDateTime.toString(), style: CommonTextStyle.regular_10, color: suvaGray),

                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomCommonTextWidget(
                                                text: "${outgoing.transactionStatus}",
                                                style: CommonTextStyle.semiBold_14,
                                                color:  acceptedStatus
                                            ),

                                            const SizedBox(height: 20),

                                            CustomCommonTextWidget(
                                                text: "৳ ${outgoing.requestedAmount}",
                                                style: CommonTextStyle.semiBold_12,
                                                color: colorPrimaryText
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );},):

                            Center(
                              child: CustomCommonTextWidget(
                                text: "no_request_found".tr(),
                                style: CommonTextStyle.regular_14,
                                color: eclipse ,
                              ),
                            ),

                          allRequestsData.isLoading? Shimmer.fromColors(
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
                          ):

                          widget.getAllRequestsResponse.incomingRequest!.isNotEmpty  ?
                          ListView.builder(
                            padding: AppDimen.commonAllSidePadding20,
                            itemCount: widget.getAllRequestsResponse.incomingRequest!.length,
                            itemBuilder: (context, index) {
                              final incoming = widget.getAllRequestsResponse.incomingRequest![index];
                              return GestureDetector(
                                onTap: () async {
                                  HapticFeedback.mediumImpact();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: DimenSizes.dimen_20),
                                  padding: const EdgeInsets.only(
                                      top: DimenSizes.dimen_8,
                                      bottom: DimenSizes.dimen_8,
                                      left: DimenSizes.dimen_12,
                                      right: DimenSizes.dimen_12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: BrandingDataController.instance.branding.colors.primaryColor,
                                      width: DimenSizes.dimen_half,
                                    ),
                                    borderRadius: const BorderRadius.all(Radius.circular(DimenSizes.dimen_4)),
                                  ),
                                  child:
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          children: [

                                            incoming.transactionStatus == TransactionStatusType.Pending.name?

                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        CustomCommonTextWidget(text: incoming.requesterName.toString(), style: CommonTextStyle.regular_16, color: BrandingDataController.instance.branding.colors.primaryColor),
                                                        const SizedBox(height: DimenSizes.dimen_5),
                                                        CustomCommonTextWidget(text: incoming.requestFrom.toString(), style: CommonTextStyle.regular_14, color: colorPrimaryText),
                                                        const SizedBox(height: DimenSizes.dimen_5),
                                                        CustomCommonTextWidget(text: incoming.requestDateTime.toString(), style: CommonTextStyle.regular_10, color: suvaGray),
                                                      ],
                                                    ),

                                                    CustomCommonTextWidget(
                                                      text: "৳ ${incoming.requestedAmount}",
                                                      style: CommonTextStyle.semiBold_12,
                                                      color: colorPrimaryText,
                                                    ),
                                                  ],
                                                ),

                                                Divider(
                                                  color: unselectedFontColor,
                                                  height: DimenSizes.dimen_30,
                                                  thickness: DimenSizes.dimen_1,
                                                  indent: DimenSizes.dimen_0,
                                                  endIndent: DimenSizes.dimen_0,
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: commonBackgroundColor,
                                                        elevation: 0,
                                                      ),
                                                      child: CustomCommonTextWidget(text: "reject".tr(), style: CommonTextStyle.regular_14, color: colorPrimaryText),
                                                      onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: CustomCommonTextWidget(text: 'decline_request_msg'.tr(), style: CommonTextStyle.bold_16, color: colorPrimaryText),
                                                              actions: [
                                                                ElevatedButton(
                                                                    onPressed: () {
                                                                      ref.read(declineRequestMoneyControllerProvider.notifier).declineMoney(incoming.requestId!);

                                                                      sendMoneyAmount = incoming.requestedAmount.toString();
                                                                      userName = incoming.requesterName;
                                                                      walletNumber = incoming.requestFrom!;

                                                                      Navigator.pop(context);
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: BrandingDataController.instance.branding.colors.primaryColor,
                                                                    ),
                                                                    child: CustomCommonTextWidget(text: 'yes'.tr(), style: CommonTextStyle.regular_14, color: Colors.white),),

                                                                ElevatedButton(
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: commonBackgroundColor,
                                                                  ),
                                                                    child:  CustomCommonTextWidget(text: 'no'.tr(), style: CommonTextStyle.regular_14, color: colorPrimaryText)),
                                                              ],
                                                            );
                                                          });
                                                      },
                                                    ),

                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: approveButtonColor,
                                                        elevation: 0,
                                                      ),
                                                      child: CustomCommonTextWidget(text: 'approve'.tr(), style: CommonTextStyle.regular_14, color: Colors.white),
                                                        onPressed: () {
                                                          AppUtils.hideKeyboard();

                                                          sendMoneyAmount = incoming.requestedAmount.toString();
                                                          userName = incoming.requesterName;
                                                          walletNumber = incoming.requestFrom!;
                                                          requestId = incoming.requestId!;

                                                          if(sendMoneyAmount.isNotEmpty) {

                                                            if((NumberFormatter.stringToDouble(currentBalance.toString()) - NumberFormatter.stringToDouble(sendMoneyAmount)).isNegative) {
                                                                Toasts.showErrorToast("insufficient_fund".tr());
                                                              }
                                                              else {

                                                                ref.read(transactionFeeControllerProvider.notifier).getTransactionFee(
                                                                    TransactionFeeRequest(
                                                                        incoming.requestTo,
                                                                        walletNumber,
                                                                        transactionType,
                                                                        sendMoneyAmount
                                                                    )
                                                                );}
                                                            }
                                                          },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ):

                                            incoming.transactionStatus == TransactionStatusType.Processed.name?
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      CustomCommonTextWidget(text: incoming.requesterName.toString(), style: CommonTextStyle.regular_16, color: BrandingDataController.instance.branding.colors.primaryColor),
                                                      const SizedBox(height: DimenSizes.dimen_5),
                                                      CustomCommonTextWidget(text: incoming.requestFrom.toString(), style: CommonTextStyle.regular_14, color: colorPrimaryText),
                                                      const SizedBox(height: DimenSizes.dimen_5),
                                                      CustomCommonTextWidget(text: incoming.requestDateTime.toString(), style: CommonTextStyle.regular_10, color: suvaGray),
                                                    ],
                                                  ),
                                                ),

                                                Column(
                                                  children: [
                                                    CustomCommonTextWidget(
                                                      text: "Processed",
                                                      style: CommonTextStyle.semiBold_14,
                                                      color: acceptedStatus,
                                                    ),
                                                    const SizedBox(height: 20),
                                                    CustomCommonTextWidget(
                                                      text: "৳ ${incoming.requestedAmount}",
                                                      style: CommonTextStyle.semiBold_12,
                                                      color: colorPrimaryText,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ):



                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      CustomCommonTextWidget(text: incoming.requesterName.toString(), style: CommonTextStyle.regular_16, color: BrandingDataController.instance.branding.colors.primaryColor),
                                                      const SizedBox(height: DimenSizes.dimen_5),
                                                      CustomCommonTextWidget(text: incoming.requestFrom.toString(), style: CommonTextStyle.regular_14, color: colorPrimaryText),
                                                      const SizedBox(height: DimenSizes.dimen_5),
                                                      CustomCommonTextWidget(text: incoming.requestDateTime.toString(), style: CommonTextStyle.regular_10, color: suvaGray),
                                                    ],
                                                  ),
                                                ),

                                                Column(
                                                  children: [
                                                    CustomCommonTextWidget(
                                                      text: "Declined",
                                                      style: CommonTextStyle.semiBold_14,
                                                      color: canceledStatus,
                                                    ),
                                                    const SizedBox(height: 20),
                                                    CustomCommonTextWidget(
                                                      text: "৳ ${incoming.requestedAmount}",
                                                      style: CommonTextStyle.semiBold_12,
                                                      color: colorPrimaryText,
                                                    ),

                                                  ],
                                                ),
                                              ],
                                            ),

                                           // const SizedBox( height: DimenSizes.dimen_8),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ):

                          Center(
                            child: CustomCommonTextWidget(
                              text: "no_request_found".tr(),
                              style: CommonTextStyle.regular_14,
                              color: eclipse ,
                            ),
                          ),
                        ],
                        ),
                    ),],
                  ),
              ),
            ),
          ),],
        ),
      ),
    );
  }
}