import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/di/network_provider.dart';
import '../../../../../core/networking/base/base_data_source.dart';
import '../../../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/du_service_list_response.dart';


abstract class DuServiceDataSource {
  Future<BaseResult<DuServiceListResponse>> duService();
}

class DuServiceDataSourceImpl extends BaseDataSource
    implements DuServiceDataSource {
  DuServiceDataSourceImpl(super.dio);

  @override
  Future<BaseResult<DuServiceListResponse>> duService() {
    return getResult(
        get(ApiUrls.duServiceList),
                (response) => DuServiceListResponse.fromJson(response));
  }
}

final duServiceDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return DuServiceDataSourceImpl(dio);
});
