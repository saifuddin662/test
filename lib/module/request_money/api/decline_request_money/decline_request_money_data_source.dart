import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/decline_request_money_request.dart';
import 'model/decline_request_money_response.dart';


abstract class DeclineRequestMoneyDataSource {
  Future<BaseResult<DeclineRequestMoneyResponse>> declineMoney(DeclineRequestMoneyRequest declineRequestMoneyRequest);
}

class DeclineRequestMoneyDataSourceImpl extends BaseDataSource implements DeclineRequestMoneyDataSource {
  DeclineRequestMoneyDataSourceImpl(super.dio);

  @override
  Future<BaseResult<DeclineRequestMoneyResponse>> declineMoney(DeclineRequestMoneyRequest  declineRequestMoneyRequest) {
    return getResult(
        post(
            ApiUrls.declineMoneyApi,
            {
              'requestId': declineRequestMoneyRequest.requestId,
            }),
            (response) => DeclineRequestMoneyResponse.fromJson(response)
    );
  }
}

final declineRequestMoneyDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return DeclineRequestMoneyDataSourceImpl(dio);
});
