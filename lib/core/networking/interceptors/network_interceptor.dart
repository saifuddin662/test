import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../common/toasts.dart';


class NetworkInterceptors extends InterceptorsWrapper {

  NetworkInterceptors();
  final Connectivity _connectivity = Connectivity();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var connectionResult = await _connectivity.checkConnectivity();
    if (connectionResult == ConnectivityResult.mobile) {
      return super.onRequest(options, handler);
    } else if (connectionResult == ConnectivityResult.wifi) {
      return super.onRequest(options, handler);
    } else {
      EasyLoading.dismiss();
      Toasts.showErrorToast("no_internet".tr());
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("[RESPONSE] : $response");
    return super.onResponse(response, handler);
  }
}
