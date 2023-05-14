import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../utils/api_urls.dart';
import 'model/transaction_fee_request.dart';
import 'model/transaction_fee_response.dart';


abstract class TransactionFeeDataSource {
  Future<BaseResult<TransactionFeeResponse>> getTransactionFee(TransactionFeeRequest transactionFeeRequest);
}

class TransactionFeeDataSourceImpl extends BaseDataSource implements TransactionFeeDataSource {
  TransactionFeeDataSourceImpl(super.dio);

  @override
  Future<BaseResult<TransactionFeeResponse>> getTransactionFee(TransactionFeeRequest transactionFeeRequest) {
    return getResult(
        post(
            ApiUrls.feeChargeApi,
            {
              'fromUserNumber': transactionFeeRequest.fromUserNumber,
              'toUserNumber': transactionFeeRequest.toUserNumber,
              'transactionType': transactionFeeRequest.transactionType,
              'amount': transactionFeeRequest.amount
            }),
            (response) => TransactionFeeResponse.fromJson(response)
    );
  }
}

final transactionFeeDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return TransactionFeeDataSourceImpl(dio);
});
