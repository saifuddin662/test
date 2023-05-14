import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/send_money_request.dart';
import 'model/send_money_response.dart';


abstract class SendMoneyDataSource {
  Future<BaseResult<SendMoneyResponse>> sendMoney(SendMoneyRequest sendMoneyRequest);
}

class SendMoneyDataSourceImpl extends BaseDataSource implements SendMoneyDataSource {
  SendMoneyDataSourceImpl(super.dio);

  @override
  Future<BaseResult<SendMoneyResponse>> sendMoney(SendMoneyRequest sendMoneyRequest) {
    return getResult(
        post(
            ApiUrls.sendMoneyApi,
            {
              'recipientNumber': sendMoneyRequest.recipientNumber,
              'amount': sendMoneyRequest.amount,
              'pin': sendMoneyRequest.pin,
            }),
            (response) => SendMoneyResponse.fromJson(response)
    );
  }
}

final sendMoneyDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return SendMoneyDataSourceImpl(dio);
});
