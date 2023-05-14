import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:red_cash_dfs_flutter/module/dynamic_utility/du_core/api/du_detail/model/utility_detail_response.dart';
import '../../../../../core/di/core_providers.dart';
import '../../../../../core/local/services/local_pref_service.dart';
import '../../../../../core/networking/error/failure.dart';
import '../../../../../core/networking/safe_api_call.dart';
import 'du_detail_data_source.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 08,March,2023.

class DuDetailController
    extends StateNotifier<AsyncValue<UtilityDetailResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  final LocalPrefService _prefs;

  DuDetailController(this._ref, this._prefs)
      : super(AsyncData(UtilityDetailResponse()));

  Future<void> utilityDetail(String utilityCode) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(utilityDetailDataSourceProvider).utilityDetail(utilityCode);

      safeApiCall<UtilityDetailResponse>(response, onSuccess: (response) {
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

final duDetailControllerProvider = StateNotifierProvider<DuDetailController,
    AsyncValue<UtilityDetailResponse>>((ref) {
  final prefs = ref.watch(localPrefProvider);
  return DuDetailController(ref, prefs);
});
