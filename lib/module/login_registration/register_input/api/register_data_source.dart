import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/register_request.dart';
import 'model/register_response.dart';


abstract class RegisterDataSource {
  Future<BaseResult<RegisterResponse>> getWallet(RegisterRequest registerRequest);
}

class RegisterDataSourceImpl extends BaseDataSource implements RegisterDataSource {
  RegisterDataSourceImpl(super.dio);

  @override
  Future<BaseResult<RegisterResponse>> getWallet(RegisterRequest registerRequest) async {
    return getResult(
        get(
        ApiUrls.apiGetWallet,
            params: {'msisdn': registerRequest.msisdn, 'userType': registerRequest.userType}),
            (response) => RegisterResponse.fromJson(response)
    );
  }
}

final registerDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return RegisterDataSourceImpl(dio);
});