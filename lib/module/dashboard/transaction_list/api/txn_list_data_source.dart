import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/txn_list_response.dart';


abstract class TxnListDataSource {
  Future<BaseResult<TxnListResponse>> getTxnList();
}

class TxnListDataSourceImpl extends BaseDataSource implements TxnListDataSource {
  TxnListDataSourceImpl(super.dio);

  @override
  Future<BaseResult<TxnListResponse>> getTxnList() {
    return getResult(post(ApiUrls.txnList, null), (response) => TxnListResponse.fromJson(response));
  }
}

final txnListDataSourceProvider = Provider.autoDispose((_) {
  final dio = _.watch(dioProvider);
  return TxnListDataSourceImpl(dio);
});