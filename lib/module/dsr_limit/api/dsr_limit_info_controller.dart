import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import 'dsr_limit_info_data_source.dart';
import 'model/dsr_limit_info_response.dart';


class DsrLimitInfoController extends StateNotifier<AsyncValue<DsrLimitInfoResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  DsrLimitInfoController(this._ref) : super(AsyncData(DsrLimitInfoResponse()));

  Future<void> getDsrLimitInfo() async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(dsrLimitInfoDataSourceProvider).getDsrLimitInfo();

      safeApiCall<DsrLimitInfoResponse>(response, onSuccess: (response) {

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

final dsrLimitInfoControllerProvider =
StateNotifierProvider<DsrLimitInfoController, AsyncValue<DsrLimitInfoResponse>>((ref) {
  return DsrLimitInfoController(ref);
}
);