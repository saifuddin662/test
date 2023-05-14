import '../../module/confirm_pin/api/model/device_reg_model.dart';
import '../../module/ekyc/api/ekyc_status/api/model/ekyc_status_response.dart';
import '../../module/ekyc/ekyc_core/common_model/captured_photos.dart';
import '../../module/ekyc/ekyc_core/common_model/ekyc_infos.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 18,January,2023.

class GlobalDataController {
  GlobalDataController._internal();

  factory GlobalDataController() => instance;
  static final GlobalDataController instance =
      GlobalDataController._internal();

  String mno = "";
  String msisdn = "";
  String otpRef = "";
  String jwt = "";
  String phoneNo = "";
  String appInfo = "";
  bool isOtpInputEnabled = false;
  DeviceRegModel deviceRegModel = DeviceRegModel();
  CapturedPhotos capturedPhotos = CapturedPhotos();
  EkycInfos ekycInfos = EkycInfos();
  String ekycState = "";
  WalletData walletData = WalletData();
}
