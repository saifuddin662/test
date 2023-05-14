import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/district_list_response.dart';
import 'model/division_list_response.dart';
import 'model/upazila_list_response.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 16,February,2023.

abstract class DivisionDataSource {
  Future<BaseResult<DivisionListResponse>> getDivision();
}

abstract class DistrictDataSource {
  Future<BaseResult<DistrictListResponse>> getDistrict(int id);
}

abstract class UpazilaDataSource {
  Future<BaseResult<UpazilaListResponse>> getUpazila(int id);
}

class DivisionDataSourceImpl extends BaseDataSource
    implements DivisionDataSource {
  DivisionDataSourceImpl(super.dio);

  @override
  Future<BaseResult<DivisionListResponse>> getDivision() {
    return getResult(get(ApiUrls.geoDivision),
        (response) => DivisionListResponse.fromJson(response));
  }
}

class DistrictDataSourceImpl extends BaseDataSource
    implements DistrictDataSource {
  DistrictDataSourceImpl(super.dio);

  @override
  Future<BaseResult<DistrictListResponse>> getDistrict(int id) {
    return getResult(get('${ApiUrls.geoDistrict}/$id'),
        (response) => DistrictListResponse.fromJson(response));
  }
}

class UpazilaDataSourceImpl extends BaseDataSource
    implements UpazilaDataSource {
  UpazilaDataSourceImpl(super.dio);

  @override
  Future<BaseResult<UpazilaListResponse>> getUpazila(int id) {
    return getResult(get('${ApiUrls.geoThana}/$id'),
        (response) => UpazilaListResponse.fromJson(response));
  }
}

final divisionDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return DivisionDataSourceImpl(dio);
});

final districtDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return DistrictDataSourceImpl(dio);
});

final upazilaDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return UpazilaDataSourceImpl(dio);
});
