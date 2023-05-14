import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import 'du_service_data_source.dart';
import 'model/du_service_list_response.dart';

class DuServiceController extends StateNotifier<AsyncValue<DuServiceListResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  DuServiceController(this._ref) : super(AsyncData(DuServiceListResponse(services: [])));

  Future<void> duService() async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(duServiceDataSourceProvider).duService();

      safeApiCall<DuServiceListResponse>(response, onSuccess: (response) {
        state = AsyncData(response!);
      }

          , onError: (code, message) {
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

final duServiceControllerProvider = StateNotifierProvider<DuServiceController, AsyncValue<DuServiceListResponse>>((ref) {
  return DuServiceController(ref);
});

