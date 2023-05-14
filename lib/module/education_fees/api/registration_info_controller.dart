import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:red_cash_dfs_flutter/module/education_fees/api/registration_info_data_source.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import '../../statements/education_fees/data/statement_edu_data_controller.dart';
import 'model/school_fees_request.dart';
import 'model/school_fees_response.dart';

/// Created by Md. Awon-Uz-Zaman on 29/January/2023

class RegistrationInfoController extends StateNotifier<AsyncValue<SchoolFeesResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  RegistrationInfoController(this._ref) : super(AsyncData(SchoolFeesResponse()));

  Future<void> getFees(SchoolFeesRequest schoolFeesRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref
          .read(schoolFeesDataSourceProvider)
          .getFees(SchoolFeesRequest(insCode: schoolFeesRequest.insCode, regId: schoolFeesRequest.regId));

      safeApiCall<SchoolFeesResponse>(response, onSuccess: (response) {
        state = AsyncData(response!);

        StatementEduDataController.instance.eduInfo.insName = response.institutionName;
        StatementEduDataController.instance.eduInfo.studentName = response.studentName;



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

final registrationInfoControllerProvider = StateNotifierProvider<RegistrationInfoController, AsyncValue<SchoolFeesResponse>>((ref) {
  return RegistrationInfoController(ref);
});
