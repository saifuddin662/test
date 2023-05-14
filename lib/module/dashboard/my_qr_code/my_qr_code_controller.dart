import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import 'api/model/my_qr_code_request.dart';
import 'api/model/my_qr_code_response.dart';
import 'api/my_qr_code_data_source.dart';


class MyQrCodeController extends StateNotifier<AsyncValue<MyQrCodeResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  MyQrCodeController(this._ref) : super(AsyncData(MyQrCodeResponse()));

  Future<void> getMyQrCode(MyQrCodeRequest myQrCodeRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(myQrCodeSourceProvider).getMyQrCode(
          MyQrCodeRequest(
            walletNo: myQrCodeRequest.walletNo,
            walletType: myQrCodeRequest.walletType,
          )
      );

      safeApiCall<MyQrCodeResponse>(response, onSuccess: (response) {

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

final myQrCodeControllerProvider =
StateNotifierProvider<MyQrCodeController, AsyncValue<MyQrCodeResponse>>((ref) {
  return MyQrCodeController(ref);
});