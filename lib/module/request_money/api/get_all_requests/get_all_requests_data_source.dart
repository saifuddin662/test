import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/get_all_requests_response.dart';


abstract class GetAllRequestsDataSource {
  Future<BaseResult<GetAllRequestsResponse>> getAllRequestsList();
}

class GetAllRequestsDataSourceImpl extends BaseDataSource implements GetAllRequestsDataSource {
  GetAllRequestsDataSourceImpl(super.dio);

  @override
  Future<BaseResult<GetAllRequestsResponse>> getAllRequestsList() {
    return getResult(get(ApiUrls.getAllRequestsApi), (response) => GetAllRequestsResponse.fromJson(response));
  }
}

final getAllRequestsDataSourceProvider = Provider.autoDispose((_) {
  final dio = _.watch(dioProvider);
  return GetAllRequestsDataSourceImpl(dio);
});