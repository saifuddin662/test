import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import 'get_all_requests_data_source.dart';
import 'model/get_all_requests_response.dart';


class GetAllRequestsController extends StateNotifier<AsyncValue<GetAllRequestsResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  GetAllRequestsController(this._ref) : super(AsyncData(GetAllRequestsResponse()));

  Future<void> getAllRequestsList() async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(getAllRequestsDataSourceProvider).getAllRequestsList();

      safeApiCall<GetAllRequestsResponse>(response, onSuccess: (response) {

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

final getAllRequestsControllerProvider = StateNotifierProvider<GetAllRequestsController, AsyncValue<GetAllRequestsResponse>>((ref) {
  return GetAllRequestsController(ref);
}
);