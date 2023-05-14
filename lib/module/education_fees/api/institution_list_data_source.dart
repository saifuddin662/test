/**
 * Created by Md. Awon-Uz-Zaman on 31/January/2023
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/institute_list_response.dart';

abstract class InstituteListDataSource {
  Future<BaseResult<InstituteListResponse>> getInstituteList();
}

class InstituteListDataSourceImpl extends BaseDataSource implements InstituteListDataSource {
  InstituteListDataSourceImpl(super.dio);

  @override
  Future<BaseResult<InstituteListResponse>> getInstituteList() {
    return getResult(
      get(ApiUrls.instituteList),
            (response) => InstituteListResponse.fromJson(response)
    );
  }
}

final instituteListDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return InstituteListDataSourceImpl(dio);
});
