import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/feature_list_request.dart';
import 'model/feature_list_response.dart';


abstract class FeatureListDataSource {
  Future<BaseResult<FeatureListResponse>> getFeatureList(FeatureListRequest featureListRequest);
}

class FeatureListDataSourceImpl extends BaseDataSource implements FeatureListDataSource {
  FeatureListDataSourceImpl(super.dio);

  @override
  Future<BaseResult<FeatureListResponse>> getFeatureList(FeatureListRequest featureListRequest) async {
    final getApiResult = getResult(
        post(ApiUrls.featureListApi, featureListRequest.toJson()),
            (response) => FeatureListResponse.fromJson(response)
    );
    return getApiResult;
  }
}

final featureListDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return FeatureListDataSourceImpl(dio);
});