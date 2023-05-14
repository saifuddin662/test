import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:red_cash_dfs_flutter/module/dynamic_utility/du_core/api/du_payment/du_payment_data_source.dart';
import 'package:red_cash_dfs_flutter/module/dynamic_utility/du_core/api/du_payment/model/du_payment_response.dart';
import '../../../../../core/di/core_providers.dart';
import '../../../../../core/local/services/local_pref_service.dart';
import '../../../../../core/networking/error/failure.dart';
import '../../../../../core/networking/safe_api_call.dart';
import '../../../../../utils/pref_keys.dart';
import '../../dynamic_view/data/dynamic_utility_data_controller.dart';
import 'model/du_payment_request.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 16,March,2023.

class DuPaymentController
    extends StateNotifier<AsyncValue<UtilityPaymentResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  final LocalPrefService _prefs;

  DuPaymentController(this._ref, this._prefs)
      : super(AsyncData(UtilityPaymentResponse()));

  Future<void> utilityPayment(String pin) async {
    try {
      state = const AsyncLoading();

      final UtilityPaymentRequest utilityPaymentRequest = UtilityPaymentRequest(
        featureCode: DynamicUtilityDataController.instance.utilityInfo.featureCode,
        transactionId: DynamicUtilityDataController.instance.utilityInfo.transactionId,
        walletNo: _prefs.getString(PrefKeys.keyMsisdn),
        pin: pin,
        notificationNumber: DynamicUtilityDataController.instance.utilityInfo.notificationNumber,
      );

      final response = await _ref
          .read(utilityPaymentDataSourceProvider)
          .utilityPayment(utilityPaymentRequest);

      safeApiCall<UtilityPaymentResponse>(response, onSuccess: (response) {
        state = AsyncData(response!);
      }, onError: (code, message) {
        state = AsyncError(
          message,
          StackTrace.current,
        );
        log.info("------------------------- ERROR > code: $code, msg: $message");
      });
    } on Failure {
      state = AsyncError("error", StackTrace.current);
    }
  }
}

final duPaymentControllerProvider = StateNotifierProvider<DuPaymentController,
    AsyncValue<UtilityPaymentResponse>>((ref) {
  final prefs = ref.watch(localPrefProvider);
  return DuPaymentController(ref, prefs);
});
