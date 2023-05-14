import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/education_fees/registration_info_screen.dart';
import '../../base/base_consumer_state.dart';
import '../../common/common_api/check_balance/check_balance_controller.dart';
import '../../common/constants.dart';
import '../../common/model/common_confirm_dialog_model.dart';
import '../../common/model/summary_details_item.dart';
import '../../common/toasts.dart';
import '../../core/di/core_providers.dart';
import '../../ui/configs/branding_data_controller.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_common_inputfield_widget.dart';
import '../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../ui/custom_widgets/custom_institute_tile_widget.dart';
import '../../ui/custom_widgets/tiles/saved_institute_tile_widget.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/extensions/extension_rounded_rectangle_border.dart';
import '../../utils/pref_keys.dart';
import '../../utils/styles.dart';
import '../statements/education_fees/data/statement_edu_data_controller.dart';
import '../statements/education_fees/model/statement_edu_info_model.dart';
import 'api/institution_list_controller.dart';
import 'api/model/EducationFeesRequest.dart';
import 'api/model/institute_list_response.dart';
import 'api/model/school_fees_request.dart';
import 'api/model/school_fees_response.dart';
import 'api/registration_info_controller.dart';
import 'beneficiary/data/edu_fee_data_controller.dart';
import 'beneficiary/model/edu_common_confirm_model.dart';
import 'beneficiary/model/edu_txn_info_model.dart';
import 'education_fees_status_screen.dart';


class InstituteListScreen extends ConsumerStatefulWidget {
  const InstituteListScreen({
    Key? key,
  }) : super(key: key);

  @override
  BaseConsumerState<InstituteListScreen> createState() =>
      _InstituteListScreenState();
}

class _InstituteListScreenState extends BaseConsumerState<InstituteListScreen> {
  List<Institute>? instituteList;
  List<Institute>? filteredInstituteList;
  List<EduTxnInfoModel>? savedTxnList = [];
  final institutionTextController = TextEditingController();

  var isPaid = false;
  var isOpen = false;
  var status = '';
  List<SummaryDetailsItem> summaryList = [];
  var commonConfirmDialog = CommonConfirmDialogModel('', '', [], [], '');
  var eduTxnInfoModel = EduTxnInfoModel();

  @override
  void initState() {
    super.initState();
    getInstitutes();
    institutionTextController.addListener(onChange);
    ref.read(checkBalanceControllerProvider.notifier).checkBalance();
    StatementEduDataController.instance.eduInfo = StatementEduInfoModel(charge: '0');
    EduFeeDataController.instance.isSavedChecked = false;
    EduFeeDataController.instance.fromSaved = false;
  }

