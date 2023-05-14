import 'package:red_cash_dfs_flutter/ui/configs/colors/core_colors.dart';

import '../../core/flavor/flavors.dart';
import 'colors/first_cash_colors.dart';
import 'colors/red_cash_colors.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 08,May,2023.

class CoreBranding {
  Flavor flavor;

  CoreBranding(this.flavor);

  CoreColors colors = RedCashColors();
  String fontFamily = 'Akzentica';
  String logoBigBrand = 'assets/svg_files/ic_redcash_logo.svg';

  void setBrandData() {
    colors = getCoreColors(flavor);
    fontFamily = getFontFamily(flavor);
    logoBigBrand = getBigBrandLogo(flavor);
  }

  CoreColors getCoreColors(Flavor flavor) {
    switch (flavor) {
      case Flavor.REDCASH:
        return RedCashColors();
      case Flavor.FIRSTCASH:
        return FirstCashColors();
      default:
        return FirstCashColors();
    }
  }

  String getFontFamily(Flavor flavor) {
    switch (flavor) {
      case Flavor.REDCASH:
        return 'Stylish';
      case Flavor.FIRSTCASH:
        return 'Akzentica';
      default:
        return 'Akzentica';
    }
  }

  String getBigBrandLogo(Flavor flavor) {
    switch (flavor) {
      case Flavor.REDCASH:
        return 'assets/svg_files/ic_redcash_red.svg';
      case Flavor.FIRSTCASH:
        return 'assets/svg_files/first_cash_logo.svg';
      default:
        return 'assets/svg_files/first_cash_logo.svg';
    }
  }
}




