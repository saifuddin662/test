import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import 'make_request_money_data_source.dart';
import 'model/make_request_money_request.dart';
import 'model/make_request_money_response.dart';


class MakeRequestMoneyController extends StateNotifier<AsyncValue<MakeRequestMoneyResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  MakeRequestMoneyController(this._ref) : super(AsyncData(MakeRequestMoneyResponse()));

  Future<void> requestMoney(MakeRequestMoneyRequest makeRequestMoneyRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(makeRequestMoneyDataSourceProvider).requestMoney(
          MakeRequestMoneyRequest(

            requesterName: makeRequestMoneyRequest.requesterName,
            requestTo: makeRequestMoneyRequest.requestTo,
            receiverName: makeRequestMoneyRequest.receiverName,
            requestedAmount: makeRequestMoneyRequest.requestedAmount,
            pin: makeRequestMoneyRequest.pin,

          )
      );

      safeApiCall<MakeRequestMoneyResponse>(response, onSuccess: (response) {

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

final makeRequestMoneyControllerProvider = StateNotifierProvider<MakeRequestMoneyController, AsyncValue<MakeRequestMoneyResponse>>((ref) {
  return MakeRequestMoneyController(ref);
}
);