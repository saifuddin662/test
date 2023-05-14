import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../../core/di/core_providers.dart';
import '../../../../core/di/singleton_provider.dart';
import '../../../../core/local/services/local_pref_service.dart';
import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../../../../utils/pref_keys.dart';
import '../../../login_registration/register_input/api/model/register_request.dart';
import '../../ekyc_core/ekyc_status_type.dart';
import 'api/ekyc_status_data_source.dart';
import 'api/model/ekyc_status_response.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 18,February,2023.

class EkycStatusController
    extends StateNotifier<AsyncValue<EkycStatusResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  final LocalPrefService _prefs;

  EkycStatusController(this._ref, this._prefs)
      : super(AsyncData(EkycStatusResponse()));

  Future<void> getEkycStatus(RegisterRequest registerRequest) async {
    try {
      state = const AsyncLoading();

      final response = await _ref
          .read(ekycStatusDataSourceProvider)
          .getEkycStatus(registerRequest);

      safeApiCall<EkycStatusResponse>(response, onSuccess: (response) {
        final ekycStatus = response!;

        _ref.watch(globalDataControllerProvider).ekycState =
            ekycStatus.walletStatus!;

        if (ekycStatus.walletStatus == EkycStatus.NEW.name) {
          _prefs.setString(PrefKeys.keyPhoneNo, registerRequest.msisdn);
          log.info("new user");
        } else if (ekycStatus.walletStatus == EkycStatus.ACTIVE.name) {
          log.info("active user");
          storeMsisdnData(ekycStatus);
        } else if (ekycStatus.walletStatus == EkycStatus.PARTIAL.name) {
          log.info("partially active user");
          storeMsisdnData(ekycStatus);
          //save wallet data
          _ref.watch(globalDataControllerProvider).walletData = ekycStatus.walletData!;
        } else if (ekycStatus.walletStatus == EkycStatus.INCOMPLETE.name) {
          //goto otp
        } else if (ekycStatus.walletStatus == EkycStatus.SUBMITTED.name) {
          //goto ekyc pending screen
        } else if (ekycStatus.walletStatus == EkycStatus.FAILED.name) {
          //todo failed status could be smaller letter text
          //goto otp
        } else if (ekycStatus.walletStatus == EkycStatus.INVALID.name) {
          //EKYC verification failed, please try again later
          //goto otp
        } else if (ekycStatus.walletStatus ==
            EkycStatus.WALLET_CREATION_FAILED.name) {
          //show error from server
        } else {
          log.info("wallet not found");
        }

        state = AsyncData(response);
      }, onError: (code, message) {
        state = AsyncError(
          message,
          StackTrace.current,
        );
        log.info(
            "------------------------- ERROR > code: $code, msg: $message");
      });
    } on Failure {
      state = AsyncError("error", StackTrace.current);
    }
  }

  void storeMsisdnData(EkycStatusResponse ekycStatus) {
    log.info("saving msisdn no : ${ekycStatus.walletData?.walletNo} in prefs");
    _prefs.setString(PrefKeys.keyMsisdn, ekycStatus.walletData?.walletNo ?? "");
    _prefs.setString(PrefKeys.keyPhoneNo, ekycStatus.walletData?.phoneNo ?? "");
  }
}

final ekycStatusControllerProvider =
    StateNotifierProvider<EkycStatusController, AsyncValue<EkycStatusResponse>>(
        (ref) {
  final prefs = ref.watch(localPrefProvider);
  return EkycStatusController(ref, prefs);
});
