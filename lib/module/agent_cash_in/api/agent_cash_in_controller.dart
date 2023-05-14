import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import 'agent_cash_in_data_source.dart';
import 'model/agent_cash_in_request.dart';
import 'model/agent_cash_in_response.dart';


class AgentCashInController extends StateNotifier<AsyncValue<AgentCashInResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  AgentCashInController(this._ref) : super(AsyncData(AgentCashInResponse()));

  Future<void> agentCashOut(AgentCashInRequest agentCashInRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(agentCashInDataSourceProvider).agentCashIn(agentCashInRequest);

      safeApiCall<AgentCashInResponse>(response, onSuccess: (response) {

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

final agentCashInControllerProvider =
StateNotifierProvider<AgentCashInController, AsyncValue<AgentCashInResponse>>((ref) {
  return AgentCashInController(ref);
});