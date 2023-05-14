import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/banner_list_request.dart';
import 'model/banners_list_response.dart';


abstract class BannerListDataSource {
  Future<BaseResult<BannersListResponse>> getBanners(BannerListRequest bannerListRequest);
}

class BannerListDataSourceImpl extends BaseDataSource implements BannerListDataSource {
  BannerListDataSourceImpl(super.dio);

  @override
  Future<BaseResult<BannersListResponse>> getBanners(BannerListRequest bannerListRequest) async {
    final getApiResult = getResult(
        get(ApiUrls.getBannersApi, params: bannerListRequest.toJson()),
            (response) => BannersListResponse.fromJson(response)
    );
    return getApiResult;
  }
}

final bannerListDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return BannerListDataSourceImpl(dio);
});