import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/agent_cash_in_request.dart';
import 'model/agent_cash_in_response.dart';


abstract class AgentCashInDataSource {
  Future<BaseResult<AgentCashInResponse>> agentCashIn(AgentCashInRequest agentCashInRequest);
}

class AgentCashInDataSourceImpl extends BaseDataSource implements AgentCashInDataSource {
  AgentCashInDataSourceImpl(super.dio);

  @override
  Future<BaseResult<AgentCashInResponse>> agentCashIn(AgentCashInRequest agentCashInRequest) {
    return getResult(
        post(
            ApiUrls.agentCashIn,
            agentCashInRequest.toJson()),
            (response) => AgentCashInResponse.fromJson(response)
    );
  }
}

final agentCashInDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return AgentCashInDataSourceImpl(dio);
});
