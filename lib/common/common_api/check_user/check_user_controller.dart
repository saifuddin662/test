import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../core/networking/error/failure.dart';
import '../../../core/networking/safe_api_call.dart';
import 'check_user_data_source.dart';
import 'model/check_user_response.dart';


class CheckUserController extends StateNotifier<AsyncValue<CheckUserResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  CheckUserController(this._ref) : super(AsyncData(CheckUserResponse()));

  Future<void> checkUser(String userNumber) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(checkUserDataSourceProvider).checkUser(userNumber);

      safeApiCall<CheckUserResponse>(response, onSuccess: (response) {

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

final checkUserControllerProvider = StateNotifierProvider<CheckUserController, AsyncValue<CheckUserResponse>>((ref) {
  return CheckUserController(ref);
});