import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/make_request_money_request.dart';
import 'model/make_request_money_response.dart';


abstract class MakeRequestMoneyDataSource {
  Future<BaseResult<MakeRequestMoneyResponse>> requestMoney(MakeRequestMoneyRequest makeRequestMoneyRequest);
}

class MakeRequestMoneyDataSourceImpl extends BaseDataSource implements MakeRequestMoneyDataSource {
  MakeRequestMoneyDataSourceImpl(super.dio);

  @override
  Future<BaseResult<MakeRequestMoneyResponse>> requestMoney(MakeRequestMoneyRequest makeRequestMoneyRequest) {
    return getResult(
        post(
            ApiUrls.makeRequestApi,
            {
              'requesterName' : makeRequestMoneyRequest.requesterName,
              'requestTo' : makeRequestMoneyRequest.requestTo,
              'receiverName' : makeRequestMoneyRequest.receiverName,
              'requestedAmount' : makeRequestMoneyRequest.requestedAmount,
              'pin': makeRequestMoneyRequest.pin,
            }),
            (response) => MakeRequestMoneyResponse.fromJson(response)
    );
  }
}

final makeRequestMoneyDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return MakeRequestMoneyDataSourceImpl(dio);
});
