import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:red_cash_dfs_flutter/module/education_fees/api/model/EducationFeesRequest.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import '../../statements/education_fees/data/statement_edu_data_controller.dart';
import 'education_fees_data_source.dart';
import 'model/education_fees_response.dart';

/**
 * Created by Md. Awon-Uz-Zaman on 29/January/2023
 */

class EducationFeesController extends StateNotifier<AsyncValue<EducationFeesResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  EducationFeesController(this._ref) : super(AsyncData(EducationFeesResponse()));

  Future<void> educationFeePayment(EducationFeesRequest educationFeesRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref
          .read(educaitonFeesDataSourceProvider)
          .educationFeePayment(EducationFeesRequest(
          fromAc: educationFeesRequest.fromAc,
          pin: educationFeesRequest.pin, 
          schoolPaymentInfo: educationFeesRequest.schoolPaymentInfo, 
          toAc: educationFeesRequest.toAc, 
          userType: educationFeesRequest.userType));

      safeApiCall<EducationFeesResponse>(response, onSuccess: (response) {
        state = AsyncData(response!);

        StatementEduDataController.instance.eduInfo.amount = response.data!.amount.toString();
        StatementEduDataController.instance.eduInfo.charge = response.data!.fee.toString();
        StatementEduDataController.instance.eduInfo.txnId = response.data!.txnId.toString();

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

final educationFeesControllerProvider = StateNotifierProvider<
    EducationFeesController, AsyncValue<EducationFeesResponse>>((ref) {
  return EducationFeesController(ref);
});
