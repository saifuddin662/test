import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import '../../../../utils/api_urls.dart';
import 'model/my_qr_code_request.dart';
import 'model/my_qr_code_response.dart';


abstract class MyQrCodeDataSource {
  Future<BaseResult<MyQrCodeResponse>> getMyQrCode(MyQrCodeRequest myQrCodeRequest);
}

class MyQrCodeDataSourceImpl extends BaseDataSource implements MyQrCodeDataSource {
  MyQrCodeDataSourceImpl(super.dio);

  @override
  Future<BaseResult<MyQrCodeResponse>> getMyQrCode(MyQrCodeRequest myQrCodeRequest) {
    return getResult(
        post(
            ApiUrls.generateQrCodeApi,
            myQrCodeRequest.toJson()),
            (response) => MyQrCodeResponse.fromJson(response)
    );
  }

}

final myQrCodeSourceProvider = Provider((_) {final dio = _.watch(dioProvider);
  return MyQrCodeDataSourceImpl(dio);
});