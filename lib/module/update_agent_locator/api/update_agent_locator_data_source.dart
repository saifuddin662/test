import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/update_agent_locator_request.dart';
import 'model/update_agent_locator_response.dart';


abstract class UpdateAgentLocatorDataSource {
  Future<BaseResult<UpdateAgentLocatorResponse>> updateAgentLocator(UpdateAgentLocatorRequest updateAgentLocatorRequest);
}

class UpdateAgentLocatorDataSourceImpl extends BaseDataSource implements UpdateAgentLocatorDataSource {
  UpdateAgentLocatorDataSourceImpl(super.dio);

  @override
  Future<BaseResult<UpdateAgentLocatorResponse>> updateAgentLocator(UpdateAgentLocatorRequest updateAgentLocatorRequest) {
    return getResult(
        post(ApiUrls.updateAgentLocator,
            updateAgentLocatorRequest.toJson()),
            (response) => UpdateAgentLocatorResponse.fromJson(response)
    );
  }
}

final updateAgentLocatorDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return UpdateAgentLocatorDataSourceImpl(dio);
});
