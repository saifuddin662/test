import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/school_fees_request.dart';
import 'model/school_fees_response.dart';


abstract class RegistrationInfoDataSource {
  Future<BaseResult<SchoolFeesResponse>> getFees(SchoolFeesRequest schoolFeesRequest);
}

class RegistrationInfoDataSourceImpl extends BaseDataSource implements RegistrationInfoDataSource {
  RegistrationInfoDataSourceImpl(super.dio);

  @override
  Future<BaseResult<SchoolFeesResponse>> getFees(SchoolFeesRequest schoolFeesRequest) {
    return getResult(
        post(
            ApiUrls.schoolFees,
            {
              "insCode": schoolFeesRequest.insCode,
              "regId": schoolFeesRequest.regId
            }),
            (response) => SchoolFeesResponse.fromJson(response)
    );
  }
}

final schoolFeesDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return RegistrationInfoDataSourceImpl(dio);
});
