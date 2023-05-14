import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/upload_nid_reponse.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 12,February,2023.

abstract class UploadNidDataSource {
  Future<BaseResult<UploadNidResponse>> uploadNid(FormData formData);
}

class UploadNidDataSourceImpl extends BaseDataSource
    implements UploadNidDataSource {
  UploadNidDataSourceImpl(super.dio);

  @override
  Future<BaseResult<UploadNidResponse>> uploadNid(FormData formData) {
    return getResult(postFormData(ApiUrls.ekycUploadNid, formData),
        (response) => UploadNidResponse.fromJson(response));
  }
}

final uploadNidDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return UploadNidDataSourceImpl(dio);
});
