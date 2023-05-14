import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:red_cash_dfs_flutter/module/dashboard/transaction_list/api/txn_list_data_source.dart';
import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import 'model/txn_list_response.dart';

class TxnListController extends StateNotifier<AsyncValue<TxnListResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  TxnListController(this._ref) : super(AsyncData(TxnListResponse()));

  Future<void> getTxnList() async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(txnListDataSourceProvider).getTxnList();

      safeApiCall<TxnListResponse>(response, onSuccess: (response) {

        state = AsyncData(response!);

      }, onError: (code, message) {
        state = AsyncError(
          message,
          StackTrace.current,
        );
        debugPrint("------------------------- ERROR > code: $code, msg: $message");
      });
    } on Failure {
      state = AsyncError("error",StackTrace.current);
    }
  }
}

final txnListControllerProvider = StateNotifierProvider<TxnListController, AsyncValue<TxnListResponse>>((ref) {
  return TxnListController(ref);
}
);