import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/update_user_response.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 18,February,2023.

abstract class UpdateUserDataSource {
  Future<BaseResult<UpdateUserResponse>> updateUser(FormData formData);
}

class UpdateUserDataSourceImpl extends BaseDataSource
    implements UpdateUserDataSource {
  UpdateUserDataSourceImpl(super.dio);

  @override
  Future<BaseResult<UpdateUserResponse>> updateUser(FormData formData) {
    return getResult(postFormData(ApiUrls.ekycUpdateUser, formData),
            (response) => UpdateUserResponse.fromJson(response));
  }
}

final updateUserDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return UpdateUserDataSourceImpl(dio);
});