import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/config_response.dart';

abstract class ConfigDataSource {
  Future<BaseResult<ConfigResponse>> getConfig();
}

class ConfigDataSourceImpl extends BaseDataSource implements ConfigDataSource {
  ConfigDataSourceImpl(super.dio);

  @override
  Future<BaseResult<ConfigResponse>> getConfig() async {
    return getResult(get(ApiUrls.appForceUpdateWithConfig), (response) => ConfigResponse.fromJson(response));
  }
}

final configDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return ConfigDataSourceImpl(dio);
});
