import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import 'mobile_recharge_data_source.dart';
import 'model/mobile_recharge_request.dart';
import 'model/mobile_recharge_response.dart';

/// Created by Md. Awon-Uz-Zaman on 29/January/2023


class MobileRechargeController extends StateNotifier<AsyncValue<MobileRechargeResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  MobileRechargeController(this._ref) : super(AsyncData(MobileRechargeResponse()));

  Future<void> mobileRecharge(MobileRechargeRequest mobileRechargeRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref
          .read(mobileRechargeDataSourceProvider)
          .mobileRecharge(MobileRechargeRequest(
              secretKey: mobileRechargeRequest.secretKey,
              recipientNumber: mobileRechargeRequest.recipientNumber,
              amount: mobileRechargeRequest.amount,
              connectionType: mobileRechargeRequest.connectionType,
              operator: mobileRechargeRequest.operator,
              isBundle: mobileRechargeRequest.isBundle,
              pin: mobileRechargeRequest.pin));

      safeApiCall<MobileRechargeResponse>(response, onSuccess: (response) {
        state = AsyncData(response!);
      }, onError: (code, message) {
        state = AsyncError(
          message,
          StackTrace.current,
        );
      });
    } on Failure {
      state = AsyncError("error", StackTrace.current);
    }
  }
}

final mobileRechargeControllerProvider = StateNotifierProvider<
    MobileRechargeController, AsyncValue<MobileRechargeResponse>>((ref) {
  return MobileRechargeController(ref);
});
