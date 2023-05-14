import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../common/toasts.dart';
import '../../../core/context_holder.dart';
import '../../../core/di/core_providers.dart';
import '../../../core/flavor/flavor_provider.dart';
import '../../../core/networking/error/failure.dart';
import '../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../utils/Colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/feature_details_keys.dart';
import '../../../utils/pref_keys.dart';
import '../../../utils/styles.dart';
import '../../add_money/add_money_screen.dart';
import '../../agent_cash_in/agent_cash_in_number_screen.dart';
import '../../agent_cash_out/api/agent_cash_out_dis_info_controller.dart';
import '../../agent_cash_out/api/model/agent_cash_out_dis_info_request.dart';
import '../../agent_locator/api/agent_locator_controller.dart';
import '../../cash_out/cash_out_number_screen.dart';
import '../../customer_registration_by_agent/customer_reg_by_agent_screen.dart';
import '../../dsr_limit/dsr_limit_info_screen.dart';
import '../../dynamic_utility/du_core/api/du_detail/du_detail_controller.dart';
import '../../dynamic_utility/du_core/api/du_detail/model/utility_detail_response.dart';
import '../../dynamic_utility/du_core/dynamic_view/data/dynamic_utility_data_controller.dart';
import '../../dynamic_utility/du_core/dynamic_view/model/utility_info_model.dart';
import '../../dynamic_utility/du_detail_screen.dart';
import '../../education_fees/institute_list_screen.dart';
import '../../login_registration/login/login_screen.dart';
import '../../merchant_pay/merchant_pay_number_screen.dart';
import '../../mobile_recharge/mobile_recharge_number_screen.dart';
import '../../request_money/api/get_all_requests/get_all_requests_controller.dart';
import '../../request_money/api/get_all_requests/model/get_all_requests_response.dart';
import '../../request_money/request_money_screen.dart';
import '../../send_money/send_money_number_screen.dart';
import '../../top_up_agent/top_up_agent_list_screen.dart';
import '../../update_agent_locator/api/model/update_agent_locator_request.dart';
import '../../update_agent_locator/api/update_agent_locator_controller.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 10,May,2023.

class DashNavigationController extends AsyncNotifier<void> {
  Logger get log => Logger(runtimeType.toString());
  final context = ContextHolder.navKey.currentContext!;

  double latitude = 0.0;
  double longitude = 0.0;

  @override
  FutureOr<void> build() {
    initListeners();
    if(ref.read(flavorProvider).name == AppConstants.userTypeAgent) {
      updateCurrentLocation();
    }
  }

  Future<void> initListeners() async {
    try {

      listenGetAllRequestsController();
      listenDuDetailController();

    } on Failure {
      state = AsyncError("error", StackTrace.current);
    }
  }

