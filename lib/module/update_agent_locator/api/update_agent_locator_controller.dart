import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:red_cash_dfs_flutter/module/update_agent_locator/api/update_agent_locator_data_source.dart';

import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import 'model/update_agent_locator_request.dart';
import 'model/update_agent_locator_response.dart';


class UpdateAgentLocatorController extends StateNotifier<AsyncValue<UpdateAgentLocatorResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  UpdateAgentLocatorController(this._ref) : super(AsyncData(UpdateAgentLocatorResponse()));

  Future<void> updateAgentLocator(UpdateAgentLocatorRequest updateAgentLocatorRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(updateAgentLocatorDataSourceProvider).updateAgentLocator(updateAgentLocatorRequest);

      safeApiCall<UpdateAgentLocatorResponse>(response, onSuccess: (response) {

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

final updateAgentLocatorControllerProvider =
StateNotifierProvider<UpdateAgentLocatorController, AsyncValue<UpdateAgentLocatorResponse>>((ref) {
  return UpdateAgentLocatorController(ref);
});