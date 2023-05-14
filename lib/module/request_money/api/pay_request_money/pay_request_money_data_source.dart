import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/pay_request_money_request.dart';
import 'model/pay_request_money_response.dart';


abstract class PayRequestMoneyDataSource {
  Future<BaseResult<PayRequestMoneyResponse>> payMoney(PayRequestMoneyRequest payRequestMoneyRequest);
}

class PayRequestMoneyDataSourceImpl extends BaseDataSource implements PayRequestMoneyDataSource {
  PayRequestMoneyDataSourceImpl(super.dio);

  @override
  Future<BaseResult<PayRequestMoneyResponse>> payMoney(PayRequestMoneyRequest payRequestMoneyRequest) {
    return getResult(
        post(
            ApiUrls.payMoneyApi,
            {
              'requestId': payRequestMoneyRequest.requestId,
              'transactionType': payRequestMoneyRequest.transactionType,
              'pin': payRequestMoneyRequest.pin,
            }),
            (response) => PayRequestMoneyResponse.fromJson(response)
    );
  }
}

final payRequestMoneyDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return PayRequestMoneyDataSourceImpl(dio);
});
