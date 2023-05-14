import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/ui/configs/core_branding.dart';

import '../../core/flavor/flavors.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 08,May,2023.

class BrandingDataController {
  BrandingDataController._internal();

  factory BrandingDataController() => instance;
  static final BrandingDataController instance = BrandingDataController._internal();
  
  CoreBranding branding = CoreBranding(Flavor.REDCASH);


}

final brandingDataControllerProvider = Provider<BrandingDataController>((_) => BrandingDataController.instance);