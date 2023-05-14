import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/verify_ekyc_response.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 13,February,2023.

abstract class VerifyEkycDataSource {
  Future<BaseResult<VerifyEkycResponse>> verifyEkyc(FormData formData);
}

class VerifyEkycDataSourceImpl extends BaseDataSource
    implements VerifyEkycDataSource {
  VerifyEkycDataSourceImpl(super.dio);

  @override
  Future<BaseResult<VerifyEkycResponse>> verifyEkyc(FormData formData) {
    return getResult(postFormData(ApiUrls.ekycVerify, formData),
            (response) => VerifyEkycResponse.fromJson(response));
  }
}

final verifyEkycDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return VerifyEkycDataSourceImpl(dio);
});
