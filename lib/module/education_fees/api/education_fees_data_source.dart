import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/EducationFeesRequest.dart';
import 'model/education_fees_response.dart';


abstract class EducationFeesDataSource {
  Future<BaseResult<EducationFeesResponse>> educationFeePayment(EducationFeesRequest educationFeesRequest);
}

class EducationFeesDataSourceImpl extends BaseDataSource implements EducationFeesDataSource {
  EducationFeesDataSourceImpl(super.dio);

  @override
  Future<BaseResult<EducationFeesResponse>> educationFeePayment(EducationFeesRequest educationFeesRequest) {
    return getResult(
        post(
            ApiUrls.schoolPayment,
            {
              'fromAc': ApiUrls.topUpApiSecretKey,
              'pin': educationFeesRequest.pin,
              'schoolPaymentInfo': educationFeesRequest.schoolPaymentInfo,
              'toAc': educationFeesRequest.toAc,
              'userType': educationFeesRequest.userType,
            }),
            (response) => EducationFeesResponse.fromJson(response)
    );
  }
}

final educaitonFeesDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return EducationFeesDataSourceImpl(dio);
});
