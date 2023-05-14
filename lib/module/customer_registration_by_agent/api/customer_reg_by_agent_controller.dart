import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import 'customer_reg_by_agent_data_source.dart';
import 'model/customer_reg_by_agent_request.dart';
import 'model/customer_reg_by_agent_response.dart';


class CustomerRegByAgentController extends StateNotifier<AsyncValue<CustomerRegByAgentResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  CustomerRegByAgentController(this._ref) : super(AsyncData(CustomerRegByAgentResponse()));

  Future<void> customerRegByAgent(CustomerRegByAgentRequest customerRegByAgentRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(customerRegByAgentDataSourceProvider).customerRegByAgent(customerRegByAgentRequest);

      safeApiCall<CustomerRegByAgentResponse>(response, onSuccess: (response) {

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

final customerRegByAgentControllerProvider =
StateNotifierProvider<CustomerRegByAgentController, AsyncValue<CustomerRegByAgentResponse>>((ref) {
  return CustomerRegByAgentController(ref);
});