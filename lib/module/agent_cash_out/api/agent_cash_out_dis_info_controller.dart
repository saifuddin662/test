import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../common/toasts.dart';
import '../../../core/context_holder.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import '../agent_cash_out_enter_amount_screen.dart';
import 'agent_cash_out_dis_info_data_source.dart';
import 'model/agent_cash_out_dis_info_request.dart';
import 'model/agent_cash_out_dis_info_response.dart';


class AgentCashOutDisInfoController extends StateNotifier<AsyncValue<AgentCashOutDisInfoResponse>> {

  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  AgentCashOutDisInfoController(this._ref) : super(AsyncData(AgentCashOutDisInfoResponse()));

  Future<void> getDistributorInfo(AgentCashOutDisInfoRequest agentCashOutDisInfoRequest) async {
    try {
      EasyLoading.show();
      final response = await _ref.read(agentCashOutDisInfoDataSourceProvider).getDistributorInfo(agentCashOutDisInfoRequest);

      safeApiCall<AgentCashOutDisInfoResponse>(response, onSuccess: (response) {

        EasyLoading.dismiss();
        Navigator.push(ContextHolder.navKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => AgentCashOutEnterAmountScreen(
                    recipientName: response?.data?.name ?? "N/A",
                    recipientNumber: response?.data?.walletNo ?? ""
                )
            )
        );

      }, onError: (code, message) {

        EasyLoading.dismiss();
        Toasts.showErrorToast(message);
      });
    } on Failure {
      EasyLoading.dismiss();
    }
  }
}

final agentCashOutDisInfoControllerProvider =
StateNotifierProvider<AgentCashOutDisInfoController, AsyncValue<AgentCashOutDisInfoResponse>>((ref) {
  return AgentCashOutDisInfoController(ref);
});