  void navigateTo(String featureCode){

      switch(featureCode) {
        case FeatureDetailsKeys.sendMoney:
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => const SendMoneyNumberScreen()
              )
          );
          break;
        case FeatureDetailsKeys.cashOutCustomer:
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => const CashOutNumberScreen()
              )
          );
          break;
        case FeatureDetailsKeys.merchantPayment:
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => const MerchantPayNumberScreen()
              )
          );
          break;
        case FeatureDetailsKeys.educationFees:
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => const InstituteListScreen()
              )
          );
          break;
        case FeatureDetailsKeys.mobileRecharge:
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => const MobileRechargeNumberScreen()
              )
          );
          break;
        case FeatureDetailsKeys.addMoney:
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => const AddMoneyScreen()
              ));
          break;

        case FeatureDetailsKeys.requestMoney:
          ref.read(getAllRequestsControllerProvider.notifier).getAllRequestsList();
          break;

        case FeatureDetailsKeys.agentLocator:
          goToAgentLocatorScreen();
          break;
        case FeatureDetailsKeys.agentCashOut:
          final userWalletNo = ref.read(localPrefProvider).getString(PrefKeys.keyMsisdn);
          AgentCashOutDisInfoRequest agentCashOutDisInfoRequest = AgentCashOutDisInfoRequest("$userWalletNo");
          ref.read(agentCashOutDisInfoControllerProvider.notifier).getDistributorInfo(agentCashOutDisInfoRequest);
          break;
        case FeatureDetailsKeys.cashInFromMfsAgent:
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => const AgentCashInNumberScreen()
              ));
          break;
        case FeatureDetailsKeys.customerRegistrationByAgent:
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => const CustomerRegByAgentScreen()
              ));
          break;
        case FeatureDetailsKeys.dsrTopUpAgent:
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => const TopUpAgentListScreen()
              ));
          break;
        case FeatureDetailsKeys.limitDsr:
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => const DsrLimitInfoListScreen()
              ));
          break;
      }

  }

  void listenDuDetailController() {
    ref.listen<AsyncValue>(
      duDetailControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();

          if (currentState.value != null && currentState.value.utilityTitle != null) {
            final detailResponse = currentState.value as UtilityDetailResponse;

            log.info('Utility Response ------> ${detailResponse.utilityTitle}');

            clearStoredData();

            DynamicUtilityDataController.instance.utilityInfo.featureCode = detailResponse.utilityCode;

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DynamicUtilityDetailScreen(detailResponse)),
            );
          }
          else {
            Toasts.showErrorToast("Currently Unavailable!");
          }
        }
      },
    );
  }

  void listenGetAllRequestsController() {
    ref.listen<AsyncValue>(
      getAllRequestsControllerProvider,
      (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");

        } else {
          EasyLoading.dismiss();

          log.info('got get request response');

          if (currentState.value != null) {
            final getRequestResponse =
                currentState.value as GetAllRequestsResponse;

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RequestMoneyScreen(getRequestResponse)),
            );
          } else {
            Toasts.showErrorToast("Currently Unavailable!");
          }
        }
      },
    );
  }

  void clearStoredData() {
    DynamicUtilityDataController.instance.requiredMap.clear();
    DynamicUtilityDataController.instance.fieldValue.clear();
    DynamicUtilityDataController.instance.utilityInfo = UtilityInfoModel();
  }

  void goToAgentLocatorScreen() async {
    EasyLoading.show();
    Position position = await determinePosition();

      latitude = position.latitude;
      longitude = position.longitude;

    ref.read(agentLocatorControllerProvider.notifier).getNearbyAgentData(latitude, longitude);
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      locationEnableDialog();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        locationPermissionDialog();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      locationPermissionDialog();
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void locationPermissionDialog() {
    EasyLoading.dismiss();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: CustomCommonTextWidget(
              text: 'location_permission'.tr() ,
              style: CommonTextStyle.regular_14,
              color: colorPrimaryText,
            ),
            content: CustomCommonTextWidget(
              text: 'must_enable_location_service'.tr() ,
              style: CommonTextStyle.regular_14,
              color: colorPrimaryText,
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Text('OK'.tr()),
                onPressed: () {
                  openAppSettings();
                  Navigator.pushAndRemoveUntil(ContextHolder.navKey.currentContext!,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false
                  );
                },
              ),
            ],
          );
        });
  }

  void locationEnableDialog() {
    EasyLoading.dismiss();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: CustomCommonTextWidget(
              text: 'location_permission'.tr() ,
              style: CommonTextStyle.regular_14,
              color: colorPrimaryText,
            ),
            content: CustomCommonTextWidget(
              text: 'must_enable_location_service'.tr() ,
              style: CommonTextStyle.regular_14,
              color: colorPrimaryText,
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Text('OK'.tr()),
                onPressed: () {
                  Geolocator.openLocationSettings();
                  Navigator.pushAndRemoveUntil(ContextHolder.navKey.currentContext!,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false
                  );
                },
              ),
            ],
          );
        });
  }

  void updateCurrentLocation() async {
    log.info('Uploading agent location to server....');
    Position position = await determinePosition();
      latitude = position.latitude;
      longitude = position.longitude;

    UpdateAgentLocatorRequest updateAgentLocatorRequest = UpdateAgentLocatorRequest(
        agentName: "${ref.read(localPrefProvider).getString(PrefKeys.keyUserName)}",
        agentWalletNo: '${ref.read(localPrefProvider).getString(PrefKeys.keyMsisdn)}',
        latitude: latitude,
        longitude: longitude
    );
    ref.read(updateAgentLocatorControllerProvider.notifier).updateAgentLocator(updateAgentLocatorRequest);
  }
}

final navigationControllerProvider = AsyncNotifierProvider<DashNavigationController, void>(DashNavigationController.new);
