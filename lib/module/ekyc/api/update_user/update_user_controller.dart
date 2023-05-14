import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:red_cash_dfs_flutter/module/ekyc/api/update_user/update_user_data_source.dart';
import '../../../../core/di/core_providers.dart';
import '../../../../core/di/singleton_provider.dart';
import '../../../../core/local/services/local_pref_service.dart';
import '../../../../core/networking/error/failure.dart';
import '../../../../core/networking/safe_api_call.dart';
import 'model/update_user_response.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 18,February,2023.

class UpdateUserController
    extends StateNotifier<AsyncValue<UpdateUserResponse>> {
  Logger get log => Logger(runtimeType.toString());
  final Ref _ref;
  final LocalPrefService _prefs;

  UpdateUserController(this._ref, this._prefs)
      : super(AsyncData(UpdateUserResponse()));

  Future<void> updateUser() async {
    try {
      state = const AsyncLoading();

      final ekycInfo = _ref.read(globalDataControllerProvider).ekycInfos;
      final walletInfo = _ref.watch(globalDataControllerProvider).walletData;

      final mobileNo = walletInfo.phoneNo;
      final walletNo = walletInfo.walletNo;
      final fullName = walletInfo.fullName;
      final dob = walletInfo.dob;
      final nid = walletInfo.nid;
      final nidAddress = walletInfo.presentAddress;

      FormData formData = FormData.fromMap(
        {
          "nid_no": nid,
          "dob": dob,
          "applicant_name_ben": "NONE",
          "applicant_name_eng": fullName,
          "father_name": ekycInfo.fatherName,
          "mother_name": ekycInfo.motherName,
          "pres_address": ekycInfo.pres_address,
          "perm_address": ekycInfo.perm_address,
          "gender": ekycInfo.gender,
          "profession": ekycInfo.profession,
          "nominee": ekycInfo.nominee,
          "nominee_relation": ekycInfo.nominee_relation,
          "mobile_number": mobileNo,
          "wallet_no": walletNo,
          "blood_group": ekycInfo.blood_group,
          "district": ekycInfo.districtPresent,
          "division": ekycInfo.divisionPresent,
          "thana": ekycInfo.thanaPresent,
          "income_amount": ekycInfo.income_amount,
          "nid_address": nidAddress,
          "nominee_dob": ekycInfo.nominee_dob,
          "nominee_mobile": ekycInfo.nominee_mobile,
          "nominee_nid": ekycInfo.nominee_nid,
          "nominee_percentage": ekycInfo.nominee_percentage,
          "post_code": ekycInfo.post_code_present,
          "post_office": ekycInfo.post_office_present,
          "source_of_income": ekycInfo.source_of_income,
        },
      );

      final response =
          await _ref.read(updateUserDataSourceProvider).updateUser(formData);

      safeApiCall<UpdateUserResponse>(response, onSuccess: (response) {
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

final updateUserControllerProvider =
    StateNotifierProvider<UpdateUserController, AsyncValue<UpdateUserResponse>>(
        (ref) {
  final prefs = ref.watch(localPrefProvider);
  return UpdateUserController(ref, prefs);
});
