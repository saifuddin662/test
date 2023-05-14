import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:red_cash_dfs_flutter/module/dashboard/qr_code_scanner/api/qr_code_scanner_data_source.dart';
import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import 'model/qr_code_scanner_response.dart';


class QrCodeScannerController extends StateNotifier<AsyncValue<QrCodeScannerResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  QrCodeScannerController(this._ref) : super(AsyncData(QrCodeScannerResponse()));

  Future<void> getQrCodeDetails(String getQrCodeDetails) async {
    try {
      state = const AsyncLoading();

      final response = await
      _ref.read(qrCodeScannerDataSourceProvider).getQrCodeDetails(getQrCodeDetails);

      safeApiCall<QrCodeScannerResponse>(response, onSuccess: (response) {
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

final qrCodeScannerControllerProvider =
StateNotifierProvider<QrCodeScannerController, AsyncValue<QrCodeScannerResponse>>((ref) {
  return QrCodeScannerController(ref);
});

