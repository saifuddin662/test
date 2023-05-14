import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/cash_out_request.dart';
import 'model/cash_out_response.dart';


abstract class CashOutDataSource {
  Future<BaseResult<CashOutResponse>> cashOut(CashOutRequest cashOutRequest);
}

class CashOutDataSourceImpl extends BaseDataSource implements CashOutDataSource {
  CashOutDataSourceImpl(super.dio);

  @override
  Future<BaseResult<CashOutResponse>> cashOut(CashOutRequest cashOutRequest) {
    return getResult(
        post(
            ApiUrls.cashOutApi,
            {
              'agentAccountNo': cashOutRequest.agentAccountNo,
              'amount': cashOutRequest.amount,
              'pin': cashOutRequest.pin,
            }),
            (response) => CashOutResponse.fromJson(response)
    );
  }
}

final cashOutDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return CashOutDataSourceImpl(dio);
});
