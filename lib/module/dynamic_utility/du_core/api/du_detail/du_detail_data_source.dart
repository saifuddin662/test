import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/dynamic_utility/du_core/api/du_detail/model/utility_detail_response.dart';
import 'package:red_cash_dfs_flutter/utils/api_urls.dart';
import '../../../../../core/di/network_provider.dart';
import '../../../../../core/networking/base/base_data_source.dart';
import '../../../../../core/networking/base/base_result.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 08,March,2023.

abstract class DuDetailDataSource {
  Future<BaseResult<UtilityDetailResponse>> utilityDetail(String utilityCode);
}

class DuDetailDataSourceImpl extends BaseDataSource
    implements DuDetailDataSource {
  DuDetailDataSourceImpl(super.dio);

  @override
  Future<BaseResult<UtilityDetailResponse>> utilityDetail(String utilityCode) {
    return getResult(
        get(ApiUrls.duDetail,
            params: {
              "utilityCode": utilityCode
            }),
        (response) => UtilityDetailResponse.fromJson(response));
  }
}

final utilityDetailDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return DuDetailDataSourceImpl(dio);
});
