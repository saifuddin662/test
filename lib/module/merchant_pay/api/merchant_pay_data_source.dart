import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/merchant_pay_request.dart';
import 'model/merchant_pay_response.dart';


abstract class MerchantPayDataSource {
  Future<BaseResult<MerchantPayResponse>> merchantPay(MerchantPayRequest merchantPayRequest);
}

class MerchantPayDataSourceImpl extends BaseDataSource implements MerchantPayDataSource {
  MerchantPayDataSourceImpl(super.dio);

  @override
  Future<BaseResult<MerchantPayResponse>> merchantPay(MerchantPayRequest merchantPayRequest) {
    return getResult(
        post(
            ApiUrls.merchantPayApi,
            {
              'recipientNumber': merchantPayRequest.recipientNumber,
              'amount': merchantPayRequest.amount,
              'txnType': merchantPayRequest.txnType,
              'pin': merchantPayRequest.pin,
            }),
            (response) => MerchantPayResponse.fromJson(response)
    );
  }
}

final merchantPayDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return MerchantPayDataSourceImpl(dio);
});
