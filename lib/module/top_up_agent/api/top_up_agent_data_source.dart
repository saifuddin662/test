import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/top_up_agent_request.dart';
import 'model/top_up_agent_response.dart';


abstract class TopUpAgentDataSource {
  Future<BaseResult<TopUpAgentResponse>> topUpAgent(TopUpAgentRequest topUpAgentRequest);
}

class TopUpAgentDataSourceImpl extends BaseDataSource implements TopUpAgentDataSource {
  TopUpAgentDataSourceImpl(super.dio);

  @override
  Future<BaseResult<TopUpAgentResponse>> topUpAgent(TopUpAgentRequest topUpAgentRequest) {
    return getResult(
        post(
            ApiUrls.transactionApi,
            topUpAgentRequest.toJson()),
            (response) => TopUpAgentResponse.fromJson(response)
    );
  }
}

final topUpAgentDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return TopUpAgentDataSourceImpl(dio);
});
