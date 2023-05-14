import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import 'decline_request_money_data_source.dart';
import 'model/decline_request_money_request.dart';
import 'model/decline_request_money_response.dart';



class DeclineRequestMoneyController extends StateNotifier<AsyncValue<DeclineRequestMoneyResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  DeclineRequestMoneyController(this._ref) : super(AsyncData(DeclineRequestMoneyResponse()));

  Future<void> declineMoney(String requestId) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(declineRequestMoneyDataSourceProvider).declineMoney(
          DeclineRequestMoneyRequest(
              requestId: requestId,

          )
      );

      safeApiCall<DeclineRequestMoneyResponse>(response, onSuccess: (response) {

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

final declineRequestMoneyControllerProvider = StateNotifierProvider<DeclineRequestMoneyController, AsyncValue<DeclineRequestMoneyResponse>>((ref) {
  return DeclineRequestMoneyController(ref);
}
);