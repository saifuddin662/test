import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/login_request.dart';
import 'model/login_response.dart';


abstract class LoginDataSource {
  Future<BaseResult<LoginResponse>> login(LoginRequest loginRequest);
}

class LoginDataSourceImpl extends BaseDataSource implements LoginDataSource {
  LoginDataSourceImpl(super.dio);

  @override
  Future<BaseResult<LoginResponse>> login(LoginRequest loginRequest) {
    return getResult(
        post(
            ApiUrls.loginApi,
            {
              'msisdn': loginRequest.msisdn,
              'pin': loginRequest.pin,
              'deviceId': loginRequest.deviceId
            }),
            (response) => LoginResponse.fromJson(response)
    );
  }
}

final loginDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return LoginDataSourceImpl(dio);
});
