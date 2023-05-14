import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/network_provider.dart';
import '../../../core/networking/base/base_data_source.dart';
import '../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/check_balance_response.dart';


abstract class CheckBalanceDataSource {
  Future<BaseResult<CheckBalanceResponse>> checkBalance();
}

class CheckBalanceDataSourceImpl extends BaseDataSource implements CheckBalanceDataSource {
  CheckBalanceDataSourceImpl(super.dio);

  @override
  Future<BaseResult<CheckBalanceResponse>> checkBalance() async {
    final checkBalanceResult = getResult(
        post(ApiUrls.checkBalanceApi, null,
        ), (response) => CheckBalanceResponse.fromJson(response)
    );
    return checkBalanceResult;
  }
}

final checkBalanceDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return CheckBalanceDataSourceImpl(dio);
});