import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../../../common/toasts.dart';
import '../../../core/context_holder.dart';
import '../agent_locator_screen.dart';
import 'agent_locator_data_source.dart';
import 'model/agent_locator_response.dart';


class AgentLocatorController extends StateNotifier<AsyncValue<AgentLocatorInResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  AgentLocatorController(this._ref) : super(AsyncData(AgentLocatorInResponse()));

  Future<void> getNearbyAgentData(double latitude, double longitude) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(agentLocatorDataSourceProvider).getAgentLocationData(latitude, longitude);

      safeApiCall<AgentLocatorInResponse>(response, onSuccess: (response) {

        state = AsyncData(response!);
        EasyLoading.dismiss();
        Navigator.push(ContextHolder.navKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => const AgentLocatorScreen()
            )
        );

      }, onError: (code, message) {
        EasyLoading.dismiss();
        Toasts.showErrorToast(message);
        state = AsyncError(
          message,
          StackTrace.current,
        );
        debugPrint("------------------------- ERROR > code: $code, msg: $message");
      });
    } on Failure {
      EasyLoading.dismiss();
      state = AsyncError("error",StackTrace.current);
    }
  }
}

final agentLocatorControllerProvider =
StateNotifierProvider<AgentLocatorController, AsyncValue<AgentLocatorInResponse>>((ref) {
  return AgentLocatorController(ref);
});