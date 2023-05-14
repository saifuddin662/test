import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/di/network_provider.dart';
import '../../../../../core/networking/base/base_data_source.dart';
import '../../../../../core/networking/base/base_result.dart';
import '../../../../../utils/api_urls.dart';
import '../../../../login_registration/register_input/api/model/register_request.dart';
import 'model/ekyc_status_response.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 18,February,2023.

abstract class EkycStatusDataSource {
  Future<BaseResult<EkycStatusResponse>> getEkycStatus(RegisterRequest registerRequest);
}

class EkycStatusDataSourceImpl extends BaseDataSource
    implements EkycStatusDataSource {
  EkycStatusDataSourceImpl(super.dio);

  @override
  Future<BaseResult<EkycStatusResponse>> getEkycStatus(RegisterRequest registerRequest) {
    return getResult(
        get(ApiUrls.ekycStatus,
            params: registerRequest.toJson()),
        (response) => EkycStatusResponse.fromJson(response));
  }
}

final ekycStatusDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return EkycStatusDataSourceImpl(dio);
});
