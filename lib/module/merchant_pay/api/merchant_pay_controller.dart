import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import 'merchant_pay_data_source.dart';
import 'model/merchant_pay_request.dart';
import 'model/merchant_pay_response.dart';


class MerchantPayController extends StateNotifier<AsyncValue<MerchantPayResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  MerchantPayController(this._ref) : super(AsyncData(MerchantPayResponse()));

  Future<void> merchantPay(MerchantPayRequest merchantPayRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(merchantPayDataSourceProvider).merchantPay(
          MerchantPayRequest(
              recipientNumber: merchantPayRequest.recipientNumber,
              amount: merchantPayRequest.amount,
              txnType: merchantPayRequest.txnType,
              pin: merchantPayRequest.pin
          )
      );

      safeApiCall<MerchantPayResponse>(response, onSuccess: (response) {

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

final merchantPayControllerProvider =
StateNotifierProvider<MerchantPayController, AsyncValue<MerchantPayResponse>>((ref) {
  return MerchantPayController(ref);
});