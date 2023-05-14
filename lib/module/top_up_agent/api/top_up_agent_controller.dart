import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:red_cash_dfs_flutter/module/top_up_agent/api/top_up_agent_data_source.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import 'model/top_up_agent_request.dart';
import 'model/top_up_agent_response.dart';


class TopUpAgentController extends StateNotifier<AsyncValue<TopUpAgentResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  TopUpAgentController(this._ref) : super(AsyncData(TopUpAgentResponse()));

  Future<void> topUpAgent(TopUpAgentRequest topUpAgentRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(topUpAgentDataSourceProvider).topUpAgent(topUpAgentRequest);

      safeApiCall<TopUpAgentResponse>(response, onSuccess: (response) {

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

final topUpAgentControllerProvider = StateNotifierProvider<TopUpAgentController, AsyncValue<TopUpAgentResponse>>((ref) {
  return TopUpAgentController(ref);
}
);