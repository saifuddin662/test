import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/edu_txn_info_model.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 02,April,2023.

class EduFeeDataController {
  EduFeeDataController._internal();

  factory EduFeeDataController() => instance;
  static final EduFeeDataController instance = EduFeeDataController._internal();

  EduTxnInfoModel eduTxnInfoModel = EduTxnInfoModel();
  bool isSavedChecked = false;
  bool fromSaved = false;

}

final eduFeeDataControllerProvider = Provider<EduFeeDataController>((_) => EduFeeDataController.instance);