import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/dsr_limit_info_response.dart';


abstract class DsrLimitInfoDataSource {
  Future<BaseResult<DsrLimitInfoResponse>> getDsrLimitInfo();
}

class DsrLimitInfoDataSourceImpl extends BaseDataSource implements DsrLimitInfoDataSource {
  DsrLimitInfoDataSourceImpl(super.dio);

  @override
  Future<BaseResult<DsrLimitInfoResponse>> getDsrLimitInfo() {
    return getResult(get(ApiUrls.getDsrLimitInfo), (response) => DsrLimitInfoResponse.fromJson(response));
  }
}

final dsrLimitInfoDataSourceProvider = Provider.autoDispose((_) {
  final dio = _.watch(dioProvider);
  return DsrLimitInfoDataSourceImpl(dio);
});