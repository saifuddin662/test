import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import 'change_pin_data_source.dart';
import 'model/change_pin_request.dart';
import 'model/change_pin_response.dart';


class ChangePinController extends StateNotifier<AsyncValue<ChangePinResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;

  ChangePinController(this._ref) : super(AsyncData(ChangePinResponse()));

  Future<void> changePin(ChangePinRequest changePinRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref.read(changePinDataSourceProvider).changePin(
          ChangePinRequest(
              oldPin: changePinRequest.oldPin,
              newPin: changePinRequest.newPin,
          )
      );

      safeApiCall<ChangePinResponse>(response, onSuccess: (response) {

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

final changePinControllerProvider =
StateNotifierProvider<ChangePinController, AsyncValue<ChangePinResponse>>((ref) {
  return ChangePinController(ref);
});