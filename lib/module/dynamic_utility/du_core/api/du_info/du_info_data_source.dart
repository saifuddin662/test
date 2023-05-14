import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/utils/api_urls.dart';
import '../../../../../core/di/network_provider.dart';
import '../../../../../core/networking/base/base_data_source.dart';
import '../../../../../core/networking/base/base_result.dart';
import 'model/utility_info_request.dart';
import 'model/utility_info_response.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 14,March,2023.

abstract class DuInfoDataSource {
  Future<BaseResult<UtilityInfoResponse>> utilityInfo(
      UtilityInfoRequest utilityInfoRequest);
}

class DuInfoDataSourceImpl extends BaseDataSource implements DuInfoDataSource {
  DuInfoDataSourceImpl(super.dio);

  @override
  Future<BaseResult<UtilityInfoResponse>> utilityInfo(
      UtilityInfoRequest utilityInfoRequest) {
    return getResult(
        post(
            ApiUrls.duBillInfo,
            utilityInfoRequest.toMap()),
        (response) => UtilityInfoResponse.fromJson(response));
  }
}

final utilityInfoDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return DuInfoDataSourceImpl(dio);
});
