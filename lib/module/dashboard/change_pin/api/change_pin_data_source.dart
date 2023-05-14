import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/change_pin_request.dart';
import 'model/change_pin_response.dart';


abstract class ChangePinDataSource {
  Future<BaseResult<ChangePinResponse>> changePin(ChangePinRequest changePinRequest);
}

class ChangePinDataSourceImpl extends BaseDataSource implements ChangePinDataSource {
  ChangePinDataSourceImpl(super.dio);

  @override
  Future<BaseResult<ChangePinResponse>> changePin(ChangePinRequest changePinRequest) {
    return getResult(
        post(
            ApiUrls.changePinApi,
            {
              'oldPin': changePinRequest.oldPin,
              'newPin': changePinRequest.newPin,
            }),
            (response) => ChangePinResponse.fromJson(response)
    );
  }
}

final changePinDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return ChangePinDataSourceImpl(dio);
});
