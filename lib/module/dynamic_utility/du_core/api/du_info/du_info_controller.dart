import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:red_cash_dfs_flutter/module/dynamic_utility/du_core/api/du_info/model/utility_info_request.dart';
import '../../../../../core/di/core_providers.dart';
import '../../../../../core/local/services/local_pref_service.dart';
import '../../../../../core/networking/error/failure.dart';
import '../../../../../core/networking/safe_api_call.dart';
import '../../../../../utils/pref_keys.dart';
import '../../dynamic_view/data/dynamic_utility_data_controller.dart';
import 'du_info_data_source.dart';
import 'model/utility_info_response.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 14,March,2023.

class DuInfoController extends StateNotifier<AsyncValue<UtilityInfoResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  final LocalPrefService _prefs;

  DuInfoController(this._ref, this._prefs)
      : super(AsyncData(UtilityInfoResponse()));

  Future<void> utilityInfo() async {
    try {
      state = const AsyncLoading();

      Map<String, dynamic>? dynamicFields = DynamicUtilityDataController.instance.fieldValue;
      //0302109157 - 201000451348

      final UtilityInfoRequest utilityInfoRequest = UtilityInfoRequest(
          featureCode: DynamicUtilityDataController.instance.utilityInfo.featureCode,
          walletNo: _prefs.getString(PrefKeys.keyMsisdn),
          dynamicFields: dynamicFields);

      final response = await _ref
          .read(utilityInfoDataSourceProvider)
          .utilityInfo(utilityInfoRequest);

      safeApiCall<UtilityInfoResponse>(response, onSuccess: (response) {
        state = AsyncData(response!);
      }, onError: (code, message) {
        state = AsyncError(
          message,
          StackTrace.current,
        );
        log.info(
            "------------------------- ERROR > code: $code, msg: $message");
      });
    } on Failure {
      state = AsyncError("error", StackTrace.current);
    }
  }
}

final duInfoControllerProvider =
    StateNotifierProvider<DuInfoController, AsyncValue<UtilityInfoResponse>>(
        (ref) {
  final prefs = ref.watch(localPrefProvider);
  return DuInfoController(ref, prefs);
});
