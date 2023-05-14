import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/agent_cash_out_dis_info_request.dart';
import 'model/agent_cash_out_dis_info_response.dart';


abstract class AgentCashOutDisInfoDataSource {
  Future<BaseResult<AgentCashOutDisInfoResponse>> getDistributorInfo(AgentCashOutDisInfoRequest agentCashOutDisInfoRequest);
}

class AgentCashOutDisInfoDataSourceImpl extends BaseDataSource implements AgentCashOutDisInfoDataSource {
  AgentCashOutDisInfoDataSourceImpl(super.dio);

  @override
  Future<BaseResult<AgentCashOutDisInfoResponse>> getDistributorInfo(AgentCashOutDisInfoRequest agentCashOutDisInfoRequest) {
    return getResult(
        get(ApiUrls.getDisInfoByAgent,
            params: agentCashOutDisInfoRequest.toJson()),
            (response) => AgentCashOutDisInfoResponse.fromJson(response)
    );
  }
}

final agentCashOutDisInfoDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return AgentCashOutDisInfoDataSourceImpl(dio);
});
