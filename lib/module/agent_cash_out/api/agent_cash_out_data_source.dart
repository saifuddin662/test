import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/agent_cash_out_request.dart';
import 'model/agent_cash_out_response.dart';


abstract class AgentCashOutDataSource {
  Future<BaseResult<AgentCashOutResponse>> agentCashOut(AgentCashOutRequest agentCashOutRequest);
}

class AgentCashOutDataSourceImpl extends BaseDataSource implements AgentCashOutDataSource {
  AgentCashOutDataSourceImpl(super.dio);

  @override
  Future<BaseResult<AgentCashOutResponse>> agentCashOut(AgentCashOutRequest agentCashOutRequest) {
    return getResult(
        post(
            ApiUrls.agentCashOut,
            agentCashOutRequest.toJson()),
            (response) => AgentCashOutResponse.fromJson(response)
    );
  }
}

final agentCashOutDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return AgentCashOutDataSourceImpl(dio);
});
