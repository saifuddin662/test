import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import 'cash_out_data_source.dart';
import 'model/cash_out_request.dart';
import 'model/cash_out_response.dart';


class CashOutController extends StateNotifier<AsyncValue<CashOutResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  CashOutController(this._ref) : super(AsyncData(CashOutResponse()));

  Future<void> cashOut(CashOutRequest cashOutRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(cashOutDataSourceProvider).cashOut(
          CashOutRequest(
              agentAccountNo: cashOutRequest.agentAccountNo,
              amount: cashOutRequest.amount,
              pin: cashOutRequest.pin
          )
      );

      safeApiCall<CashOutResponse>(response, onSuccess: (response) {

        state = AsyncData(response!);

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

final cashOutControllerProvider =
StateNotifierProvider<CashOutController, AsyncValue<CashOutResponse>>((ref) {
  return CashOutController(ref);
});