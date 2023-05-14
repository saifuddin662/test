import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/dynamic_utility/du_core/dynamic_view/model/utility_info_model.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 09,March,2023.

class DynamicUtilityDataController {
  DynamicUtilityDataController._internal();

  factory DynamicUtilityDataController() => instance;
  static final DynamicUtilityDataController instance =
      DynamicUtilityDataController._internal();

  Map<String, bool> requiredMap = {};
  Map<String, dynamic> fieldValue = {};
  UtilityInfoModel utilityInfo = UtilityInfoModel();
}

final dynamicUtilityDataControllerProvider =
    Provider<DynamicUtilityDataController>(
        (_) => DynamicUtilityDataController.instance);
