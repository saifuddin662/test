import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/di/network_provider.dart';
import '../../../../../core/networking/base/base_data_source.dart';
import '../../../../../core/networking/base/base_result.dart';
import '../../../../../utils/api_urls.dart';
import 'model/validate_reg_otp_request.dart';
import 'model/validate_reg_otp_response.dart';

abstract class ValidateRegOtpDataSource {
  Future<BaseResult<ValidateRegOtpResponse>> validateRegOtp(
      ValidateRegOtpRequest validateRegOtpRequest);
}

class ValidateRegOtpDataSourceImpl extends BaseDataSource
    implements ValidateRegOtpDataSource {
  ValidateRegOtpDataSourceImpl(super.dio);

  @override
  Future<BaseResult<ValidateRegOtpResponse>> validateRegOtp(
      ValidateRegOtpRequest validateRegOtpRequest) {
    return getResult(
        post(ApiUrls.otpRegValidate, validateRegOtpRequest.toJson()),
        (response) => ValidateRegOtpResponse.fromJson(response));
  }
}

final validateRegOtpDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return ValidateRegOtpDataSourceImpl(dio);
});
