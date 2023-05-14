import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../core/di/core_providers.dart';
import '../../../core/local/services/local_pref_service.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import '../../../utils/number_formatter.dart';
import '../../../utils/pref_keys.dart';
import 'check_balance_data_source.dart';
import 'model/check_balance_response.dart';


class CheckBalanceController extends StateNotifier<AsyncValue<CheckBalanceResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  final LocalPrefService _prefs;

  CheckBalanceController(this._ref, this._prefs) : super(AsyncData(CheckBalanceResponse()));

  Future<void> checkBalance() async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(checkBalanceDataSourceProvider).checkBalance();

      safeApiCall<CheckBalanceResponse>(response, onSuccess: (response) {

        state = AsyncData(response!);
        _prefs.setString(PrefKeys.keyUserBalance, response.balance.toString());
        _prefs.setDouble(PrefKeys.keyCheckBalance, NumberFormatter.stringToDouble(response.balance.toString()));
      }, onError: (code, message) {
        state = AsyncError(
          message,
          StackTrace.current,
        );
      });
    } on Failure {
      state = AsyncError("error",StackTrace.current);
    }
  }
}

final checkBalanceControllerProvider =
StateNotifierProvider<CheckBalanceController, AsyncValue<CheckBalanceResponse>>((ref) {
  final prefs = ref.watch(localPrefProvider);
  return CheckBalanceController(ref, prefs);
});