  void getInstitutes() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(instituteListControllerProvider.notifier).getInstituteList();
    });
  }

  void filterSearchResults() {
    List<Institute>? dummyInstitute;
    String text = institutionTextController.text;

    if (text.isEmpty) {
      dummyInstitute = instituteList;
    } else {
      dummyInstitute = [];
      instituteList?.forEach((institute) {
        if (institute.name.toLowerCase().contains(text.toLowerCase()) ||
            institute.code.toLowerCase().contains(text.toLowerCase())) {
          dummyInstitute?.add(institute);
        }
      });
    }

    setState(() {
      filteredInstituteList = dummyInstitute;
    });
  }

  onChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      instituteListControllerProvider, (previousState, currentState) async {
      if (currentState.isLoading || currentState.isRefreshing) {
        EasyLoading.show();
      } else if (currentState.hasError) {
        EasyLoading.dismiss();
        Toasts.showErrorToast("${currentState.error}");
      } else {
        EasyLoading.dismiss();
      }},
    );

    ref.listen<AsyncValue>(
      registrationInfoControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          //Toasts.showErrorToast("${currentState.error}");
          log.info('======================================================================== registrationInfoControllerProvider 2');
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => CustomCommonErrorWidget(
          //       errorMessage: '${currentState.error}',
          //     ),
          //   ),
          // );
        } else {
          EasyLoading.dismiss();
          final data = ref.watch(registrationInfoControllerProvider);

          final SchoolFeesResponse feeResponse = data.value!;
          final amount = feeResponse.amount ?? 0;

          if(eduTxnInfoModel.schoolInfo != null){

            log.info('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > GOING TO EDU FEE STATUS');

            if(amount > 0.0) {

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EducationFeesStatusScreen(
                        isPaid: false,
                        confirmDialogModel: commonConfirmDialog,
                        schoolInfo: eduTxnInfoModel.schoolInfo!,
                        status: status,
                        isOpen: eduTxnInfoModel.isOpen ?? false,
                      )));

            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EducationFeesStatusScreen(
                        isPaid: true,
                        confirmDialogModel: commonConfirmDialog,
                        schoolInfo: eduTxnInfoModel.schoolInfo!,
                        status: Constants.notFound,
                        isOpen: eduTxnInfoModel.isOpen ?? false,
                      )));
            }
          }

        }
      },
    );
    
    instituteList = ref.watch(instituteListControllerProvider).value?.instituteList;
    loadSavedEduTxn();
    filterSearchResults();

    return Scaffold(
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'education_fees'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimen.toolbarBottomGap),
            Padding(
              padding: AppDimen.commonLeftRightPadding,
              child: CustomCommonInputFieldWidget(
                obscureText: false,
                scrollPadding: const EdgeInsets.all(0.0),
                controller: institutionTextController,
                onChanged: (value) {
                  filterSearchResults();
                },
                decoration: InputDecoration(
                    labelText: 'search'.tr(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppDimen.commonCircularBorderRadius,
                      borderSide: BorderSide(
                          color: BrandingDataController.instance.branding.colors.primaryColor, width: DimenSizes.dimen_half),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: AppDimen.commonCircularBorderRadius,
                      borderSide: BorderSide(
                          color: greyColor, width: DimenSizes.dimen_2),
                    )),
              ),
            ),
            const SizedBox(height: AppDimen.toolbarBottomGap),

            //saved bills
            (savedTxnList != null && savedTxnList!.isNotEmpty) ?
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppDimen.commonLeftRightPadding,
                  child: CustomCommonTextWidget(
                      text: 'Saved Bills',
                      style: CommonTextStyle.regular_16,
                      color: colorPrimaryText,
                      shouldShowMultipleLine: true),
                ),
                const SizedBox(height: AppDimen.toolbarBottomGap),
                ListView.builder(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: savedTxnList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      shape: ShapeStyle.listItemShape(),
                      margin: AppDimen.contactListTextFieldMargin,
                      child: SavedInstituteTileWidget(
                          schoolPaymentInfo:
                          savedTxnList![index].schoolInfo,
                          insName: savedTxnList![index].insName ?? '',
                          onPressedFunction: () => gotoFeeStatus(
                              context,
                              savedTxnList![index],)),
                    );
                  },
                ),
              ],
            )
                : const SizedBox(),

            //institute list
            Expanded(
              child: Container(
                  child: filteredInstituteList != null ?
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: AppDimen.commonLeftRightPadding,
                          child: CustomCommonTextWidget(
                              text: "institution_list".tr(),
                              style: CommonTextStyle.regular_16,
                              color: colorPrimaryText,
                              shouldShowMultipleLine: true),
                        ),
                        const SizedBox(height: AppDimen.toolbarBottomGap),
                        ListView.builder(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: filteredInstituteList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              shape: ShapeStyle.listItemShape(),
                              margin: AppDimen.contactListTextFieldMargin,
                              child: CustomInstituteTileWidget(
                                instituteItem: filteredInstituteList![index],
                                onPressedFunction: () =>
                                    instituteClickAction(context, index),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ) : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  gotoFeeStatus(BuildContext context, EduTxnInfoModel eduTxnInfo) {
    EduFeeDataController.instance.fromSaved = true;
    isPaid = eduTxnInfo.isPaid ?? false;
    isOpen = eduTxnInfo.isOpen ?? false;
    status = eduTxnInfo.status ?? '';

    eduTxnInfoModel = eduTxnInfo;

    summaryList = eduTxnInfo
        .eduCommonConfirmModel!.transactionSummary
        .map(
            (summary) => SummaryDetailsItem(summary.title, summary.description))
        .toList();

    commonConfirmDialog = CommonConfirmDialogModel(
      "education_fees".tr(),
      "education_fees".tr(),
      eduTxnInfo.eduCommonConfirmModel!.recipientSummary,
      summaryList,
      eduTxnInfo.eduCommonConfirmModel!.apiUrl,
    );

    if (isOpen) {
      ref.read(registrationInfoControllerProvider.notifier).getFees(SchoolFeesRequest(insCode: eduTxnInfo.insCode, regId: eduTxnInfo.regNo));
    }
    else{
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EducationFeesStatusScreen(
                isPaid: isPaid,
                confirmDialogModel: commonConfirmDialog,
                schoolInfo: eduTxnInfo.schoolInfo!,
                status: status,
                isOpen: false,
              )));
    }

  }

  void instituteClickAction(BuildContext context, int index) {
    EduFeeDataController.instance.fromSaved = false;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegistrationInfoScreen(
                  institute: filteredInstituteList![index],
                )
        )
    );
  }

  void loadSavedEduTxn() {
    var txnListInString =
        ref.read(localPrefProvider).getString(PrefKeys.keyEduSavedTxnList);

    if (txnListInString != null) {
      var dataList = (json.decode(txnListInString) as List<dynamic>);

      savedTxnList = dataList
          .map((item) => EduTxnInfoModel(
              saveTime: item['saveTime'],
              insCode: item['insCode'],
              insName: item['insName'],
              studentName: item['studentName'],
              regNo: item['regNo'],
              amount: item['amount'],
              status: item['status'],
              isPaid: item['isPaid'],
              isOpen: item['isOpen'],
              eduCommonConfirmModel:
                  EduCommonConfirmModel.fromMap(item['eduCommonConfirmModel']),
              schoolInfo: SchoolPaymentInfo.fromJson(item['schoolInfo'])))
          .toList();
    }

    var temp = savedTxnList;
  }

  @override
  void dispose() {
    institutionTextController.clear();
    super.dispose();
  }

}
