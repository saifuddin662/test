import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import 'add_money_data_source.dart';
import 'model/get_transaction_id_request.dart';
import 'model/get_transaction_id_response.dart';

/**
 * Created by Md. Awon-Uz-Zaman on 25/2/23
 */

class AddMoneyController extends StateNotifier<AsyncValue<GetTransactionIdResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  AddMoneyController(this._ref) : super(AsyncData(GetTransactionIdResponse()));

  Future<void> getAddMoneyInfo(GetTransactionRequest getTransactionRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref
          .read(addMoneyDataSourceProvider)
          .getAddMoneyInfo(GetTransactionRequest(amount: getTransactionRequest.amount));

      safeApiCall<GetTransactionIdResponse>(response, onSuccess: (response) {
        state = AsyncData(response!);
      }, onError: (code, message) {
        state = AsyncError(
          message,
          StackTrace.current,
        );
      });
    } on Failure {
      state = AsyncError("error", StackTrace.current);
    }
  }
}

final addMoneyControllerProvider = StateNotifierProvider<AddMoneyController, AsyncValue<GetTransactionIdResponse>>((ref) {
  return AddMoneyController(ref);
});
