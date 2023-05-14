import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/dynamic_utility/du_core/api/du_payment/model/du_payment_response.dart';
import 'package:red_cash_dfs_flutter/utils/api_urls.dart';
import '../../../../../core/di/network_provider.dart';
import '../../../../../core/networking/base/base_data_source.dart';
import '../../../../../core/networking/base/base_result.dart';
import 'model/du_payment_request.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 16,March,2023.

abstract class DuPaymentDataSource {
  Future<BaseResult<UtilityPaymentResponse>> utilityPayment(UtilityPaymentRequest utilityPaymentRequest);
}

class DuPaymentDataSourceImpl extends BaseDataSource
    implements DuPaymentDataSource {
  DuPaymentDataSourceImpl(super.dio);

  @override
  Future<BaseResult<UtilityPaymentResponse>> utilityPayment(UtilityPaymentRequest utilityPaymentRequest) {
    return getResult(
        post(
            ApiUrls.duBillPayment,
            utilityPaymentRequest.toMap()),
        (response) => UtilityPaymentResponse.fromJson(response));
  }
}

final utilityPaymentDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return DuPaymentDataSourceImpl(dio);
});
