import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/device_validate_request.dart';
import 'model/device_validate_response.dart';


abstract class CheckOtpInputDataSource {
  Future<BaseResult<DeviceValidateResponse>> validateCheckOtp(DeviceValidateRequest deviceValidateRequest);
}

class CheckOtpInputDataSourceImpl extends BaseDataSource implements CheckOtpInputDataSource {
  CheckOtpInputDataSourceImpl(super.dio);

  @override
  Future<BaseResult<DeviceValidateResponse>> validateCheckOtp(DeviceValidateRequest deviceValidateRequest) {
    return getResult(
        post(
            ApiUrls.validateOtp,
            deviceValidateRequest.toJson()),
            (response) => DeviceValidateResponse.fromJson(response)
    );
  }
}

final checkOtpInputDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return CheckOtpInputDataSourceImpl(dio);
});