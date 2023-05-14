import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/di/network_provider.dart';
import '../../../../../core/networking/base/base_data_source.dart';
import '../../../../../core/networking/base/base_result.dart';
import '../../../../../utils/api_urls.dart';
import 'model/reg_otp_request.dart';
import 'model/reg_otp_response.dart';

abstract class RegOtpInputDataSource {
  Future<BaseResult<RegOtpResponse>> requestRegOtp(RegOtpRequest regOtpRequest);
}

class RegOtpInputDataSourceImpl extends BaseDataSource implements RegOtpInputDataSource {
  RegOtpInputDataSourceImpl(super.dio);

  @override
  Future<BaseResult<RegOtpResponse>> requestRegOtp(RegOtpRequest regOtpRequest) {
    return getResult(
        post(
            ApiUrls.otpRegGenerate,
            regOtpRequest.toJson()),
            (response) => RegOtpResponse.fromJson(response)
    );
  }
}

final regOtpInputDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return RegOtpInputDataSourceImpl(dio);
});