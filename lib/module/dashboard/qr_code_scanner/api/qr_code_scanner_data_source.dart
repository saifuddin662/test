import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/network_provider.dart';
import '../../../../core/networking/base/base_data_source.dart';
import '../../../../core/networking/base/base_result.dart';
import 'model/qr_code_scanner_response.dart';


abstract class QrCodeScannerDataSource {
  Future<BaseResult<QrCodeScannerResponse>> getQrCodeDetails(String getQrCodeDetails);
}

class QrCodeScannerImpl extends BaseDataSource implements QrCodeScannerDataSource {
  QrCodeScannerImpl(super.dio);

  @override
  Future<BaseResult<QrCodeScannerResponse>> getQrCodeDetails(String getQrCodeDetails) {
    return getResult(
        get(getQrCodeDetails), (response) => QrCodeScannerResponse.fromJson(response)
    );
  }
}

final qrCodeScannerDataSourceProvider = Provider((_) {
  final dio = _.watch(dioProvider);
  return QrCodeScannerImpl(dio);
});
