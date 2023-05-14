/// Created by Md. Awon-Uz-Zaman on 31/January/2023

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import 'institution_list_data_source.dart';
import 'model/institute_list_response.dart';

class InstituteListController extends StateNotifier<AsyncValue<InstituteListResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  InstituteListController(this._ref) : super(AsyncData(InstituteListResponse()));

  Future<void> getInstituteList() async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(instituteListDataSourceProvider).getInstituteList();

      safeApiCall<InstituteListResponse>(response, onSuccess: (response) {
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

final instituteListControllerProvider = StateNotifierProvider<InstituteListController, AsyncValue<InstituteListResponse>>((ref) {
  return InstituteListController(ref);
});