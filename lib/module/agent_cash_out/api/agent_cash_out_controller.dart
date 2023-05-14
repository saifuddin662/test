import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import 'agent_cash_out_data_source.dart';
import 'model/agent_cash_out_request.dart';
import 'model/agent_cash_out_response.dart';


class AgentCashOutController extends StateNotifier<AsyncValue<AgentCashOutResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  AgentCashOutController(this._ref) : super(AsyncData(AgentCashOutResponse()));

  Future<void> agentCashOut(AgentCashOutRequest agentCashOutRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(agentCashOutDataSourceProvider).agentCashOut(agentCashOutRequest);

      safeApiCall<AgentCashOutResponse>(response, onSuccess: (response) {

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

final agentCashOutControllerProvider =
StateNotifierProvider<AgentCashOutController, AsyncValue<AgentCashOutResponse>>((ref) {
  return AgentCashOutController(ref);
});