//ref.read(asyncRegModelProvider).name = "SHAJ";
//String name = _ref.read(asyncRegModelProvider).name;
//log.info("name --------------> $name");

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/network_provider.dart';
import '../../../core/networking/base/base_data_source.dart';
import '../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/device_reg_model.dart';
import 'model/device_reg_response.dart';

abstract class DeviceRegDataSource {
  Future<BaseResult<DeviceRegResponse>> checkDevice (DeviceRegModel deviceRegModel);
}

class DeviceRegDataSourceImpl extends BaseDataSource implements DeviceRegDataSource {
  DeviceRegDataSourceImpl(super.dio);

  @override
  Future<BaseResult<DeviceRegResponse>> checkDevice(DeviceRegModel deviceRegModel) {
    return getResult(
        post(
            ApiUrls.checkDevice,
            deviceRegModel.toJson()),
            (response) => DeviceRegResponse.fromJson(response)
    );
  }
}

final deviceRegDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return DeviceRegDataSourceImpl(dio);
});