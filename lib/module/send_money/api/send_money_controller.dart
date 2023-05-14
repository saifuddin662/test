import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:red_cash_dfs_flutter/module/send_money/api/send_money_data_source.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import 'model/send_money_request.dart';
import 'model/send_money_response.dart';


class SendMoneyController extends StateNotifier<AsyncValue<SendMoneyResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  SendMoneyController(this._ref) : super(AsyncData(SendMoneyResponse()));

  Future<void> sendMoney(SendMoneyRequest sendMoneyRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(sendMoneyDataSourceProvider).sendMoney(
        SendMoneyRequest(
            recipientNumber: sendMoneyRequest.recipientNumber,
            amount: sendMoneyRequest.amount,
            pin: sendMoneyRequest.pin
        )
      );

      safeApiCall<SendMoneyResponse>(response, onSuccess: (response) {

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

final sendMoneyControllerProvider = StateNotifierProvider<SendMoneyController, AsyncValue<SendMoneyResponse>>((ref) {
  return SendMoneyController(ref);
}
);