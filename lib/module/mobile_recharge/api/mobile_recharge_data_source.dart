import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/mobile_recharge_request.dart';
import 'model/mobile_recharge_response.dart';


abstract class MobileRechargeDataSource {
  Future<BaseResult<MobileRechargeResponse>> mobileRecharge(MobileRechargeRequest mobileRechargeRequest);
}

class MobileRechargeDataSourceImpl extends BaseDataSource implements MobileRechargeDataSource {
  MobileRechargeDataSourceImpl(super.dio);

  @override
  Future<BaseResult<MobileRechargeResponse>> mobileRecharge(MobileRechargeRequest mobileRechargeRequest) {
    return getResult(
        post(
            ApiUrls.mobileRechargeApi,
            {
              'secretKey': ApiUrls.topUpApiSecretKey,
              'recipientNumber': mobileRechargeRequest.recipientNumber,
              'amount': mobileRechargeRequest.amount,
              'connectionType': mobileRechargeRequest.connectionType,
              'operator': mobileRechargeRequest.operator,
              'isBundle': false,
              'pin': mobileRechargeRequest.pin,
            }),
            (response) => MobileRechargeResponse.fromJson(response)
    );
  }
}

final mobileRechargeDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return MobileRechargeDataSourceImpl(dio);
});
