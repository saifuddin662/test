import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/agent_locator_response.dart';


abstract class AgentLocatorDataSource {
  Future<BaseResult<AgentLocatorInResponse>> getAgentLocationData(double latitude, double longitude);
}

class AgentLocatorDataSourceImpl extends BaseDataSource implements AgentLocatorDataSource {
  AgentLocatorDataSourceImpl(super.dio);

  @override
  Future<BaseResult<AgentLocatorInResponse>> getAgentLocationData(latitude, longitude) {
    return getResult(
        get(
            ApiUrls.getNearestAgent,
            params: {
              "latitude": latitude,
              "longitude": longitude
            }
        ), (response) => AgentLocatorInResponse.fromJson(response));
  }
}

final agentLocatorDataSourceProvider = Provider.autoDispose((_) {
  final dio = _.watch(dioProvider);
  return AgentLocatorDataSourceImpl(dio);
});