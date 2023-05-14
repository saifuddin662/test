import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:red_cash_dfs_flutter/module/top_up_agent/api/top_up_agent_list_data_source.dart';
import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import 'model/top_up_agent_list_response.dart';


class TopUpAgentListController extends StateNotifier<AsyncValue<TopUpAgentListResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  TopUpAgentListController(this._ref) : super(AsyncData(TopUpAgentListResponse()));

  Future<void> getAgentList() async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(topUpAgentListDataSourceProvider).getAgentList();

      safeApiCall<TopUpAgentListResponse>(response, onSuccess: (response) {

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

final topUpAgentListControllerProvider =
StateNotifierProvider<TopUpAgentListController, AsyncValue<TopUpAgentListResponse>>((ref) {
  return TopUpAgentListController(ref);
});