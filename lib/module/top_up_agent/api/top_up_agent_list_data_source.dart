import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/top_up_agent_list_response.dart';

abstract class TopUpAgentListDataSource {
  Future<BaseResult<TopUpAgentListResponse>> getAgentList();
}

class TopUpAgentListDataSourceImpl extends BaseDataSource implements TopUpAgentListDataSource {
  TopUpAgentListDataSourceImpl(super.dio);

  @override
  Future<BaseResult<TopUpAgentListResponse>> getAgentList() {
    return getResult(
        get(ApiUrls.getAgentListApi),
            (response) => TopUpAgentListResponse.fromJson(response)
    );
  }
}

final topUpAgentListDataSourceProvider = Provider.autoDispose((_) {
  final dio = _.watch(dioProvider);
  return TopUpAgentListDataSourceImpl(dio);
});