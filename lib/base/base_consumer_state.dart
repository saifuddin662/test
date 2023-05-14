import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:red_cash_dfs_flutter/ui/configs/colors/core_colors.dart';

import '../ui/configs/branding_data_controller.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 08,May,2023.

abstract class BaseConsumerState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T> with WidgetsBindingObserver {
  Logger get log => Logger(T.toString());
  CoreColors get coreColors => BrandingDataController.instance.branding.colors;

  bool backIntercept(bool stopDefaultButtonEvent, RouteInfo info) {
    //log.info("=========================BACK PRESSED=========================");
    if (EasyLoading.isShow) {
      HapticFeedback.mediumImpact();
      log.info("loader showing, back press paused");
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    log.info("======================>[ $T -> initState ]<======================" );
    WidgetsBinding.instance.addObserver(this);
    BackButtonInterceptor.add(backIntercept);
    super.initState();
  }

  @override
  void dispose() {
    log.info("======================>[ $T -> DISPOSED ]<======================");
    WidgetsBinding.instance.removeObserver(this);
    BackButtonInterceptor.remove(backIntercept);
    super.dispose();
  }
}
