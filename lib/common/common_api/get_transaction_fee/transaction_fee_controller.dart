import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:red_cash_dfs_flutter/common/common_api/get_transaction_fee/transaction_fee_data_source.dart';

import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import 'model/transaction_fee_request.dart';
import 'model/transaction_fee_response.dart';


class TransactionFeeController extends StateNotifier<AsyncValue<TransactionFeeResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  TransactionFeeController(this._ref) : super(AsyncData(TransactionFeeResponse()));

  Future<void> getTransactionFee(TransactionFeeRequest transactionFeeRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(transactionFeeDataSourceProvider).getTransactionFee(
          TransactionFeeRequest(
            transactionFeeRequest.fromUserNumber,
            transactionFeeRequest.toUserNumber,
            transactionFeeRequest.transactionType,
            transactionFeeRequest.amount,
          )
      );

      safeApiCall<TransactionFeeResponse>(response, onSuccess: (response) {

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

final transactionFeeControllerProvider =
StateNotifierProvider<TransactionFeeController, AsyncValue<TransactionFeeResponse>>((ref) {
  return TransactionFeeController(ref);
});