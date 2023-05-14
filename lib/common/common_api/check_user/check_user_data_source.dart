import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/check_user_response.dart';


abstract class CheckUserDataSource {
  Future<BaseResult<CheckUserResponse>> checkUser(String userNumber);
}

class CheckUserDataSourceImpl extends BaseDataSource implements CheckUserDataSource {
  CheckUserDataSourceImpl(super.dio);

  @override
  Future<BaseResult<CheckUserResponse>> checkUser(String userNumber) {
    return getResult(
        get(
            ApiUrls.checkUserTypeApi,
            params: {
              "userNumber": userNumber
            }),
            (response) => CheckUserResponse.fromJson(response)
    );
  }
}

final checkUserDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return CheckUserDataSourceImpl(dio);
});
