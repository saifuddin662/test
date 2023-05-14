import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/get_transaction_id_request.dart';
import 'model/get_transaction_id_response.dart';

/**
 * Created by Md. Awon-Uz-Zaman on 25/2/23
 */

abstract class AddMoneyDataSource {
  Future<BaseResult<GetTransactionIdResponse>> getAddMoneyInfo(GetTransactionRequest getTransactionRequest);
}

class AddMoneyDataSourceImpl extends BaseDataSource implements AddMoneyDataSource {
  AddMoneyDataSourceImpl(super.dio);

  @override
  Future<BaseResult<GetTransactionIdResponse>> getAddMoneyInfo(GetTransactionRequest getTransactionRequest) {
    return getResult(
        get(
            ApiUrls.addMoneyInfo,
            params: {
              'amount': getTransactionRequest.amount
            }),
            (response) => GetTransactionIdResponse.fromJson(response)
    );
  }
}

final addMoneyDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return AddMoneyDataSourceImpl(dio);
});
