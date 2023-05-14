import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:red_cash_dfs_flutter/module/request_money/api/pay_request_money/pay_request_money_data_source.dart';
import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import 'model/pay_request_money_request.dart';
import 'model/pay_request_money_response.dart';


class PayRequestMoneyController extends StateNotifier<AsyncValue<PayRequestMoneyResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  PayRequestMoneyController(this._ref) : super(AsyncData(PayRequestMoneyResponse()));

  Future<void> payMoney(PayRequestMoneyRequest payRequestMoneyRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(payRequestMoneyDataSourceProvider).payMoney(
          PayRequestMoneyRequest(
              requestId: payRequestMoneyRequest.requestId,
              transactionType: payRequestMoneyRequest.transactionType,
              pin: payRequestMoneyRequest.pin
          )
      );

      safeApiCall<PayRequestMoneyResponse>(response, onSuccess: (response) {

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

final  payRequestMoneyControllerProvider = StateNotifierProvider<PayRequestMoneyController, AsyncValue<PayRequestMoneyResponse>>((ref) {
  return  PayRequestMoneyController(ref);
}
);