import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/customer_reg_by_agent_request.dart';
import 'model/customer_reg_by_agent_response.dart';


abstract class CustomerRegByAgentDataSource {
  Future<BaseResult<CustomerRegByAgentResponse>> customerRegByAgent(CustomerRegByAgentRequest customerRegByAgentRequest);
}

class CustomerRegByAgentDataSourceImpl extends BaseDataSource implements CustomerRegByAgentDataSource {
  CustomerRegByAgentDataSourceImpl(super.dio);

  @override
  Future<BaseResult< CustomerRegByAgentResponse>> customerRegByAgent(CustomerRegByAgentRequest customerRegByAgentRequest) {
    return getResult(
        post(
            ApiUrls.customerRegByAgentApi,
            customerRegByAgentRequest.toJson()),
            (response) =>  CustomerRegByAgentResponse.fromJson(response)
    );
  }
}

final customerRegByAgentDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return   CustomerRegByAgentDataSourceImpl(dio);
});
